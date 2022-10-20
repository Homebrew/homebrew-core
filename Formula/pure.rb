class Pure < Formula
  desc "Pretty, minimal and fast ZSH prompt"
  homepage "https://github.com/sindresorhus/pure"
  url "https://github.com/sindresorhus/pure/archive/v1.20.4.tar.gz"
  sha256 "e9dfd0c08127f7131051f630ec2ab4349a29de337e39679d4297877811a612d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b998363a8585e8851cac399559164fb950322fd4f035f287b162fc6c5011b9f1"
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
