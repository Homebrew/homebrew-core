class Pure < Formula
  desc "Pretty, minimal and fast ZSH prompt"
  homepage "https://github.com/sindresorhus/pure"
  url "https://github.com/sindresorhus/pure/archive/refs/tags/v1.28.3.tar.gz"
  sha256 "738b523c59823083de490b3eb6c1116fc45c342e6b32a7d3cf05fdd0f8aa75a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ec101dc81a2e4d597a592c434efa427835739771f39c1b83f67e66b9b39993bf"
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
