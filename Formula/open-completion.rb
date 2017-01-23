class OpenCompletion < Formula
  desc "Bash completion for open"
  homepage "https://github.com/moshen/open-bash-completion"
  url "https://github.com/moshen/open-bash-completion/archive/v1.0.3.tar.gz"
  sha256 "e7ed931d49d2c9ed5bc4fcad1b60a8c4cb6d4bca86948cb54e6689f313a2029e"
  head "https://github.com/moshen/open-bash-completion.git"

  bottle :unneeded

  def install
    bash_completion.install "open"
  end

  test do
    assert_match "-F _open",
      shell_output("source #{bash_completion}/open && complete -p open")
  end
end
