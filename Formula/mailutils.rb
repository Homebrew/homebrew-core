class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "http://mailutils.org/"
  url "https://ftpmirror.gnu.org/mailutils/mailutils-3.1.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/mailutils/mailutils-3.1.1.tar.gz"
  sha256 "d237622ee1957e8e14cd15713bd8bad710bdb0e408be3de2db12db0b8437049b"
  revision 1

  bottle do
    sha256 "e4e43a33b9b8545dff2671e905faf87217b37778c4ea68339f4d11ec0e83bb42" => :sierra
    sha256 "bcc1b3e8f75314ce9677f3c0cea8154f4d5399e6bef4715debedc1926b582133" => :el_capitan
    sha256 "33b2cddbed872d86df88c150253c5141b5b2a1357b2cca8dc34d31c5cfe2b849" => :yosemite
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
