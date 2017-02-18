class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "http://mailutils.org/"
  url "https://ftpmirror.gnu.org/mailutils/mailutils-3.1.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/mailutils/mailutils-3.1.1.tar.gz"
  sha256 "d237622ee1957e8e14cd15713bd8bad710bdb0e408be3de2db12db0b8437049b"
  revision 1

  bottle do
    sha256 "5fffeefa72bf0af1f6b7d216e363a6723e7651eb0d409450c94f7baed9f882b0" => :sierra
    sha256 "a57eb344e881e4c9938ea47b117bb2e59f6d1434e523c6e5e3a52262173c9836" => :el_capitan
    sha256 "d789e0d108ced0095019cbaeb1d8b2ab1e2e667387f8b946a5f2d425e084be33" => :yosemite
  end

  depends_on "libtool" => :run
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
