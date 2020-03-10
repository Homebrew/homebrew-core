class OpenCompletion < Formula
  desc "Bash completion for open"
  homepage "https://github.com/moshen/open-bash-completion"
  url "https://github.com/moshen/open-bash-completion/archive/v1.0.4.tar.gz"
  sha256 "23a8a30f9f65f5b3eb60aa6f2d1c60d7d0a858ea753a58f31ddb51d40e16b668"
  head "https://github.com/moshen/open-bash-completion.git"

  bottle :unneeded

  def install
    bash_completion.install "open"
  end

  test do
    assert_match "-F _open",
      shell_output("bash -c 'source #{bash_completion}/open && complete -p open'")
  end
end
