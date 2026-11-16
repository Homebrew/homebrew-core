class GitBigPicture < Formula
  include Language::Python::Virtualenv

  desc "Visualization tool for Git repositories"
  homepage "https://github.com/git-big-picture/git-big-picture"
  url "https://files.pythonhosted.org/packages/0e/d1/32f316a79c1d4becb1f9855637ebe91e3ac987a46b1511bb4e3c93769bb5/git_big_picture-1.4.0.tar.gz"
  sha256 "9d4f5163252a2ad838b5261316132064ef3bd23dacffb616b8b95a6ccc315c41"
  license "GPL-3.0-or-later"
  head "https://github.com/git-big-picture/git-big-picture.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "77b72994c9726d745e8a8c7e75e25be1be9279789c0adc7acbfd170bce7c6f1c"
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
