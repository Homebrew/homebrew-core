class Pure < Formula
  desc "Pretty, minimal and fast ZSH prompt"
  homepage "https://github.com/sindresorhus/pure"
  url "https://github.com/sindresorhus/pure/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "33d5b7be97da268cdbd59075d5ce1cef1c3e108b03d2172b6a3b3c250884ca3a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a345a78700b0be3689b3990e739d41ced0498d19c547b7dabf22f7306ea618ee"
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
