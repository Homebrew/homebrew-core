class GitBigPicture < Formula
  include Language::Python::Virtualenv

  desc "Visualization tool for Git repositories"
  homepage "https://github.com/git-big-picture/git-big-picture"
  url "https://files.pythonhosted.org/packages/e8/81/29b6f4f093a8c788a68e5f8f723f594206a956ca302d23f54018b62cda00/git_big_picture-1.4.2.tar.gz"
  sha256 "5f6b148f9e96a4afdfe532b6074ffee55bcb085f8fce76d223aad2b61fc898d4"
  license "GPL-3.0-or-later"
  head "https://github.com/git-big-picture/git-big-picture.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "76b44e88e8497b78bfe5ea50e8f5059f0a09a0b96687d3fcdda268e727f76dd9"
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
