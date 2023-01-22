class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/4.1.0.tar.gz"
  sha256 "7673521655cdf0ec16b99fd0c7c8b1bd542b6f3a8469fa2effe34b0f53e9fa92"
  license :cannot_represent

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "682406dfa8e418894787c527b5ad37d60b0d74bfac89763cbb2159c501f2a2d7"
    sha256 cellar: :any,                 arm64_monterey: "fe5742953f0e32d062df2b860f30d753817bc1a39dbe1177a76cd157da584c50"
    sha256 cellar: :any,                 arm64_big_sur:  "580cde229cd52fe7124c53d037d511d2a54ebf93e39bdad2adfc67ff542bb803"
    sha256 cellar: :any,                 ventura:        "dcbe6914e44e5d37b0ba4091f3992289b765ebc103dca79f4970a78b84b8ab50"
    sha256 cellar: :any,                 monterey:       "c551683485cd705efa8a78d5f5ea58efe01faecb86a1acb831030b908b0a20d1"
    sha256 cellar: :any,                 big_sur:        "a998b4fc5faca9104859f47097ff1f398b17132d85aaa255a14996b0b60eb7bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90b4f85aea48a09395294cd3e2ed69c37361669aabd081e5e2f45996799a736b"
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
