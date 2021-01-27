class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/2.14.0.tar.gz"
  sha256 "ad3d3cbc7b2c065d96391ee532b9ee4b7d406fed6be84446a5283ce1bad519eb"
  license :cannot_represent

  bottle do
    cellar :any
    sha256 "4eec259853e8c650282ab0f9fe2fe382cfb0c63adf50eefb0e53038e9579b117" => :big_sur
    sha256 "3f24de6501d3c1ceea4d4c79d2895332fec3796d09cda4ff5abc456479ca1504" => :arm64_big_sur
    sha256 "ddaab4f5d02ee638676c716701a3e4364c76a3e6184787b2b5bc078b95497fb2" => :catalina
    sha256 "f7902838c7698902828571a5bbb170a1855ee66d96070e7b577b9a332370989b" => :mojave
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
