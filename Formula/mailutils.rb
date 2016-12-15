class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "http://mailutils.org/"
  url "https://ftpmirror.gnu.org/mailutils/mailutils-3.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/mailutils/mailutils-3.1.tar.gz"
  sha256 "65c8a4f9a59904ba1035c0f891cba03a6ccdd8ac841c22dac0905ed994fd8f1a"

  bottle do
    sha256 "3a2d771c6ff402a0345e263f1ca24775cd8a3c153f69ee00006ac1eb3ee14cbc" => :sierra
    sha256 "e43b4f89247eef6735f65cf474e31b2d4f6a21d95c8bdda843f2b8e91b08f345" => :el_capitan
    sha256 "43af4b9eab94c5af57aa35e4d44312834ca66b14d456030233f6820a96d53621" => :yosemite
  end

  depends_on "libtool" => :build
  depends_on "gnutls"
  depends_on "gsasl"
  depends_on "readline"

  # Remove second patch (the restoration of argcv.h) for > 3.1
  # See upstream commit "Restore prematurely deleted header"
  # http://git.savannah.gnu.org/cgit/mailutils.git/commit/?id=723ade1ac72fa2635d7aa04f6a118cefce44f15a
  patch :DATA

  def install
    system "./configure", "--disable-mh",
                          "--prefix=#{prefix}",
                          "--without-tokyocabinet"
    system "make", "PYTHON_LIBS=-undefined dynamic_lookup", "install"

    # Remove for > 3.1
    (include/"mailutils").install "include/mailutils/argcv.h"
  end

  test do
    system "#{bin}/movemail", "--version"
  end
end

__END__
diff --git a/libmailutils/sockaddr/str.c b/libmailutils/sockaddr/str.c
index e5bd5a1..6de2647 100644
--- a/libmailutils/sockaddr/str.c
+++ b/libmailutils/sockaddr/str.c
@@ -25,6 +25,7 @@
 #include <netinet/in.h>
 #include <arpa/inet.h>
 #include <netdb.h>
+#include <stdlib.h>

 #include <mailutils/sockaddr.h>
 #include <mailutils/errno.h>
diff --git a/include/mailutils/argcv.h b/include/mailutils/argcv.h
new file mode 100644
index 0000000..4744fb5
--- /dev/null
+++ b/include/mailutils/argcv.h
@@ -0,0 +1,54 @@
+/* GNU Mailutils -- a suite of utilities for electronic mail
+   Copyright (C) 1999-2001, 2005, 2007, 2010-2012, 2014-2016 Free
+   Software Foundation, Inc.
+
+   This library is free software; you can redistribute it and/or
+   modify it under the terms of the GNU Lesser General Public
+   License as published by the Free Software Foundation; either
+   version 3 of the License, or (at your option) any later version.
+
+   This library is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+   Lesser General Public License for more details.
+
+   You should have received a copy of the GNU Lesser General
+   Public License along with this library.  If not, see
+   <http://www.gnu.org/licenses/>. */
+
+#ifndef _ARGCV_H
+#define _ARGCV_H 1
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+
+#include <mailutils/types.h>
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+void mu_argcv_free (size_t argc, char **argv);
+void mu_argv_free (char **argv);
+
+enum mu_argcv_escape
+  {
+    mu_argcv_escape_no,
+    mu_argcv_escape_c
+    /*    mu_argcv_escape_sh */
+  };
+
+int mu_argcv_join (int argc, char **argv, char *delim,
+		   enum mu_argcv_escape esc,
+		   char **pstring);
+void mu_argcv_remove (int *pargc, char ***pargv,
+		      int (*sel) (const char *, void *), void *);
+int mu_argcv_string (int argc, char **argv, char **string);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif /* _ARGCV_H */
