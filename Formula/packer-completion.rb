class PackerCompletion < Formula
  desc "Bash completion for Packer"
  homepage "https://github.com/mrolli/packer-bash-completion"
  url "https://github.com/mrolli/packer-bash-completion.git",
    :revision => "2bd2d9da8bdcc7a763a0c551fa9ae8617dc5ecb7"
  version "0.6.0"

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
