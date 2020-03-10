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
    sha256 "f623227947b0aa895470efaef4bba20c00188b27bdb4167eba6813f96d6f5dd7" => :catalina
    sha256 "67101433038da4ebfcaff73d4a0c5a7309944b3032d869f388599ce49f3f0ee6" => :mojave
    sha256 "046daa85b6bb22c1c27e21f0f3d7da64c7c4c9a32e1310321db4a58d92514ea2" => :high_sierra
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
