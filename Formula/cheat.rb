class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/refs/tags/4.2.7.tar.gz"
  sha256 "124ddb6aeefdd954bbb8ab71c6da35a7c75cfabda55c437b0f00a10bfde50084"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c29c3e39ef523938003f2e427e3a9b07ed5c8455f4aba9cb79869a4d63919359"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11ef7a5dde9a3a800d0c46f3dfaa30dbc158b15a616317d00fc287dfd8862556"
    sha256 cellar: :any_skip_relocation, monterey:       "f73e628affca9c2164a5acda3ba1324a8cd9c9757d4815f484fa97e96c8da080"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0612882201dcaea1323413de71acca73ca0bcd198d3ce96a9d70e44c1549a2d"
    sha256 cellar: :any_skip_relocation, catalina:       "00e52c01f74d7efda14dd31154da0f4c50688a436069e87ba7cea766cac5d20b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6242063671ee40f8b56a363b84194b083f34efcdeaa9293fc33a7a6a2e11ded6"
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
