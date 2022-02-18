class Pure < Formula
  desc "Pretty, minimal and fast ZSH prompt"
  homepage "https://github.com/sindresorhus/pure"
  url "https://github.com/sindresorhus/pure/archive/v1.20.1.tar.gz"
  sha256 "d530e5a1e82cefbe76056f5263daed48dc460028934dedeecb80ba39c9087925"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "86b966689984c3d9c6a7002c9f580a900f4c185923ebe0dbbc5d2bd364cc9057"
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
