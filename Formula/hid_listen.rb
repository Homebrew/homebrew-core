class HidListen < Formula
  desc "Prints out debugging information from usb hid devices"
  homepage "https://www.pjrc.com/teensy/hid_listen.html"

  stable do
    url "https://www.pjrc.com/teensy/hid_listen_1.01.zip"
    sha256 "9cc73e325dc9265c032c295d93e16aad63e01214f69ee788b0b80cbc16d3b076"
    patch :DATA
  end

  def install
    system "make", "hid_listen"
    bin.install "hid_listen"
  end

  test do
    system "true"
  end
end

__END__
diff -ruN --exclude .git hid_listen/Makefile hid_listen-git/Makefile
--- hid_listen/Makefile	2009-09-21 17:52:39.000000000 +0200
+++ hid_listen-git/Makefile	2018-04-12 09:55:31.000000000 +0200
@@ -1,7 +1,7 @@
 PROG = hid_listen

-OS = LINUX
-#OS = DARWIN
+#OS = LINUX
+OS = DARWIN
 #OS = WINDOWS


@@ -15,9 +15,8 @@
 TARGET = $(PROG)
 CC = gcc
 STRIP = strip
-SDK = /Developer/SDKs/MacOSX10.5.sdk
-CFLAGS = -O2 -Wall -isysroot $(SDK) -D$(OS) -arch ppc -arch i386
-LIBS = -Xlinker -syslibroot -Xlinker $(SDK) -framework IOKit -framework CoreFoundation
+CFLAGS = -O2 -Wall -D$(OS) -arch x86_64
+LIBS = -framework IOKit -framework CoreFoundation
 else ifeq ($(OS), WINDOWS)
 TARGET = $(PROG).exe
 CC = i586-mingw32msvc-gcc
diff -ruN --exclude .git hid_listen/rawhid.c hid_listen-git/rawhid.c
--- hid_listen/rawhid.c	2008-12-18 00:05:57.000000000 +0100
+++ hid_listen-git/rawhid.c	2018-04-12 09:54:42.000000000 +0200
@@ -50,7 +50,7 @@
 /**                                                                     **/
 /*************************************************************************/

-#if defined(LINUX) || defined(__LINUX__) || #system(linux)
+#if defined(LINUX) || defined(__LINUX__)
 #define OPERATING_SYSTEM linux
 #include <fcntl.h>
 #include <errno.h>
