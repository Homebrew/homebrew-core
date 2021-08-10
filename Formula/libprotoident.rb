class Libprotoident < Formula
  desc "Performs application layer protocol identification for flows"
  homepage "https://research.wand.net.nz/software/libprotoident.php"
  url "https://research.wand.net.nz/software/libprotoident/libprotoident-2.0.13.tar.gz"
  sha256 "8ca7ccd95b3f23457c3f9eff480364565b553bbcab9b39969f964910738e5672"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?libprotoident[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d0686f33c93e2853ca605f256486c9d8569b56b1538d0881b32fa4f0d7a49dfa"
    sha256 cellar: :any, big_sur:       "1928a4cc164177352292b8872fa6ed498247af16b1c25ffbf6cc80983e6ac43a"
    sha256 cellar: :any, catalina:      "7ea19cf1a0ae1423dcadebe59d08cd2c65433e4210a9e434e9d1e8dfce65abb0"
    sha256 cellar: :any, mojave:        "06f18aa299bc9b53991ac448d20d318625a3f1d55fe6bb093c45045b4accbb5c"
  end

  depends_on "libflowmanager"
  depends_on "libtrace"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libprotoident.h>

      int main() {
        lpi_init_library();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lprotoident", "-o", "test"
    system "./test"
  end
end
