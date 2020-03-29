class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/6e/4d/4d2fe93a35dfba417311a4ff627489a947b01dc0cc377a3673c00cf7e4b2/Pygments-2.6.1.tar.gz"
  sha256 "647344a061c249a3b74e230c739f434d7ea4d8b1d5f3721bc0f3558049b38f44"

  head "https://github.com/pygments/pygments.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "509010be01f39644658904cd9396824b6cee202083b4659d8dd7e03e7f8afd17" => :catalina
    sha256 "6c413d6695fc730fcc6e547e1de3bf55ed245f66059eebfa2e99a683b240dbe5" => :mojave
    sha256 "42cc8f55ba8f2ca0766f7d99b1921671ad6d6aa884f23f1fbe88192e92ec89cb" => :high_sierra
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
