class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/4.2.2.tar.gz"
  sha256 "b4fb5a0d63bad020ca240a8e27b573ef127a1ca0f27e87a2cb8bd817c258611a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f1fec31503d04d18d06ff7219b56692834ee87b768b746b6388175e3f1850cb8"
    sha256 cellar: :any_skip_relocation, big_sur:       "8d9532d83667e17958f1171b526fd5bfbd07d6c506ab56ba252edb8cf0c7bad1"
    sha256 cellar: :any_skip_relocation, catalina:      "3f487df7029b53f7bea851dada9a6020d9f1b2db047edd35dbebee16eaa60f67"
    sha256 cellar: :any_skip_relocation, mojave:        "15e9b5b9a0bae299e8d1836372158561babd7bfe170c5365ab92667d0bcc1bb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "049ce98d4e20b50c6e4b0c85e6eb786926247459b2f7c72ddf7698e64117afd8"
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
