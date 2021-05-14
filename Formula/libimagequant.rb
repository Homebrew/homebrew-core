class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/2.15.1.tar.gz"
  sha256 "3a9548f99be8c3b20a5d9407d0ca95bae8b0fb424a2735a87cb6cf3fdd028225"
  license :cannot_represent

  bottle do
    sha256 cellar: :any, arm64_big_sur: "bdfb6b39244941193b91ec2a2972f95cbb059a6628aaf4ae361df20293c12937"
    sha256 cellar: :any, big_sur:       "045a6d3c44c2e495ee6191d4df3033f88efbc776b845cc748c78dfc2d1fa1480"
    sha256 cellar: :any, catalina:      "45328d9da00b95a9ccae2b1e78888107b0da8b6ecb9bf84b8a49adc710e1d74f"
    sha256 cellar: :any, mojave:        "ba57ff195e53e7660f34ff9c4d54b13443f5d8548015e159857643fe0d038cd7"
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
