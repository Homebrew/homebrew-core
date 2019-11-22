class PipCompletion < Formula
  desc "Bash completion for Pip"
  homepage "https://github.com/ekalinin/pip-bash-completion"
  url "https://github.com/ekalinin/pip-bash-completion.git",
    :revision => "f5a7216a5620c3da5ae1d4a2c6ce9b64009b31c2"
  version "20190723"
  head "https://github.com/ekalinin/pip-bash-completion.git"

  bottle :unneeded

  def install
    bash_completion.install "pip"
  end

  test do
    assert_match "-F _pip",
      shell_output("source #{bash_completion}/pip && complete -p pip")
  end
end
