class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/4.2.2.tar.gz"
  sha256 "ff1a34d3df9a1a5e5c1fa3895c036a885dc7b9740d7fccdf57e9ed678b8fb3a3"
  license :cannot_represent

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c0ee90285655a982054775f95de1be40059df026f88ea70cef6597882ac6ebba"
    sha256 cellar: :any,                 arm64_ventura:  "001b492eba8ba2bb965494068e48cb595da48e901edde37688f58c16d3bdb84c"
    sha256 cellar: :any,                 arm64_monterey: "0940d396700a4a892eca1eb29b598157f06002a685f8c322be32371be851771d"
    sha256 cellar: :any,                 sonoma:         "59077e5967d31c926f018e7907a69786b842f2b165273bccebafdd57337ccb25"
    sha256 cellar: :any,                 ventura:        "3bc88cb56e88ca71332772c1bc22287f625e602e2185ddf68e43bed9536dcdd3"
    sha256 cellar: :any,                 monterey:       "152c5207e818d03ffaa1912995aab8d77006356f15ebdb9c29a9f2cdaf27143e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6c0713d1d14290b0ea3497bf64d060a9c57ddd99877ce2b90c31853452d2535"
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
