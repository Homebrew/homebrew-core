class Mpack < Formula
  desc "MIME mail packing and unpacking"
  homepage "https://web.archive.org/web/20190220145801/ftp.andrew.cmu.edu/pub/mpack/"
  url "https://ftp.gwdg.de/pub/misc/mpack/mpack-1.6.tar.gz"
  mirror "https://fossies.org/linux/misc/old/mpack-1.6.tar.gz"
  sha256 "274108bb3a39982a4efc14fb3a65298e66c8e71367c3dabf49338162d207a94c"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47bd4a5b967d0d67f6e71bde23a5578fc61a8afdd90b6bac7ae007b6ec1e7058"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "590ebe27e3a84b46df9a304a6207a0d6754ed71dd04892aa965eed9315240c48"
    sha256 cellar: :any_skip_relocation, monterey:       "dc71738af5d7167731cd69a6608fefbd6ee509ca87cd57ede2680799344ce0de"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3ac3a2ad7ba9481bdbd6ce2c2a3e1d0e59128f4cf8cd846be7a75fc6f27d6b5"
    sha256 cellar: :any_skip_relocation, catalina:       "561bc78b36f0b0cb8b67ff4c59407439fcb70d7f0b0ed23313cbe7579ad6a00f"
    sha256 cellar: :any_skip_relocation, mojave:         "3da5fac96c17669d27049ec2b5eebc0b711258ece13dad09c609792b45498bbc"
  end

  # Fix missing return value; clang refuses to compile otherwise
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/1ad38a9c/mpack/uudecode.c.patch"
    sha256 "52ad1592ee4b137cde6ddb3c26e3541fa0dcea55c53ae8b37546cd566c897a43"
  end

  # Fix build failure because of missing include statements on Linux.
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end

__END__
diff --git a/unixos.c b/unixos.c
index 243a7be..c7008d6 100644
--- a/unixos.c
+++ b/unixos.c
@@ -23,6 +23,7 @@
  * SOFTWARE.
  */
 #include <stdio.h>
+#include <stdlib.h>
 #include <ctype.h>
 #include <string.h>
 #include <errno.h>
@@ -38,10 +39,6 @@
 #define MAXHOSTNAMELEN 64
 #endif
 
-extern int errno;
-extern char *malloc();
-extern char *getenv();
-
 int overwrite_files = 0;
 int didchat;
 
diff --git a/unixpk.c b/unixpk.c
index 144e34d..1c70779 100644
--- a/unixpk.c
+++ b/unixpk.c
@@ -23,6 +23,9 @@
  * SOFTWARE.
  */
 #include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <getopt.h>
 #include <string.h>
 #include <errno.h>
 #include "common.h"
@@ -31,12 +34,6 @@
 
 #define MAXADDRESS 100
 
-extern char *getenv();
-
-extern int errno;
-extern int optind;
-extern char *optarg;
-
 void usage(void);
 void sendmail(FILE *infile, char **addr, int start);
 void inews(FILE *infile);
diff --git a/unixunpk.c b/unixunpk.c
index a1f065b..0f5fa85 100644
--- a/unixunpk.c
+++ b/unixunpk.c
@@ -23,6 +23,7 @@
  * SOFTWARE.
  */
 #include <stdio.h>
+#include <stdlib.h>
 #include "version.h"
 #include "part.h"
 
diff --git a/xmalloc.c b/xmalloc.c
index 7c74360..d5f3909 100644
--- a/xmalloc.c
+++ b/xmalloc.c
@@ -23,8 +23,8 @@
  * SOFTWARE.
  */
 #include <stdio.h>
+#include <stdlib.h>
 #include <string.h>
-extern char *malloc(), *realloc();
 
 char *xmalloc (int size)
 {
