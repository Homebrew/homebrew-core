class Pure < Formula
  desc "Pretty, minimal and fast ZSH prompt"
  homepage "https://github.com/sindresorhus/pure"
  url "https://github.com/sindresorhus/pure/archive/v1.20.0.tar.gz"
  sha256 "1fa82dc9c6894dab65d845f38a2c24c790b0095d175da22902a0eee9ea0dd38a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "212aeb486a9f06ac07692e9cfd9a914354a443eef2b67fda44ce6594c78c15e2"
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
