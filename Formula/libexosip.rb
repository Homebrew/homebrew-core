class Libexosip < Formula
  desc "Toolkit for eXosip2"
  homepage "https://savannah.nongnu.org/projects/exosip"
  url "https://download.savannah.gnu.org/releases/exosip/libexosip2-5.2.0.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/exosip/libexosip2-5.2.0.tar.gz"
  sha256 "e3ae88df8573c9e08dbc24fe6195a118845e845109a8e291c91ecd6a2a3b7225"
  license "GPL-2.0"
  revision 1

  livecheck do
    url "https://download.savannah.gnu.org/releases/exosip/"
    regex(/href=.*?libexosip2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "4b78b4c818018765e0fce6f1efb03cba359e6b110a192e301800abc596f199d4" => :big_sur
    sha256 "2d7a2d6081ef96cf011734d020173e54614f464b54978efbbb3d3539628563ea" => :arm64_big_sur
    sha256 "a2f29649ea868b8527b3fe161a6135154952cf8fdef0f48facab4916ae60d0b1" => :catalina
    sha256 "de249e456a3a8e4b5e15dc31028c833913255e75f544aa036434185d4e765444" => :mojave
    sha256 "c5b5afc052fbf378ef0f350eea8b45e507e1307e3969e9960985946301bb2d9b" => :high_sierra
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
