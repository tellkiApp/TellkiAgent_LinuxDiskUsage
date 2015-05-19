###################################################################################################################
## This script was developed by Guberni and is part of Tellki monitoring solution                     		 	 ##
##                                                                                                      	 	 ##
## December, 2014                     	                                                                	 	 ##
##                                                                                                      	 	 ##
## Version 1.0                                                                                          	 	 ##
##																									    	 	 ##
## DESCRIPTION: Monitor file system space utilization														 	 ##
##																											 	 ##
## SYNTAX: ./DiskUsage_Linux.sh <METRIC_STATE>             													 	 ##
##																											 	 ##
## EXAMPLE: ./DiskUsage_Linux.sh "1,1,0"         														     	 ##
##																											 	 ##
##                                      ############                                                    	 	 ##
##                                      ## README ##                                                    	 	 ##
##                                      ############                                                    	 	 ##
##																											 	 ##
## This script is used combined with runremote.sh script, but you can use as standalone. 			    	 	 ##
##																											 	 ##
## runremote.sh - executes input script locally or at a remove server, depending on the LOCAL parameter.	 	 ##
##																											 	 ##
## SYNTAX: sh "runremote.sh" <HOST> <METRIC_STATE> <USER_NAME> <PASS_WORD> <TEMP_DIR> <SSH_KEY> <LOCAL> 	 	 ##
##																											 	 ##
## EXAMPLE: (LOCAL)  sh "runremote.sh" "DiskUsage_Linux.sh" "192.168.1.1" "1,1,0" "" "" "" "" "1"            	 ##
## 			(REMOTE) sh "runremote.sh" "DiskUsage_Linux.sh" "192.168.1.1" "1,1,0" "user" "pass" "/tmp" "null" "0"##
##																											 	 ##
## HOST - hostname or ip address where script will be executed.                                         	 	 ##
## METRIC_STATE - is generated internally by Tellki and its only used by Tellki default monitors.       	 	 ##
##         		  1 - metric is on ; 0 - metric is off					              						 	 ##
## USER_NAME - user name required to connect to remote host. Empty ("") for local monitoring.           	 	 ##
## PASS_WORD - password required to connect to remote host. Empty ("") for local monitoring.            	 	 ##
## TEMP_DIR - (remote monitoring only): directory on remote host to copy scripts before being executed.		 	 ##
## SSH_KEY - private ssh key to connect to remote host. Empty ("null") if password is used.                 	 ##
## LOCAL - 1: local monitoring / 0: remote monitoring                                                   	 	 ##
###################################################################################################################

#METRIC_ID
UsedSpaceID="40:Used Space:4"
FreeSpaceID="24:Free Space:4"
PerFreeSpaceID="11:% Used Space:6"

#INPUTS
UsedSpaceID_on=`echo $1 | awk -F',' '{print $3}'`
FreeSpaceID_on=`echo $1 | awk -F',' '{print $2}'`
PerFreeSpaceID_on=`echo $1 | awk -F',' '{print $1}'`


if [ -f /.dockerinit ]; then
	# Docker Enviroment
	for fs in `cat /host/etc/mtab | grep -v "#" | grep -E " ext| ntfs| nfs| vfat| fat| xfs| zfs| smbfs| reiserfs| hfs| hfsplus| jfs" | awk '{print $2}'`
	do
		if [ -d $fs ]
			then
			fs_info=`df -k $fs | grep "%"| grep -v Filesystem | grep ${fs}$ |sed -e 's/%//g' | awk '{ print $NF,$(NF-1),int($(NF-2)/1024),int($(NF-3)/1024) }'`
			if [ $PerFreeSpaceID_on -eq 1 ]
			then
					PerFreeSpace=`echo $fs_info | awk '{print $2}'`
					if [ "$PerFreeSpace" = "" ]
					then
							#Unable to collect metrics
							continue
					fi
			fi
			if [ $FreeSpaceID_on -eq 1 ]
			then
					FreeSpace=`echo $fs_info | awk '{print $3}'`
					if [ "$FreeSpace" = "" ]
					then
							#Unable to collect metrics
							continue
					fi
			fi
			if [ $UsedSpaceID_on -eq 1 ]
			then
					UsedSpace=`echo $fs_info | awk '{print $4}'`
					if [ "$UsedSpace" = "" ]
					then
							#Unable to collect metrics
							continue
					fi
			fi

			# Send Metrics
			if [ $PerFreeSpaceID_on -eq 1 ]
			then
					echo "$PerFreeSpaceID|$PerFreeSpace|$fs|"
			fi
			if [ $FreeSpaceID_on -eq 1 ]
			then
					echo "$FreeSpaceID|$FreeSpace|$fs|"
			fi
			if [ $UsedSpaceID_on -eq 1 ]
			then
					echo "$UsedSpaceID|$UsedSpace|$fs|"
			fi
		fi
	done
else
	# Server environment
	for fs in `cat /etc/mtab | grep -v "#" | grep -E " ext| ntfs| nfs| vfat| fat| xfs| zfs| smbfs| reiserfs| hfs| hfsplus| jfs" | awk '{print $2}'`
	do
		if [ -d $fs ]
			then
			fs_info=`df -k $fs | grep "%"| grep -v Filesystem | grep ${fs}$ |sed -e 's/%//g' | awk '{ print $NF,$(NF-1),int($(NF-2)/1024),int($(NF-3)/1024) }'`
			if [ $PerFreeSpaceID_on -eq 1 ]
			then
					PerFreeSpace=`echo $fs_info | awk '{print $2}'`
					if [ "$PerFreeSpace" = "" ]
					then
							#Unable to collect metrics
							continue
					fi
			fi
			if [ $FreeSpaceID_on -eq 1 ]
			then
					FreeSpace=`echo $fs_info | awk '{print $3}'`
					if [ "$FreeSpace" = "" ]
					then
							#Unable to collect metrics
							continue
					fi
			fi
			if [ $UsedSpaceID_on -eq 1 ]
			then
					UsedSpace=`echo $fs_info | awk '{print $4}'`
					if [ "$UsedSpace" = "" ]
					then
							#Unable to collect metrics
							continue
					fi
			fi

			# Send Metrics
			if [ $PerFreeSpaceID_on -eq 1 ]
			then
					echo "$PerFreeSpaceID|$PerFreeSpace|$fs|"
			fi
			if [ $FreeSpaceID_on -eq 1 ]
			then
					echo "$FreeSpaceID|$FreeSpace|$fs|"
			fi
			if [ $UsedSpaceID_on -eq 1 ]
			then
					echo "$UsedSpaceID|$UsedSpace|$fs|"
			fi
		fi
	done
fi
	
