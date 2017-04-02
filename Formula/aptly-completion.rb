class AptlyCompletion < Formula
  desc "Bash completion for Aptly"
  homepage "https://github.com/aptly-dev/aptly-bash-completion"
  url "https://github.com/aptly-dev/aptly-bash-completion/archive/1.0.0.tar.gz"
  sha256 "d5e8f51c82f35db7d25ddfb7e3898ec09338829c474733bbbd01c893ad6fa3a5"
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
