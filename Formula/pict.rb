class Pict < Formula
  desc "Pairwise Independent Combinatorial Tool"
  homepage "https://github.com/Microsoft/pict/"
  url "https://github.com/Microsoft/pict/archive/v3.7.3.tar.gz"
  sha256 "43279d0ea93c2c4576c049a67f13a845aa75ad1d70f1ce65535a89ba09daba33"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6bb6e6db107a569972037aad09cc8c0c579b6ed53c812eb30c79d380673ca87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "649b038bfe848fc40420a8bcb8c873dbaf61a5671fec09d6afd78e298b941321"
    sha256 cellar: :any_skip_relocation, monterey:       "60e82b5a1d49f22b5bcfffe29b87ce3d6dbe92ca0582a833e81137b736e41a9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "92e7326170e175b898a30a79f4524afda931e0be0b29e68638f1120ea1855df3"
    sha256 cellar: :any_skip_relocation, catalina:       "f7f1b4d4385fed18927decfa5fc38c8b890edbe8abf7c851876cf174b3339a78"
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
