class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/4.2.1.tar.gz"
  sha256 "14193219fa194d6baee4347bd13bd01fd46d09fe3b59ae35c89b698da96d1198"
  license :cannot_represent

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "979c3f58420ac00166c896e5a1e4f2b21fb91620d9d920ad800fbfc6aa2f9e08"
    sha256 cellar: :any,                 arm64_monterey: "0d0586aea0b6be29b1b5da618450e1903596decddca99f0f18d701addcfc1c79"
    sha256 cellar: :any,                 arm64_big_sur:  "784ef5cc34f90ff21b1b1b16ca13d90766175aef073b72f49f8e416e7d4a24df"
    sha256 cellar: :any,                 ventura:        "baa5e9b111d0982df5af083d8a3f13504520f48aeb5a367bd9d1b5b42e51859f"
    sha256 cellar: :any,                 monterey:       "43edd7ca2e6e5608ca020d728fe5186fdd36105eb47af4ba6c7ec03fd37a0f9f"
    sha256 cellar: :any,                 big_sur:        "964a5b958ad54ba42820f2c148b588508f21dec35839ee5199d3eb091c900bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "829b2fee40c2d16d94e67e8cc61e32fcde28033e597ee269640380b38865974f"
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
