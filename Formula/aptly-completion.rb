class AptlyCompletion < Formula
  desc "Bash completion for Aptly"
  homepage "https://github.com/aptly-dev/aptly-bash-completion"
  url "https://github.com/aptly-dev/aptly-bash-completion/archive/0.9.5.tar.gz"
  sha256 "3b912787808e86ddd7c30555d2b09951e564956dddfe8b521f104651cfe7da96"
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
