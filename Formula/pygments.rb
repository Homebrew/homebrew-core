class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
  sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8946aab517a5db3fc574e647a92a22513333c4731c4ecfa9fa31087b14e71376"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8946aab517a5db3fc574e647a92a22513333c4731c4ecfa9fa31087b14e71376"
    sha256 cellar: :any_skip_relocation, monterey:       "1144025d257641b8df2002a0c7c55953d030050d06f8bd2f0cc739d926d993f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "1144025d257641b8df2002a0c7c55953d030050d06f8bd2f0cc739d926d993f2"
    sha256 cellar: :any_skip_relocation, catalina:       "1144025d257641b8df2002a0c7c55953d030050d06f8bd2f0cc739d926d993f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afc7ae61ad47ae9bf35739f29ee36e8ea9fdb205ca4e46b706d2d773c083d66a"
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
