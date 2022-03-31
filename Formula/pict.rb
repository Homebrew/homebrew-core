class Pict < Formula
  desc "Pairwise Independent Combinatorial Tool"
  homepage "https://github.com/Microsoft/pict/"
  url "https://github.com/Microsoft/pict/archive/v3.7.4.tar.gz"
  sha256 "42af3ac7948d5dfed66525c4b6a58464dfd8f78a370b1fc03a8d35be2179928f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "403ec2807ccae261d90907f5b94fd0bf830a4d177b806b8897bc5284f186b83e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c3370ed3f5f86086f6babbde9e3a4d5c57a436e3d2f7b6ceef5cad62f5e8610"
    sha256 cellar: :any_skip_relocation, monterey:       "6c20f971ae5a8ffaaadc73afbde0c76445abc8a05b58a36fd2b00d98ac28e088"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f08584a5024865fdb0b31eef4e3c21cdfcda79e8fbb9730a1fe8432d1a51cde"
    sha256 cellar: :any_skip_relocation, catalina:       "680c75c7dcfc952e3553957b58b1f9e132dba1f398cb2b3ed1f91d7df1d2fe82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbc58f036d00ae3d485030e8dc8f1d23e756f8982de86404d12a32c264f11e86"
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
