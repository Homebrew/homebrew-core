class GitBigPicture < Formula
  include Language::Python::Virtualenv

  desc "Visualization tool for Git repositories"
  homepage "https://github.com/git-big-picture/git-big-picture"
  url "https://github.com/git-big-picture/git-big-picture/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "cccbd3e35dfe6d0ce86d06079e80cf9219cb25f887c7a782e2808e740dc23c3a"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2cdbaab936da0256565622a77bcbb1294910f17a0ac75c94a78f5f17df4b0781"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cdbaab936da0256565622a77bcbb1294910f17a0ac75c94a78f5f17df4b0781"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cdbaab936da0256565622a77bcbb1294910f17a0ac75c94a78f5f17df4b0781"
    sha256 cellar: :any_skip_relocation, sonoma:         "2cdbaab936da0256565622a77bcbb1294910f17a0ac75c94a78f5f17df4b0781"
    sha256 cellar: :any_skip_relocation, ventura:        "2cdbaab936da0256565622a77bcbb1294910f17a0ac75c94a78f5f17df4b0781"
    sha256 cellar: :any_skip_relocation, monterey:       "2cdbaab936da0256565622a77bcbb1294910f17a0ac75c94a78f5f17df4b0781"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "447fa107a56fb283f0fa4837f087da0149b352a0a0bbba1c92d217c69a243e63"
  end

  depends_on "graphviz"
  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "Empty commit"
    system "git", "big-picture", "-f", "svg", "-o", "output.svg"
    assert_path_exists testpath/"output.svg"
  end
end
