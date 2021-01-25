class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/4.2.0.tar.gz"
  sha256 "23c3c30fe1ad63916718eef534dcef22c0ae607695f74860180304c5cde3ea49"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "dbfd6636a4b40dd7b94a400c7888f45ddd87427e855b00dc8119dd7200c49b14" => :big_sur
    sha256 "0616a7b0ce9a9fd33919390fb29f042eb997d3462917514b283385a9f05fe977" => :arm64_big_sur
    sha256 "74c8c4a8fc13f0484628ed56dc6d54507f605d271faf844683119f6f46adfa2a" => :catalina
    sha256 "540de221f3d25e9aaa697a078c51f36964d219a565701e06ed5492a02b6d876d" => :mojave
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
