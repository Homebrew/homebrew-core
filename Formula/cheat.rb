class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/4.1.1.tar.gz"
  sha256 "76e1d3f720864721f5a74a41825fcac709a2eb9b01d8fdd23d27d3b59ca143a9"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "3672ea47c80e0bde75aaa322e19c56e8fca97ec02e5de38fd307891dba7d9856" => :big_sur
    sha256 "c8157571d901d5b1a92214a29e70202829f1a336523782a1f63fc8ccce520a96" => :catalina
    sha256 "aa58b40807dbee5f5127a66f5fa0b244da42344d88ceb67dd0ee8d03e1915618" => :mojave
    sha256 "d0f7dbb233a37fffa2c76fd3bded84af3f6a95d5a56bc1bd0e36551dbbe8c9b8" => :high_sierra
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
    assert_match "editor: vim", output
  end
end
