class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
  sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
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
