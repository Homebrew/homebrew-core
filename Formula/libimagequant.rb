class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/4.0.0.tar.gz"
  sha256 "d041f6f2dac36df76f22cedaf74c914f46bff1fea7d6025d1b13199204c25dd8"
  license :cannot_represent

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d2fa31455ef1fd636223a851931cdf6c2d1f01b559807083d26c74c94c097faf"
    sha256 cellar: :any,                 arm64_big_sur:  "4b7b2654c56bcfcdd4863998525f2d7691e4fdd4086e62f649054ec1dc5f6adf"
    sha256 cellar: :any,                 monterey:       "554116391966d8958d23fb1a6e08f6483a3f730fcf7f014bbcee3dcc7bc3ba6b"
    sha256 cellar: :any,                 big_sur:        "3d30444330ad5674e608f3e997cc4131d77da8878de12455a569510b70e0ed0e"
    sha256 cellar: :any,                 catalina:       "fd51aa4386994ea1c70c04a7025c12dce732aebf57df4bf4e5870a0def326b9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "755d6d5ede65e921ff0ecc6f8efb56cf639ea884a8d4904d9b58a7035d46f2bc"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libimagequant.h>

      int main()
      {
        liq_attr *attr = liq_attr_create();
        if (!attr) {
          return 1;
        } else {
          liq_attr_destroy(attr);
          return 0;
        }
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-limagequant", "-o", "test"
    system "./test"
  end
end
