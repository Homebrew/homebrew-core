class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/e0/ef/5905cd3642f2337d44143529c941cc3a02e5af16f0f65f81cbef7af452bb/Pygments-2.13.0.tar.gz"
  sha256 "56a8508ae95f98e2b9bdf93a6be5ae3f7d8af858b43e02c5a2ff083726be40c1"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c088e9c10fb8a38ffff90d0d401a8296949c782530ae81310fdcd8535d5af080"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c088e9c10fb8a38ffff90d0d401a8296949c782530ae81310fdcd8535d5af080"
    sha256 cellar: :any_skip_relocation, monterey:       "6efdb3747f7ec6af4b4dc193f17dc1ba76e3b68a2e1770aa3a27170f833c0e21"
    sha256 cellar: :any_skip_relocation, big_sur:        "6efdb3747f7ec6af4b4dc193f17dc1ba76e3b68a2e1770aa3a27170f833c0e21"
    sha256 cellar: :any_skip_relocation, catalina:       "6efdb3747f7ec6af4b4dc193f17dc1ba76e3b68a2e1770aa3a27170f833c0e21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8eec5295c6384bbc245cf57a27f35caf6d41207d1762504e9e70e0d86eefcf5"
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
