class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/4.0.4.tar.gz"
  sha256 "d121bbfb380a54aca8ea9d973c2e63afcbc1db67db46ea6bc63eeba44d7937c8"
  license :cannot_represent

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5c39366e84e66ab75bedea1c60fec6097f1e59c3193b3c3975125ce4181b21bb"
    sha256 cellar: :any,                 arm64_monterey: "2cc9dc452441dcbda9a7148aa4a499df01da6ebd9ab8503fc6b904098a51ceb2"
    sha256 cellar: :any,                 arm64_big_sur:  "52af38599a5b23e03e15a62585f371a68d719f74989f806aa2cec2be859ee9f8"
    sha256 cellar: :any,                 ventura:        "37646fffeffe095863ad4c20225cba5a027f8b9b1e5e289bb611c08ac4c8d845"
    sha256 cellar: :any,                 monterey:       "c1e3bd9e9a63213b48edbbff00d1a79aa195e868a8b6e531a48b887540804fde"
    sha256 cellar: :any,                 big_sur:        "2b4ad2c624c2cdcccf6763fe598652e0a424e8a123f6ffac05366cc99d1ae731"
    sha256 cellar: :any,                 catalina:       "20fbb37b6901a9ee68a6f528264418562e48bb9d116230d864daf854b5f7d112"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f847c27c7e3799c35fa83376dff52bfa5033f0adc7e2304940b20b585ba75539"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  def install
    cd "imagequant-sys" do
      system "cargo", "cinstall", "--prefix", prefix
    end
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
