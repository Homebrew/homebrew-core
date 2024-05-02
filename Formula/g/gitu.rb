class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "4b554857ab37fea28e29c929c13cccef86c24401cbcd34b201c5891021d9eb67"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1850d545f6ad20d98ed47d5717a2a59d909b3e35ae31a875b7b50d5139bab8ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07fbb5cdcb6f1da9c9fc6d0f63c2d6b0a322f864efddc61e7b2b0d79da93dc77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b66853ec610ea5d6941728088a9934e7fb2b604331eae21497d79115f598f611"
    sha256 cellar: :any_skip_relocation, sonoma:         "c04b5463c1167ef6e8b9fc2c074965f5a2d0c408206eeeaa75a1adf69fe0d450"
    sha256 cellar: :any_skip_relocation, ventura:        "f3c259b03e45715d1b097a1f588ff13d7816836a67d5e695078751fdee389288"
    sha256 cellar: :any_skip_relocation, monterey:       "fb46bb6b6f80d26a9ee2601ba5762b093fd4f008dbef17f0c2f9e067020616dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d35d48efee76c5302f44e95418ce36eb04b27c58259274720d96a5a1c757958"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    output = shell_output(bin/"gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "could not find repository at '.'", output
    end
  end
end
