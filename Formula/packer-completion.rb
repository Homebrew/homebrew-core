class PackerCompletion < Formula
  desc "Bash completion for Packer"
  homepage "https://github.com/mrolli/packer-bash-completion"
  url "https://github.com/mrolli/packer-bash-completion/archive/1.4.3.tar.gz"
  sha256 "af7b3b49b29ffdb05b519dad2d83066f3d166dd8e29abd406ca0f3d480901df4"
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
