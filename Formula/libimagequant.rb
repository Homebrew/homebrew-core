class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/4.0.0.tar.gz"
  sha256 "d041f6f2dac36df76f22cedaf74c914f46bff1fea7d6025d1b13199204c25dd8"
  license :cannot_represent

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "caa881537cf2bd798e1368a349948065075f1102cfbc87af5df4b9d984b9e696"
    sha256 cellar: :any,                 arm64_big_sur:  "87b63af3a12b7fb46d671bed7f0c267e6ae5e95556f55b5143659e7912dafecd"
    sha256 cellar: :any,                 monterey:       "062aab1fb59e411bcba82de8c7b31e5ab6fc4ac84df71068c32f5186d2fd38e4"
    sha256 cellar: :any,                 big_sur:        "f2ada26ef5fc15ef398d0dbf221266810d0c6680addd78b63848a77488254737"
    sha256 cellar: :any,                 catalina:       "1037c190d72000260168ae3722abccb6c6af16b29a3b2eec5f2cc6c01e5bf1d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ff211337ab117502081dfb8cb1533a28a192b9edcc86ad94673cb1a592d2c58"
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
