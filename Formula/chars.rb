class Chars < Formula
  desc "Command-line tool to display information about unicode characters"
  homepage "https://github.com/antifuchs/chars/"
  url "https://github.com/antifuchs/chars/archive/v0.6.0.tar.gz"
  sha256 "34537fd7b8b5fdc79a35284236443b07c54dded81d558c5bb774a2a354b498c7"
  license "MIT"
  head "https://github.com/antifuchs/chars.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65d4047f46ba1526f22d731c7b74de64ca33d59acda6791ff25f9680ad92d261"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c1f8f9c18e61de6516ffacd7a8d0012dc5a79440d91ba27e3c444c90346375e"
    sha256 cellar: :any_skip_relocation, monterey:       "d500b53477aa281423107e2671e7375da0b653b387a2f7397e6c5692c34dbb0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfddb7bd963efcdf967cbeb1ed7086816431d9f494f198e201dd6888d7844f34"
    sha256 cellar: :any_skip_relocation, catalina:       "b67bf752923b6943a07bc90cbd7b3a3a64e02968fe752579266561844e979763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d2f9a30b1ddfee10bac0c2b65d8c99be8755a2b6166b88111a244eafa27a768"
  end

  depends_on "rust" => :build

  def install
    cd "chars" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    output = shell_output "#{bin}/chars 1C"
    assert_match "Control character", output
    assert_match "FS", output
    assert_match "File Separator", output
  end
end
