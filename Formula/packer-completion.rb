class PackerCompletion < Formula
  desc "Bash completion for Packer"
  homepage "https://github.com/mrolli/packer-bash-completion"
  url "https://github.com/mrolli/packer-bash-completion/archive/1.0.0.tar.gz"
  sha256 "20ebfacd3f3a60f8dbd09e25b97d3b6e5049cbdf00a2d607fe79eaaef39e1eea"
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
