class Pict < Formula
  desc "Pairwise Independent Combinatorial Tool"
  homepage "https://github.com/Microsoft/pict/"
  url "https://github.com/Microsoft/pict/archive/v3.7.4.tar.gz"
  sha256 "42af3ac7948d5dfed66525c4b6a58464dfd8f78a370b1fc03a8d35be2179928f"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa4517aea0e42f613cd176baa46a11f3e46d216fb1050c9059d93bca14df049c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3b42cd438f51790b14275f2ff2d7d6dc897f8ce32489c997602d8dd5f8984f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "863064a24888d6aef5013b37eeb22abd0fdce747badfe27c189959b01d9c7a16"
    sha256 cellar: :any_skip_relocation, ventura:        "7dc3684b30b611acb139b8f5b908eba640a76d49cc424db06a6f814515eafddd"
    sha256 cellar: :any_skip_relocation, monterey:       "2acd315ec72d1d92cca685e2e6953539d2d9d37d18ea0889ad5e67c06f83b4ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "96d58480ac15db41e7bd9831c9287afaefd1bce20d275e1a2642c070cd3fdb8b"
    sha256 cellar: :any_skip_relocation, catalina:       "1320678e6b2a2f174d88162541e72fff108adb4b4ff4c34eedbc435b4022fa74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bc79051760ece4228b1b8effde4c16289f250aa9f6feb14f05e6065e3aba070"
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
