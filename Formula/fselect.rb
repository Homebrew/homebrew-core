class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.7.6.tar.gz"
  sha256 "bea8a7c09ddb88a8ad253305744847c4e4d63cb16afbec6c8cfff89b264f67d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e39a3c58cd521adfa7905a91868a2a7322491fab83461ff5b1c398c6568f01d5"
    sha256 cellar: :any_skip_relocation, big_sur:       "6a8fa1a4c0836f2b5d2231539041dfbe833b6b0dd570277a9add7e2403d9617e"
    sha256 cellar: :any_skip_relocation, catalina:      "4823c2b864930f0ad1272aebded125fb07d5c0689740b8fb886e1d3966a6d505"
    sha256 cellar: :any_skip_relocation, mojave:        "55448eaecbf7bedf267dfa349c01cee1d00872e2e3b5fc7885678f8f7459a853"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
