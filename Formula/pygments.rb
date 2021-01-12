class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/e1/86/8059180e8217299079d8719c6e23d674aadaba0b1939e25e0cc15dcf075b/Pygments-2.7.4.tar.gz"
  sha256 "df49d09b498e83c1a73128295860250b0b7edd4c723a32e9bc0d295c7c2ec337"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a97e775ec600eac6459e812a5b56d6be6e31942eb700650749becf84f97d7f33" => :big_sur
    sha256 "076471967168c0e3fcea735c1cfea2c1e1c568acb8851a94afee7bfe47238414" => :arm64_big_sur
    sha256 "ebf72c4fbc6b7c4992ecb815a9092f52e6a862deeb6ba2e4534aa62701a40e02" => :catalina
    sha256 "c3fa220fa15087e40f4df61f3c7c249b8bec78177d6609306a92b3c1af92ecb3" => :mojave
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
