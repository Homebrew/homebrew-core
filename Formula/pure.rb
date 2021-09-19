class Pure < Formula
  desc "Pretty, minimal and fast ZSH prompt"
  homepage "https://github.com/sindresorhus/pure"
  url "https://github.com/sindresorhus/pure/archive/v1.17.3.tar.gz"
  sha256 "2c8c1b4a8d255603a4a5d9417b75c8d439021c5b345b844f0bdc4bb20e4b6e26"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0f5d0c2df3e13671a1ad4797c8585c47331827bafb0aaef37a330fd657ff06b0"
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
