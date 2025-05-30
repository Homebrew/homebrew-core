class Desk < Formula
  desc "Lightweight workspace manager for the shell"
  homepage "https://github.com/jamesob/desk"
  url "https://github.com/jamesob/desk/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "620bfba5b285d4d445e3ff9e399864063d7b0e500ef9c70d887fb7b157576c45"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "95e0acae98be5f6f5d3105ff2c6236d3e9648b8bbc1ab350e7735ed3935db8fe"
  end

  def install
    bin.install "desk"
    bash_completion.install "shell_plugins/bash/desk"
    zsh_completion.install "shell_plugins/zsh/_desk"
    fish_completion.install "shell_plugins/fish/desk.fish"
  end

  test do
    (testpath/".desk/desks/test-desk.sh").write <<~SHELL
      #
      # Description: A test desk
      #
    SHELL
    list = pipe_output("#{bin}/desk list")
    assert_match "test-desk", list
    assert_match "A test desk", list
  end
end
