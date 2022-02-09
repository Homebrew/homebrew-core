class Pict < Formula
  desc "Pairwise Independent Combinatorial Tool"
  homepage "https://github.com/Microsoft/pict/"
  url "https://github.com/Microsoft/pict/archive/v3.7.2.tar.gz"
  sha256 "9cb3ae12996046cc67b4fbed0706cf28795549c16b7c59a2fb697560810f5c48"
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
    output = shell_output("#{bin}/pict pict.txt").split("\n")
    assert_equal output[0], "LANGUAGES\tCURRIENCIES"
    assert_equal output[4], "en_US\tGBP"
  end
end
