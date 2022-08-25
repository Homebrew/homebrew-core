class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/4.0.4.tar.gz"
  sha256 "d121bbfb380a54aca8ea9d973c2e63afcbc1db67db46ea6bc63eeba44d7937c8"
  license :cannot_represent

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "74b7fd22a5ff6788d52758658836e7e93756a8c6fa8fbe7e34240cdfdf94ae6d"
    sha256 cellar: :any,                 arm64_big_sur:  "dd2253e25c4fba04129d2f53a50ed94864c9967cdbd5299b12a42c28308135c9"
    sha256 cellar: :any,                 monterey:       "090bc081fe040553880f0f8d2eab3ef0890d4526a7f16b9726dd27cd802d32dd"
    sha256 cellar: :any,                 big_sur:        "6f20f0085b640a8fdc8c47ddc547045af6c9280084861d3f6cbceb94cc757944"
    sha256 cellar: :any,                 catalina:       "0511ae447a072b7e9e3052d47d93158417e1d478c6ab91aa8b1e72345eca65a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d8228771a3befffd9b999c2d444411a0672813fe2a9a44303af1ad8b235e4f5"
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
