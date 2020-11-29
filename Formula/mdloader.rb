class Mdloader < Formula
  desc "Massdrop Firmware Loader"
  homepage "https://github.com/Massdrop/mdloader"
  url "https://github.com/Massdrop/mdloader/archive/1.0.5.tar.gz"
  sha256 "2b2e88e2d66165f2160a0673dcacd94dbcb4f96c855fc0b4923ae569cd8f9e34"
  head "https://github.com/Massdrop/mdloader"

  patch :DATA

  def install
    system "make", "prefix=#{prefix}"

    Dir.chdir "build"
    bin.install "mdloader"
    pkgshare.install Dir.glob("applet-*.bin")
  end

  test do
    assert_match "Massdrop Loader", shell_output("#{bin}/mdloader")
  end
end

__END__
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 OUTNAME = mdloader
 OBJDIR = build
 CC = gcc
-CFLAGS = -Wall -std=gnu99
+CFLAGS = -Wall -std=gnu99 -DPKGDATADIR='"$(prefix)/share/mdloader"'
 
 SRCFILES = mdloader_common.c mdloader_parser.c
 ifeq ($(OS),Windows_NT)
--- a/mdloader_common.c
+++ b/mdloader_common.c
@@ -179,6 +179,12 @@ int print_mail(mailbox_t *mail)
     return 1;
 }
 
+void get_applet_path(char *filename, char *applet_path)
+{
+    strcpy(applet_path, PKGDATADIR);
+    strcat(applet_path, filename);
+}
+
 //Run applet command and wait for device response
 //Return 1 on sucess, 0 on failure
 int run_applet(mailbox_t *mail)
@@ -754,14 +760,21 @@ int main(int argc, char *argv[])
     //Load applet
     FILE *fIn;
     char appletfname[128] = "";
+    char appletfpath[PATH_MAX] = "";
     strlower(mcu->name);
 
     //sprintf(appletfname, "applet-flash-%s.bin", mcu->name);
     sprintf(appletfname, "applet-mdflash.bin");  //make filename non-dependent upon mcu->name
+    strcpy(appletfpath, appletfname);
       
     printf("Applet file: %s\n", appletfname);
 
-    fIn = fopen(appletfname, "rb");
+    fIn = fopen(appletfpath, "rb"); // Try in CWD first
+    if (!fIn)
+    {
+        get_applet_path(appletfname, appletfpath); // If not in CWD, look in $PREFIX/share/mdloader
+        fIn = fopen(appletfpath, "rb");
+    }
     if (!fIn)
     {
         printf("Error: Could not open applet file: %s\n", appletfname);
@@ -773,7 +786,7 @@ int main(int argc, char *argv[])
         int filebytes;
         int readbytes;
 
-        filebytes = filesize(appletfname);
+        filebytes = filesize(appletfpath);
         if (filebytes == 0)
         {
             printf("Error: Applet file is empty!\n");
--- a/mdloader_common.h
+++ b/mdloader_common.h
@@ -47,6 +47,12 @@
 #include <stdint.h>
 #include <getopt.h>
 
+#if defined(__APPLE__) && defined(__MACH__)
+#include <sys/syslimits.h>
+#else
+#include <linux/limits.h>
+#endif
+
 //Atmel files
 #include "./atmel/applet.h"
 #include "./atmel/status_codes.h"
@@ -129,6 +135,7 @@ int print_mail(mailbox_t *mail);
 #define APPLET_RETRY_NORMAL     10  //Normal operation retries
 #define APPLET_RETRY_ERASE      25  //Erase operation retries
 
+void get_applet_path(char *filename, char *applet_path);
 int run_applet(mailbox_t *mail);
 
 void display_version(void);
