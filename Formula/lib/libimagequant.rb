class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/refs/tags/4.3.1.tar.gz"
  sha256 "75020204491f14a8cdf4b857f6c5bab08b6b5f1736345412b296a253bc632bf6"
  license :cannot_represent

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e23067942a8b4aba83f14cadc2266d38ecec6e87db5afc5c6cfcc0671385fe86"
    sha256 cellar: :any,                 arm64_ventura:  "339baf076ca69378c7e6b7fdf5dd73902f98291685b1a585437706f9993b9842"
    sha256 cellar: :any,                 arm64_monterey: "3cfa156f5e5748ccdce2a44179fae4f90f0360024a5c913c28f69240f37a9aad"
    sha256 cellar: :any,                 sonoma:         "3ef069b0b98dff21c925a1def7aaed932e51b1ba5e6ddf17dcc87435a66e4285"
    sha256 cellar: :any,                 ventura:        "2e13ace7112a6bab367d817339d0df55f87e206a1012707412f0e32321393464"
    sha256 cellar: :any,                 monterey:       "8f0a65aca0cbc760d065171a17fcffa53d2bddc43fcc323913254b1a8785cc8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d814c871cdd4ef25149e85a048c1d125eef93cb782d0f41deb0a8c6a576d90c"
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
