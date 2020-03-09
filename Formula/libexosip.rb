class Libexosip < Formula
  desc "Toolkit for eXosip2"
  homepage "https://savannah.nongnu.org/projects/exosip"
  url "https://download.savannah.gnu.org/releases/exosip/libexosip2-5.1.1.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/exosip/libexosip2-5.1.1.tar.gz"
  sha256 "21420c00bf8e0895ff36161766beec12b7e6f1d371030c389dba845e271272e2"

  bottle do
    cellar :any
    sha256 "837af149701fd01d1b8c99b19ddcb8a08407e048225dc7d0af7e35d8d2113698" => :catalina
    sha256 "87f85e6d4adb2ad196e0b4d2bff84f3cc9cbe9a92d4afb2a2101638577a3923e" => :mojave
    sha256 "66c6dcf6e90bc4c08c5d6f119dfa997b1dfc750ac641a1b6139b74eebb897449" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "c-ares"
  depends_on "libosip"
  depends_on "openssl@1.1"

  def install
    # Extra linker flags are needed to build this on macOS. See:
    # https://growingshoot.blogspot.com/2013/02/manually-install-osip-and-exosip-as.html
    # Upstream bug ticket: https://savannah.nongnu.org/bugs/index.php?45079
    ENV.append "LDFLAGS", "-framework CoreFoundation -framework CoreServices "\
                          "-framework Security"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <netinet/in.h>
      #include <eXosip2/eXosip.h>

      int main() {
          struct eXosip_t *ctx;
          int i;
          int port = 35060;

          ctx = eXosip_malloc();
          if (ctx == NULL)
              return -1;

          i = eXosip_init(ctx);
          if (i != 0)
              return -1;

          i = eXosip_listen_addr(ctx, IPPROTO_UDP, NULL, port, AF_INET, 0);
          if (i != 0) {
              eXosip_quit(ctx);
              fprintf(stderr, "could not initialize transport layer\\n");
              return -1;
          }

          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-leXosip2", "-o", "test"
    system "./test"
  end
end
