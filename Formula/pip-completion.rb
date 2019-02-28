class PipCompletion < Formula
  desc "Bash completion for Pip"
  homepage "https://github.com/ekalinin/pip-bash-completion"
  url "https://github.com/ekalinin/pip-bash-completion.git",
    :revision => "87983a927dc372b66952a6ef84ade70dd86450f9"
  version "20161126"
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
