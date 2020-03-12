class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/7e/ae/26808275fc76bf2832deb10d3a3ed3107bc4de01b85dcccbe525f2cd6d1e/Pygments-2.4.2.tar.gz"
  sha256 "881c4c157e45f30af185c1ffe8d549d48ac9127433f2c380c24b84572ad66297"
  revision 2

  head "https://github.com/pygments/pygments.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec50d18901c80c4edeea23b739953b983a96105fd52096097b0185073d1d8e15" => :catalina
    sha256 "044c895f0bc8c914b00fecf118e43ae0913c92d0ce8da674e2d6ea36539506b7" => :mojave
    sha256 "f58a13d528e45c7979a8b392b6e45200379b7a32292d9fb139c977fc726e1121" => :high_sierra
  end

  depends_on "python@3.8"

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
