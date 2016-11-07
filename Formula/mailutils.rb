class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "http://mailutils.org/"
  url "https://ftpmirror.gnu.org/mailutils/mailutils-3.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/mailutils/mailutils-3.0.tar.gz"
  sha256 "41e5a1e9b1da1efd184b4cb3ed8e88bb3013ff09f9774b15a65253ff31db2f9f"

  bottle do
    sha256 "bdc449caa3a5fc24e634838c04580c91534f5e33513c390d2d0f1005492ecb29" => :sierra
    sha256 "c7c974534ca6db72c3516a777763c94080b3a45d867b393a048d4f681edce5d6" => :el_capitan
    sha256 "e7bc5e495d073e9a9630524c1a77408e530cc2659ff79ea63354b2b7bf168231" => :yosemite
    sha256 "1568cfc945f5ec8c06936b583aab81966bff79fc78fb064cdb8788f4c8c82dac" => :mavericks
  end

  depends_on "gnutls"
  depends_on "gsasl"
  depends_on "readline"

  patch :DATA

  def install
    # Python breaks the build (2014-05-01)
    # Don't want bin/mu-mh/ directory
    system "./configure", "--without-python",
                          "--disable-mh",
                          "--prefix=#{prefix}"
    system "make", "PYTHON_LIBS=-undefined dynamic_lookup", "install"
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
