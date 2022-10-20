class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/refs/tags/4.3.3.tar.gz"
  sha256 "6a1739b71d436f45dc7c028ec79863a34e30cc13da7159bf23604b77f43faaf2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98c84f7314ecfb5ae455be12af26b4483864e5068b3fcc45d0f2cf3d81f449b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ef382c3fed925701edfddd8077411534ba8dac27882f1e9fadfecaaa0af57ab"
    sha256 cellar: :any_skip_relocation, monterey:       "9504bdece78cf2dba163b48913f50768599e0b20feede2aed8d89600a6fc80a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ec70300e5d6ab42f15790f210ef06a7ce5a178987fc06a5dbe8bf944ffa41c2"
    sha256 cellar: :any_skip_relocation, catalina:       "ef88f03232c81382740fcc6516e83622c12f94f054167969f463b5676b85a967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcfbbb8a7df772c836af738f0fc8afeb56ea3c2653eaefd8767db02cf95e4a77"
  end

  depends_on "go" => :build

  conflicts_with "bash-snippets", because: "both install a `cheat` executable"

  def install
    system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"

    bash_completion.install "scripts/cheat.bash"
    fish_completion.install "scripts/cheat.fish"
    zsh_completion.install "scripts/cheat.zsh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: EDITOR_PATH", output
  end
end
