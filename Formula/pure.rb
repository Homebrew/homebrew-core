class Pure < Formula
  desc "Pretty, minimal and fast ZSH prompt"
  homepage "https://github.com/sindresorhus/pure"
  url "https://github.com/sindresorhus/pure/archive/v1.18.0.tar.gz"
  sha256 "5d97a6760c2268196dd40af36e1e8f99b97604228af16169046344cbde8f12e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "887f710732be57d7e483bf26fa821fe70a0f89c489f5e3e6eed2515fc3f8c0f8"
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
