class OpenCompletion < Formula
  desc "Bash completion for open"
  homepage "https://github.com/moshen/open-bash-completion"
  url "https://github.com/moshen/open-bash-completion/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "bee63ee57278de3305b26a581ae23323285a3e2af80ee75d7cfca3f92dfe3721"
  license "MIT"
  head "https://github.com/moshen/open-bash-completion.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "446d03e5ddceca4179f58fb2378d39f0cc1559f2b876ad53291c59ae1f43d548"
  end

  depends_on :macos

  def install
    bash_completion.install "open"
  end

  test do
    assert_match "-F _open",
      shell_output("bash -c 'source #{bash_completion}/open && complete -p open'")
  end
end
