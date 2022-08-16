class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/e0/ef/5905cd3642f2337d44143529c941cc3a02e5af16f0f65f81cbef7af452bb/Pygments-2.13.0.tar.gz"
  sha256 "56a8508ae95f98e2b9bdf93a6be5ae3f7d8af858b43e02c5a2ff083726be40c1"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4c7d99905c7d9895a5480f2f2f1c2a5298e3deb6672f4ff095b6d0901b63ee1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4c7d99905c7d9895a5480f2f2f1c2a5298e3deb6672f4ff095b6d0901b63ee1"
    sha256 cellar: :any_skip_relocation, monterey:       "160c038d24aa8d3ad62b15846e72fa092738132c4c33d8382db29b1f771d06e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "160c038d24aa8d3ad62b15846e72fa092738132c4c33d8382db29b1f771d06e8"
    sha256 cellar: :any_skip_relocation, catalina:       "160c038d24aa8d3ad62b15846e72fa092738132c4c33d8382db29b1f771d06e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c21d509491a4667da89fb9a3c3de978b0b9fc62426c6df146a46552be05047f"
  end

  depends_on "python@3.10"

  def install
    bash_completion.install "external/pygments.bashcomp" => "pygmentize"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
      print(os.getcwd())
    EOS

    system bin/"pygmentize", "-f", "html", "-o", "test.html", testpath/"test.py"
    assert_predicate testpath/"test.html", :exist?
  end
end
