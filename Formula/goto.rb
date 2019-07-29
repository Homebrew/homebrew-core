class Goto < Formula
  desc "Bash tool for navigation to aliased directories with auto-completion"
  homepage "https://github.com/iridakos/goto"
  url "https://github.com/iridakos/goto/archive/v1.2.3.tar.gz"
  sha256 "856e0c2b9f7e8f55ff9aa9bdb356dbc831644f7b25da1d5f1e9ae8c3ff538d47"

  bottle :unneeded

  def install
    bash_completion.install "goto.sh"
  end

  test do
    output = shell_output("source #{bash_completion}/goto.sh && complete -p goto")
    assert_match "-F _complete_goto_bash", output
  end
end
