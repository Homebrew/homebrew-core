class AptlyCompletion < Formula
  desc "Bash completion for Aptly"
  homepage "https://github.com/aptly-dev/aptly-bash-completion"
  url "https://github.com/aptly-dev/aptly-bash-completion/archive/1.0.1.tar.gz"
  sha256 "61ea79f20e494b4961538bcf134604cc0d1fa6e9494503a068c56445b79d8cb0"
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
