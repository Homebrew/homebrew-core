class Pict < Formula
  desc "Pairwise Independent Combinatorial Tool"
  homepage "https://github.com/Microsoft/pict/"
  url "https://github.com/Microsoft/pict/archive/v3.7.4.tar.gz"
  sha256 "42af3ac7948d5dfed66525c4b6a58464dfd8f78a370b1fc03a8d35be2179928f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "850390dcfee5160977df23f8bb6cee15fd92f720efea4431c06e829962ac5f4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd5908f0467620ae185bc24e395b7132695b814242ec3a5195197baf8e9180e4"
    sha256 cellar: :any_skip_relocation, monterey:       "3beebff6cb6214a7b3a413e52557377dcd45f2880ac1528facd10a74b3c32da5"
    sha256 cellar: :any_skip_relocation, big_sur:        "6185ed2966b814e76cff386f76cd14c67e45b8005a197be1f0ea976792c27297"
    sha256 cellar: :any_skip_relocation, catalina:       "295161d07acd9e141235eecd7c7e715bf3615ee3e71289cc57f00fa6440c2dd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89c9e0a586a093c3fcbbce59dcb05d54a16c111e18ac02cbe4c9cfc7ca74ef6a"
  end

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  resource "testfile" do
    url "https://gist.githubusercontent.com/glsorre/9f67891c69c21cbf477c6cedff8ee910/raw/84ec65cf37e0a8df5428c6c607dbf397c2297e06/pict.txt"
    sha256 "ac5e3561f9c481d2dca9d88df75b58a80331b757a9d2632baaf3ec5c2e49ccec"
  end

  def install
    system "make"
    bin.install "pict"
  end

  test do
    resource("testfile").stage testpath
    output = shell_output("#{bin}/pict pict.txt")
    assert_equal output.split("\n")[0], "LANGUAGES\tCURRIENCIES"
    assert_match "en_US\tGBP", output
    assert_match "en_US\tUSD", output
    assert_match "en_UK\tGBP", output
    assert_match "en_UK\tUSD", output
  end
end
