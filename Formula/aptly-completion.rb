class AptlyCompletion < Formula
  desc "Bash completion for Aptly"
  homepage "https://github.com/aptly-dev/aptly-bash-completion"
  url "https://github.com/aptly-dev/aptly-bash-completion/archive/0.9.7.tar.gz"
  sha256 "08504ffd9d8fd00a0cafe5758f92e5dbda2675e77e3d6c258110980c6e7527a6"
  head "https://github.com/aptly-dev/aptly-bash-completion.git"

  bottle :unneeded

  def install
    bash_completion.install "aptly"
  end

  test do
    assert_match "-F _aptly",
      shell_output("source #{bash_completion}/aptly && complete -p aptly")
  end
end
