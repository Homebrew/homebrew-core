class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/4.0.1.tar.gz"
  sha256 "465ff764f437ffcfa7cad8d3a4098a781d3919f754483fdf406a642156af2540"
  license :cannot_represent

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "594798cdb29a2036085b33c75c36e3cc13191303aafe83c8c3f3e56e7a780d09"
    sha256 cellar: :any,                 arm64_big_sur:  "50f90065c0de38bc150d3e0fe290d0746cc2647521dd368374737873a71b25b1"
    sha256 cellar: :any,                 monterey:       "75cf253dafa96d11cfbe00113f6b73e7d6afa0b64c8a400b83d3f4ac4007c415"
    sha256 cellar: :any,                 big_sur:        "ead19d3976ac3002fef0aa1cdb7cdb8b96cd33f3b4c08563d41e85f38e2c3d53"
    sha256 cellar: :any,                 catalina:       "69b584251276c81a9b9c414622a47151f0a80872f24553395a4672e54b570b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc752b31cae1a96242bd229091bbdde723c64f988520da08dd0c03364d185495"
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
