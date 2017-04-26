class PackerCompletion < Formula
  desc "Bash completion for Packer"
  homepage "https://github.com/mrolli/packer-bash-completion"
  url "https://github.com/mrolli/packer-bash-completion.git",
    :revision => "4f1363dd749fa08dfa2cb991f269471738b004e2"
  version "1.0.0"

  head "https://github.com/mrolli/packer-bash-completion.git"

  bottle :unneeded

  def install
    bash_completion.install "packer"
  end

  test do
    assert_match "-F _packer_completion",
      shell_output("source #{bash_completion}/packer && complete -p packer")
  end
end
