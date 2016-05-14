class Desk < Formula
  desc "Lightweight workspace manager for the shell"
  homepage "https://github.com/jamesob/desk"
  url "https://github.com/jamesob/desk/archive/v0.5.0.tar.gz"
  sha256 "4ed7a2547fdb3e442e9456be7ca27c41f3fc580d3fdffd69fcfed84260ca2576"

  bottle :unneeded

  def install
    bin.install "desk"
    bash_completion.install "shell_plugins/bash/desk"
    zsh_completion.install "shell_plugins/zsh/_desk"
    fish_completion.install "shell_plugins/fish/desk.fish"
  end

  test do
    (testpath/".desk/desks/test-desk.sh").write("#\n# Description: A test desk\n#")
    list = pipe_output("#{bin}/desk list")
    assert_match /test-desk/, list
    assert_match /A test desk/, list
  end
end
