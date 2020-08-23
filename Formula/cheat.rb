class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/4.0.4.tar.gz"
  sha256 "4acdb68dc4ae4f0e9fd901cbcf737f571d90e3405fbf1c3a2f1a0dcab414de70"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "26c8e2917921161affa9afa13dfe76eca83f5809178d4691f9d6656ebc4c2ff7" => :catalina
    sha256 "3fa389bad7a84b71a6786bf8d9d3aa3f1d1345a1a013886daeebbf87b1e5ff8d" => :mojave
    sha256 "5508a8f8ea1e2d6664585e753694604795664a0dffd5c0a496214e0e84c78663" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "bash-snippets", because: "both install a `cheat` executable"

  def install
    system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"

    bash_completion.install "scripts/cheat.bash"
    fish_completion.install "scripts/cheat.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: vim", output
  end
end
