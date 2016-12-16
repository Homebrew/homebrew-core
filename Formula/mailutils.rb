class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "http://mailutils.org/"
  url "https://ftpmirror.gnu.org/mailutils/mailutils-3.1.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/mailutils/mailutils-3.1.1.tar.gz"
  sha256 "d237622ee1957e8e14cd15713bd8bad710bdb0e408be3de2db12db0b8437049b"

  bottle do
    sha256 "adf07f6916605862fede132b74c350f6bb541dc241c9a12f27e5bfdb5b2961af" => :sierra
    sha256 "accf75ed7e9a09c4c99ff618004eb58347dcb14bd25a9a82c4c41f54e9361090" => :el_capitan
    sha256 "c1c8d7fa2344db3c0d6522b282e7c989720cf496e82b2e7f0a87eb40e67c1e8d" => :yosemite
  end

  depends_on "libtool" => :build
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
