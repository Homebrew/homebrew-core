class Libexosip < Formula
  desc "Toolkit for eXosip2"
  homepage "https://savannah.nongnu.org/projects/exosip"
  url "https://download.savannah.gnu.org/releases/exosip/libexosip2-5.2.1.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/exosip/libexosip2-5.2.1.tar.gz"
  sha256 "87256b45a406f3c038e1e75e31372d526820366527c2af3bb89329bafd87ec42"
  license "GPL-2.0"

  livecheck do
    url "https://download.savannah.gnu.org/releases/exosip/"
    regex(/href=.*?libexosip2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "da7fc6e02d19aa2af2ac9b387a9eaad1269b372a3a60fe1b77c49f8163023b0b"
    sha256 cellar: :any, arm64_big_sur:  "60ef1b3f024a0ec02a8e1fc59418df4d0cb1ca86728145a2b9976d62f2b01a30"
    sha256 cellar: :any, monterey:       "4180860dec8a435431817b6da423f0cc8e8d577954dd24cbe4aeb1604f52fd9a"
    sha256 cellar: :any, big_sur:        "7e69d1381e87307b4dd882fbb54842378886a847d7ef8f5353e2ed409e2f3d76"
    sha256 cellar: :any, catalina:       "a0fe16f1dc217f051a8aab3ac24c78a41f618a66983ccf52c4838e23720ed60a"
    sha256 cellar: :any, mojave:         "5e211736f686f45183c103da6fa9181e832740019c983c57de2617133e11055a"
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
