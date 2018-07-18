class PipCompletion < Formula
  desc "Bash completion for Pip"
  homepage "https://github.com/ekalinin/pip-bash-completion"
  url "https://github.com/ekalinin/pip-bash-completion.git",
    :revision => "92faa3e4504428ea658a1e83e54caf08cdbb555a"
  version "20150819"
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
