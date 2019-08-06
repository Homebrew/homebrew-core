class Libexosip < Formula
  desc "Toolkit for eXosip2"
  homepage "https://savannah.nongnu.org/projects/exosip"
  url "https://download.savannah.gnu.org/releases/exosip/libexosip2-5.1.0.tar.gz"
  sha256 "41107e5bd6dca50899b7381f7f68bfd9ae8df584c534c8a4c9ca668b66a88a4b"

  bottle do
    cellar :any
    sha256 "7b36d0061e7a0681c8187d62b2f6088c0dfd2b2d5d8bc4b56261d129eeca6567" => :mojave
    sha256 "fef377c553a324d70764bb94b4c94a789d6cf584ab69c592baa6c44abc082689" => :high_sierra
    sha256 "bc49bf581921515eff4719d5e0f31c2bffb43137d06affdc6e73a947d80692e0" => :sierra
    sha256 "4ba8b361d2fd38f861c66b470d05bbb21e80ac92236cb8ad9323f1dca6121e2d" => :el_capitan
    sha256 "9fd63688f31b0561749756daa3f426abc58754dc5033f6068dc0d389bde043f3" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "c-ares"
  depends_on "libosip"
  depends_on "openssl"

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
