class Pure < Formula
  desc "Pretty, minimal and fast ZSH prompt"
  homepage "https://github.com/sindresorhus/pure"
  url "https://github.com/sindresorhus/pure/archive/v1.17.1.tar.gz"
  sha256 "b2527e100e35bc2877036a6f7a19397c982b3204c2df44ead65f6b9198b91305"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f5527c10849ad5b81b534f37d31138b3edae0280166b103e2b2618803bb80e74"
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
