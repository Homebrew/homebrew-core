class Goto < Formula
  desc "Bash tool for navigation to aliased directories with auto-completion"
  homepage "https://github.com/iridakos/goto"
  url "https://github.com/iridakos/goto/archive/v1.2.2.tar.gz"
  sha256 "611ef7b82f6798ef83db0473811740c7f1ff5a15bb4ff52a1e5841bac87ba7f5"

  bottle :unneeded

  def install
    bash_completion.install "goto.sh"
  end

  test do
    output = shell_output("source #{bash_completion}/goto.sh && complete -p goto")
    assert_match "-F _complete_goto_bash", output
  end
end
