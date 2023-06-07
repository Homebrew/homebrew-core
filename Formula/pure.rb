class Pure < Formula
  desc "Pretty, minimal and fast ZSH prompt"
  homepage "https://github.com/sindresorhus/pure"
  url "https://github.com/sindresorhus/pure/archive/v1.21.0.tar.gz"
  sha256 "0c3f55dc75c0e1a47e1670ada35c2aec4a8fec2686d22c67696ecd714225a563"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "61509d1bbaad341b215c0c90d7f313c48999e75a5f61857c55b9e7b5e7470eb5"
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
