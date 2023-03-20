class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/4.1.1.tar.gz"
  sha256 "726ce0bf2a8175a32d1ef303c3e8971a1fda354e760f1327c08656268bb019c2"
  license :cannot_represent

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5610b4ce2377ecd8e862a99e43ce2cf1eceb922a68b721afde78db1203ff882e"
    sha256 cellar: :any,                 arm64_monterey: "3d09eec399f6183b49178427485ca67e3b795a41727ecbfe05688e562fdf4f14"
    sha256 cellar: :any,                 arm64_big_sur:  "ba14565fecd9ab35a2310c4c24ebe00c74b28085d0a1168718a200bf74fcffb8"
    sha256 cellar: :any,                 ventura:        "14f44ba4a38c0d0381ba01c9fc6f5ab9cd1dcb2a5a17983a1523f888320dd96c"
    sha256 cellar: :any,                 monterey:       "53c9a54161b691f6f0a05fe519a30e06398613353e6d7d87dcb718e018e955a0"
    sha256 cellar: :any,                 big_sur:        "2fec66d8b40a87021aea0070f4926d28a15df8d8f3a169856b4223c7758f66c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7acf6495f5640ed73bf684e695b04780878081f2f4e79ca2ab4dc94d589c929"
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
