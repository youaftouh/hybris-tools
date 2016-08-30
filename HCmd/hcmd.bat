REM #####################
REM # Simple Script for #
REM #  Hybris Commands  #
REM #####################

TITLE Hybris Commands
REM ##Change screen size
MODE CON cols=195 lines=1050
REM ##Change Colour
Color 0A
@ECHO OFF
REM INIT VARS
REM ##Setting ANT Variable 
CALL setantenv.bat
REM ##Setting AMQ Home Directory
SET AMQ_HOME=D:\apache-activemq-5.9.0
REM ##Setting Database Backup file
SET DB_BACKUP=C:\Users\user\Desktop\Backup_DB
REM ##Setting SVN Logs Directory
SET SVN_DIR=C:\Users\user\Desktop\SVN
REM ##Setting SVN URL Repository
SET SVN_REPO=https://subversion.example.com/project
CLS
ECHO Hybris Project
ECHO Date : %date%, Time : %time%
:MENU
ECHO.
ECHO ---------- Hybris Commands Menu ----------
ECHO 1.  ANT
ECHO 2.  ANT CLEAN ALL
ECHO 3.  Start Hybris Server debug mode
ECHO 4.  Start Hybris Server normal mode
ECHO 5.  ANT BUILD
ECHO 6.  ANT Production
ECHO 7.  ANT Sonar
REM ECHO 8.  Start ActiveMQ Server (custom:Edit Action First)
REM ECHO 9.  Get Server MysqlDump and Media (custom:Edit Action First)
REM ECHO 10.  Dump Local Database (custom:Edit Action First)
REM ECHO 11.  Restore Existing Database (custom:Edit Action First)
REM ECHO 12.  Execute activeMQJob (custom:Edit Action First)
REM ECHO 13. JAXBGEN (custom:Edit Action First)
REM ECHO 14. Commit History (custom:Edit Action First)
REM ECHO 15. Switch Workspace (custom:Edit Action First)
ECHO 0.  Exit
ECHO ------------------------------------------
ECHO Choose : 
:CHOOSE
SET N=
SET /p N=
IF [%N%] == []   GOTO CHOOSE 
IF [%N%] == [1]  GOTO ANT
IF [%N%] == [2]  GOTO ANTCA
IF [%N%] == [3]  GOTO HSSD
IF [%N%] == [4]  GOTO HSS
IF [%N%] == [5] GOTO ANTB
IF [%N%] == [6] GOTO ANTP
IF [%N%] == [7] GOTO ANTS
REM IF [%N%] == [8]  GOTO AMQS
REM IF [%N%] == [9]  GOTO GSD
REM IF [%N%] == [10]  GOTO DLD
REM IF [%N%] == [11]  GOTO RED
REM IF [%N%] == [12]  GOTO MQJ
REM IF [%N%] == [13] GOTO JAXB
REM IF [%N%] == [14] GOTO COMH
REM IF [%N%] == [15] GOTO SWIT
IF [%N%] == [0]  GOTO EXIT


CLS

ECHO ========INVALID INPUT========
ECHO -----------------------------
ECHO    Please select a number  
ECHO   From the Main Menu [0-10]
ECHO -----------------------------
ECHO ==PRESS ANY KEY TO CONTINUE==

PAUSE > NUL
GOTO MENU

:ANT
CALL ant
GOTO MENU

:ANTCA
CALL ant clean all
GOTO MENU

:HSSD
CALL hybrisserver.bat debug
GOTO MENU

:HSS
CALL hybrisserver.bat
GOTO MENU

:AMQS
START %AMQ_HOME%\bin\activemq
CLS
GOTO MENU

:GSD
CALL ant get_srv_data
GOTO MENU

:DLD
SET ddbfile=%DB_BACKUP%\aus_DB.sql
ECHO Dumping Local Database databaseTable To : %ddbfile% ...
CALL mysqldump -u root -proot databaseTable > %ddbfile%
GOTO MENU

:RED
SET rdbfile=%DB_BACKUP%\aus_DB.sql
ECHO Restoring databaseTable Database from : %rdbfile% ...
if exist %rdbfile% (
CALL mysql -u root -proot databaseTable < %rdbfile%
ECHO Done.
) else (
    ECHO  SQL Backup File doesn't exist..
)
GOTO MENU

:MQJ
ECHO Make sure you have placed product xml file(s) to import
PAUSE
CALL ant runcronjob -Dcronjob=activeMQCronJob -Dtenant=master
GOTO MENU

:ANTB
CALL ant build
GOTO MENU

:JAXB
CD D:\Projets-Git\Project\hybris\bin\custom\project\extension\
CALL ant jaxbgen
CD D:\Projets-Git\Project\hybris\bin\platform\
GOTO MENU

:COMH
ECHO == SVN command utility no longer supported ==
REM ECHO Enter Begin Date (yyyy-mm-dd) : 
REM SET /p begin=
REM ECHO Enter End Date (yyyy-mm-dd) : 
REM SET /p end=
REM IF NOT EXIST %SVN_DIR% mkdir %SVN_DIR%
REM CALL svn log %SVN_REPO% -v -r {%begin%}:{%end%} > %SVN_DIR%\from_%begin%_to_%end%.log
REM START /B notepad %SVN_DIR%\from_%begin%_to_%end%.log
GOTO MENU

:ANTP
CALL ant production
GOTO MENU

:ANTS
CALL ant sonar
GOTO MENU

:SWIT
ECHO.
ECHO ---------- Switch To ----------
ECHO 1.  Trunk (5.5)
ECHO 2.  Branch (5.1) - 2015.9.x
ECHO -------------------------------
ECHO Choose : 
SET S=
SET /p S=
IF [%S%] == [1]  GOTO TRUNK
IF [%S%] == [2]  GOTO BRANCH
ECHO ========INVALID INPUT========
GOTO MENU
:TRUNK
CD D:\Projets\Project\hybris-5.5\bin\platform
SET JAVA_HOME=C:\Program Files\Java\jdk1.8.0_66
CALL setantenv.bat
CLS
GOTO MENU
:BRANCH
CD D:\Projets\Project\hybris\bin\platform
SET JAVA_HOME=C:\Program Files\Java\jdk1.7.0_67
CALL setantenv.bat
CLS
GOTO MENU

:EXIT
