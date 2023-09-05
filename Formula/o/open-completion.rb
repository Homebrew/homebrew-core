class OpenCompletion < Formula
  desc "Bash completion for open"
  homepage "https://github.com/moshen/open-bash-completion"
  url "https://github.com/moshen/open-bash-completion/archive/v1.0.5.tar.gz"
  sha256 "bee63ee57278de3305b26a581ae23323285a3e2af80ee75d7cfca3f92dfe3721"
  license "MIT"
  head "https://github.com/moshen/open-bash-completion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "277bb92070915a0d5cd8a76853d603ce6a4c02624c9bb0865c14e9fb04fc1b98"
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
