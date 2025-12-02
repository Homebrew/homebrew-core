class PackerCompletion < Formula
  desc "Bash completion for Packer"
  homepage "https://github.com/mrolli/packer-bash-completion"
  url "https://github.com/mrolli/packer-bash-completion/archive/refs/tags/1.4.3.tar.gz"
  sha256 "af7b3b49b29ffdb05b519dad2d83066f3d166dd8e29abd406ca0f3d480901df4"
  license "MIT"
  head "https://github.com/mrolli/packer-bash-completion.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "20e50c3d1419e8e86faefc8f726f79fa19d086e438db145679b84853cb6fddeb"
  end

  deprecate! date: "2024-03-12", because: :repo_archived
  disable! date: "2025-03-24", because: :repo_archived

  def install
    bash_completion.install "packer"
  end

  test do
    assert_match "-F _packer_completion",
      shell_output("bash -c 'source #{bash_completion}/packer && complete -p packer'")
  end
end
