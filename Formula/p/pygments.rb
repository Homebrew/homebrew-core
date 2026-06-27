class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
  sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a2aedfa8d78eb732b672d4c674e11bdfa764cecc85c0332f2cd23fabeef103ed"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
    bash_completion.install "external/pygments.bashcomp" => "pygmentize"
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      import os
      print(os.getcwd())
    PYTHON

    system bin/"pygmentize", "-f", "html", "-o", "test.html", testpath/"test.py"
    assert_path_exists testpath/"test.html"
  end
end
