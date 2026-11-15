class GitBigPicture < Formula
  include Language::Python::Virtualenv

  desc "Visualization tool for Git repositories"
  homepage "https://github.com/git-big-picture/git-big-picture"
  url "https://files.pythonhosted.org/packages/bb/df/15392f049576f9b3989ffe9d5ec12135f8d9618c089a6259c5a2c16556c9/git-big-picture-1.3.0.tar.gz"
  sha256 "a36539d20059d24516bcb6bbf6bca0a6932a7a8ac480b4b5b68e9e863a2666a5"
  license "GPL-3.0-or-later"
  head "https://github.com/git-big-picture/git-big-picture.git", branch: "main"

  bottle do
    rebuild 6
    sha256 cellar: :any_skip_relocation, all: "a6cf32be8a82d9bde4c15d16212748953a6624f8f92cff6a73735299e2585412"
  end

  depends_on "graphviz"
  depends_on "python@3.15"

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
