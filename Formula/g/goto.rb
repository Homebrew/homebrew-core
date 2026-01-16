class Goto < Formula
  desc "Bash tool for navigation to aliased directories with auto-completion"
  homepage "https://github.com/iridakos/goto"
  url "https://github.com/iridakos/goto/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "460fe3994455501b50b2f771f999ace77ade295122e90e959084047dbfb1f0dc"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "43777539bca93f8ed079e3c3701cc37128ac7ba6b98006b91c39a0aa2e6b09bc"
  end

  def install
    bash_completion.install "goto.sh"
  end

  test do
    assert_match "-F _complete_goto_bash",
      shell_output("bash -c 'source #{bash_completion}/goto.sh && complete -p goto'")
  end
end
