#!/bin/sh -- or bash or ksh


date=`date '+%m/%d/%Y'`

Result=`cat /home/ibrahim/scripts/Te_check.csv`
ERR='{"status":4,"data":"your account was disabled please check custmer service"}'

#Connect to SQL DB & Run Query to check the error on TE_TX
echo "Please check TE Service : date now is $date" >  /home/ibrahim/scripts/Te_check.csv
echo "=================================" >> /home/ibrahim/scripts/Te_check.csv
sqlcmd -S 10.90.3.151,1433 -U Mohamed -P 123456 -d momken -Q "select  top(1)charge_status  from TE_log where  AddedTime > DATEADD(minute, -5,  GETDATE()) and charge_status = ' $ERR ' ;" >/home/ibrahim/scripts/Te_check.csv

output=`grep 'status":4' /home/ibrahim/scripts/Te_check.csv`
status=$?

if [ $status -eq 0 ]; then
mail -s "TE_Check" technical.operations@momkn.com.eg < /home/ibrahim/scripts/Te_check.csv
fi
