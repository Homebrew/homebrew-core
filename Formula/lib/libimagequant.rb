class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/refs/tags/4.3.0.tar.gz"
  sha256 "7f590ed400def273381ac066f46b9f9e8b3e0b1985a5b7e82ca7a65541a6681b"
  license :cannot_represent

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "39a3af49326b7a8edfcbd2a0bc4394f82c2ac544ab56b34f10f20e0b58be0b99"
    sha256 cellar: :any,                 arm64_ventura:  "343b1df95cf3f09e13cba025be250e2dc188397f42436dfba0b768f66517dc17"
    sha256 cellar: :any,                 arm64_monterey: "b7bff6724391e9b9510b084fcd312d0fa5229525315bc5ba6dc67b37ee709a90"
    sha256 cellar: :any,                 sonoma:         "1aab3673286a279d4ae820ba20df817794b82a8412ab1dd8a10adde7e0edaa81"
    sha256 cellar: :any,                 ventura:        "76b9b67a8626d999ccfee91cb5e506ee540b193b20d19257401955a6db20016f"
    sha256 cellar: :any,                 monterey:       "133beb288e5c4d6b0d2b1b530753d63d8674593de8526194b0404d19bca5f3f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5133f87312d636594022e09247cff1a7ecfc6d1058fb73a1cc8f153f5f16c34a"
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
