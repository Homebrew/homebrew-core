class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.8.0.tar.gz"
  sha256 "33dfcbbf7e598bce479b1fb5c17429af1bb309beab2e4bc95642e9f4b5c2ffbd"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5746c370f51ec30e7410c5410960a4cd36c020a6be63c10b1462ef19895ff77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebeca422441455b96c69a4657cd4a5f099af1f61d27076c1db96ebaba040e262"
    sha256 cellar: :any_skip_relocation, monterey:       "6053117baa56dbd99126e6641b43243a7ccf6e68b1a6b51dc0078f305cebed04"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c39e91f7002508e0151c77e55d78375959d5e3abd27532fa52a6fcb2ef8147e"
    sha256 cellar: :any_skip_relocation, catalina:       "d00d20d4448cb31fcc0b257fa77b0f7b384e9f7032ce315b7d44117365cd2608"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a05b53341f7a136faf1670f2d2fd2628dc388c3236c27361efceeeae2b1cf86"
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
