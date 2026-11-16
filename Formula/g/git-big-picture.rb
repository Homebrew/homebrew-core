class GitBigPicture < Formula
  include Language::Python::Virtualenv

  desc "Visualization tool for Git repositories"
  homepage "https://github.com/git-big-picture/git-big-picture"
  url "https://files.pythonhosted.org/packages/be/db/ccd8e2c699a6d2b1f98e56ad5fce4f193b0a64554f0d7016afc42c90f909/git_big_picture-1.4.1.tar.gz"
  sha256 "ed3e30fe43ee35b5fb6116fedffc12d1b98900e0984367016b177906bbeea2a8"
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
