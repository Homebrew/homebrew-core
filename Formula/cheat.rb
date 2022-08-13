class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/refs/tags/4.3.1.tar.gz"
  sha256 "10011b4dd8e66976decd7f3252e3221cb2c5a290740648ac3a70f3b20bac3109"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "121d27d1a87358cd60bcf160cf82c88b8215e2c46f565042f15b5325a41c5819"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ae30160905fd00b53011c7fcbcf37c1bf830de37373886ae8ac5e80042a273b"
    sha256 cellar: :any_skip_relocation, monterey:       "ac1d16ed17d4761165afd30a9ace29ce712c3a67fb1110b2357841b736f0387d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b14a3ab0ab902355a82655d5d5fae66d03daeff57952d01beaa4446516f402f"
    sha256 cellar: :any_skip_relocation, catalina:       "f0766a528955e0217bf4c220bfc65ed2cb92abee178209ab772c2090c6de0f43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d1f0eee745da72d3261c6390228381458a812dee94ece209bb48b98afe53b51"
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
