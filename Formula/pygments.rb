class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/e1/86/8059180e8217299079d8719c6e23d674aadaba0b1939e25e0cc15dcf075b/Pygments-2.7.4.tar.gz"
  sha256 "df49d09b498e83c1a73128295860250b0b7edd4c723a32e9bc0d295c7c2ec337"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a03ce270d1a5bc2b1b0b59b07939f041a433873fb89c3cb48df1d89ef9df8443"
    sha256 cellar: :any_skip_relocation, big_sur:       "ba143cb212e8a0e5065d46784c113d120b620dfc03bf01de940aea49c024b18f"
    sha256 cellar: :any_skip_relocation, catalina:      "9725becf19d65286936b2a260b4c9da4edc17240d7f91b896993393b227f08fd"
    sha256 cellar: :any_skip_relocation, mojave:        "60e2749b874ba3bf69c7034d2ecbe00b340f2eae14a5ca5c9362e3f1ea1695ab"
  end

  depends_on "python@3.9"

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
