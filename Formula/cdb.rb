class Cdb < Formula
  desc "Create and read constant databases"
  homepage "https://cr.yp.to/cdb.html"
  url "https://cr.yp.to/cdb/cdb-0.75.tar.gz"
  sha256 "1919577799a50c080a8a05a1cbfa5fa7e7abc823d8d7df2eeb181e624b7952c5"

  livecheck do
    url "https://cr.yp.to/cdb/install.html"
    regex(/href=.*?cdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7516272a59a2e3f387bd50b183a2238d9c5333b788cd1f3484ca15ca3c198c8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6641aee9a21258f66441e250aa172ea092731be3ead3ae1b85393188d16dd61d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9136d67f3a62785add35b9b205169b9ace86da2c86edf4fe1c16cb833465bf5"
    sha256 cellar: :any_skip_relocation, ventura:        "88b43291068dbbea67161b415370ea6d09c0663ab3ec8eb052ff02bb8df9bec4"
    sha256 cellar: :any_skip_relocation, monterey:       "6417a2118fe06cb58aaa4a1d8181e9192c6598b4b8712ee2e3fdba0537996aaa"
    sha256 cellar: :any_skip_relocation, big_sur:        "9684789ff31a9f66e863c5ddce337ddc056fbea3f2d321d5752a6ec00a3d88c1"
    sha256 cellar: :any_skip_relocation, catalina:       "055cbaab9c15fe3f4b29dac36558497937eea6643c8ccf0cc4a9ee2c427fcff2"
    sha256 cellar: :any_skip_relocation, mojave:         "49748511d9e05e7ae4158ca4e4bbf14af858686f0104c85240de06b2acfe9b9c"
    sha256 cellar: :any_skip_relocation, high_sierra:    "f187d9ff7ddb1a1532e83924d32d02521afc943738e4b21c79da5712340b0bbb"
    sha256 cellar: :any_skip_relocation, sierra:         "16b08929c8c42feeb2df4eaed5b46967eca487aaa20585dc5869ba44a28f0fe8"
    sha256 cellar: :any_skip_relocation, el_capitan:     "ac5a34c222875d86113275127632fe02ccc15c0332c7719cdac8321aa0f83bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e39c6409d00f0176fd3bd2def3b15b555d5ea89d3b0f6dc9710f1ce61a442e99"
  end

  # Fix build failure because of missing #include errno.h on LInux.
  # Patch has been submitted to the cdb mailing list.
  patch :DATA

  def install
    inreplace "conf-home", "/usr/local", prefix
    system "make", "setup"
  end

  test do
    record = "+4,8:test->homebrew\n\n"
    pipe_output("#{bin}/cdbmake db dbtmp", record, 0)
    assert_predicate testpath/"db", :exist?
    assert_equal(record,
                 pipe_output("#{bin}/cdbdump", (testpath/"db").binread, 0))
  end
end

__END__
diff --git a/alloc.c b/alloc.c
index c661453..c466cc9 100644
--- a/alloc.c
+++ b/alloc.c
@@ -1,5 +1,6 @@
 #include "alloc.h"
 #include "error.h"
+#include "errno.h"
 extern char *malloc();
 extern void free();
 
diff --git a/buffer_get.c b/buffer_get.c
index 937b75e..661bd1a 100644
--- a/buffer_get.c
+++ b/buffer_get.c
@@ -1,6 +1,7 @@
 #include "buffer.h"
 #include "byte.h"
 #include "error.h"
+#include "errno.h"
 
 static int oneread(int (*op)(),int fd,char *buf,unsigned int len)
 {
diff --git a/buffer_put.c b/buffer_put.c
index a05e1f5..1f07541 100644
--- a/buffer_put.c
+++ b/buffer_put.c
@@ -2,6 +2,7 @@
 #include "str.h"
 #include "byte.h"
 #include "error.h"
+#include "errno.h"
 
 static int allwrite(int (*op)(),int fd,char *buf,unsigned int len)
 {
diff --git a/cdb.c b/cdb.c
index b09d3a5..54db474 100644
--- a/cdb.c
+++ b/cdb.c
@@ -5,6 +5,7 @@
 #include <sys/mman.h>
 #include "readwrite.h"
 #include "error.h"
+#include "errno.h"
 #include "seek.h"
 #include "byte.h"
 #include "cdb.h"
diff --git a/cdb_make.c b/cdb_make.c
index 6d1bd03..b3f8fc7 100644
--- a/cdb_make.c
+++ b/cdb_make.c
@@ -3,6 +3,7 @@
 #include "readwrite.h"
 #include "seek.h"
 #include "error.h"
+#include "errno.h"
 #include "alloc.h"
 #include "cdb.h"
 #include "cdb_make.h"
diff --git a/cdbmake.c b/cdbmake.c
index 3c1c8bd..34a459a 100644
--- a/cdbmake.c
+++ b/cdbmake.c
@@ -1,4 +1,5 @@
 #include "error.h"
+#include "errno.h"
 #include "open.h"
 #include "strerr.h"
 #include "cdb_make.h"
diff --git a/install.c b/install.c
index 605fed3..9ce1e04 100644
--- a/install.c
+++ b/install.c
@@ -1,6 +1,7 @@
 #include "buffer.h"
 #include "strerr.h"
 #include "error.h"
+#include "errno.h"
 #include "open.h"
 #include "readwrite.h"
 #include "exit.h"
diff --git a/instcheck.c b/instcheck.c
index c945e67..8a69a78 100644
--- a/instcheck.c
+++ b/instcheck.c
@@ -2,6 +2,7 @@
 #include <sys/stat.h>
 #include "strerr.h"
 #include "error.h"
+#include "errno.h"
 #include "readwrite.h"
 #include "exit.h"
 
diff --git a/strerr_sys.c b/strerr_sys.c
index b484197..3e98cfa 100644
--- a/strerr_sys.c
+++ b/strerr_sys.c
@@ -1,4 +1,5 @@
 #include "error.h"
+#include "errno.h"
 #include "strerr.h"
 
 struct strerr strerr_sys;
