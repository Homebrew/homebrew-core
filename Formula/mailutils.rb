class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "http://mailutils.org/"
  url "https://ftpmirror.gnu.org/mailutils/mailutils-3.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/mailutils/mailutils-3.0.tar.gz"
  sha256 "41e5a1e9b1da1efd184b4cb3ed8e88bb3013ff09f9774b15a65253ff31db2f9f"

  bottle do
    sha256 "3a2d771c6ff402a0345e263f1ca24775cd8a3c153f69ee00006ac1eb3ee14cbc" => :sierra
    sha256 "e43b4f89247eef6735f65cf474e31b2d4f6a21d95c8bdda843f2b8e91b08f345" => :el_capitan
    sha256 "43af4b9eab94c5af57aa35e4d44312834ca66b14d456030233f6820a96d53621" => :yosemite
  end

  depends_on "gnutls"
  depends_on "gsasl"
  depends_on "readline"

  patch :DATA

  def install
    system "./configure", "--disable-mh",
                          "--prefix=#{prefix}",
                          "--without-tokyocabinet"
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
