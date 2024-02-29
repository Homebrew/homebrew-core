class Pure < Formula
  desc "Pretty, minimal and fast ZSH prompt"
  homepage "https://github.com/sindresorhus/pure"
  url "https://github.com/sindresorhus/pure/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "b316fe5aa25be2c2ef895dcad150248a43e12c4ac1476500e1539e2d67877921"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2843ab2c5991c4e8c3c1583d7567ae6412e9948d098011f51573976ea747069c"
  end

  depends_on "zsh" => :test
  depends_on "zsh-async"

  def install
    zsh_function.install "pure.zsh" => "prompt_pure_setup"
  end

  test do
    zsh_command = "setopt prompt_subst; autoload -U promptinit; promptinit && prompt -p pure"
    assert_match "❯", shell_output("zsh -c '#{zsh_command}'")
  end
end
