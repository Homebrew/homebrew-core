class Pure < Formula
  desc "Pretty, minimal and fast ZSH prompt"
  homepage "https://github.com/sindresorhus/pure"
  url "https://github.com/sindresorhus/pure/archive/v1.17.2.tar.gz"
  sha256 "fafc75234ebfd8f0b12c5ac41da55cbe0f282500d3041b5940fa0d7da6f8e361"
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
