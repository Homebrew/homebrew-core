class Libexosip < Formula
  desc "Toolkit for eXosip2"
  homepage "https://savannah.nongnu.org/projects/exosip"
  url "https://download.savannah.gnu.org/releases/exosip/libexosip2-5.1.0.tar.gz"
  sha256 "41107e5bd6dca50899b7381f7f68bfd9ae8df584c534c8a4c9ca668b66a88a4b"
  revision 1

  bottle do
    cellar :any
    sha256 "8a1cf2e13613b6e2f92823dd783046c608d3f57b8bef64badf9ce54e7edbf7de" => :catalina
    sha256 "c2fc3e1f96abb5f383a1b2948757010319d63ec41544854003e48f995b3eb4b7" => :mojave
    sha256 "645d0b89351aa41b957dfcbf4f82d6df7912dba8f4364ebe5b129c9e385039eb" => :high_sierra
    sha256 "602438fc2690914f98d185deaa5472102cf4154278ddaea9454d612e59186a20" => :sierra
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
