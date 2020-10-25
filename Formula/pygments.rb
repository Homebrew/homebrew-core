class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/5d/0e/ff13c055b014d634ed17e9e9345a312c28ec6a06448ba6d6ccfa77c3b5e8/Pygments-2.7.2.tar.gz"
  sha256 "381985fcc551eb9d37c52088a32914e00517e57f4a21609f48141ba08e193fa0"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "77d8bf6fe306db9188a28e33b5f726ddfd4a6f2681445b5f63800f22dc12b75e" => :catalina
    sha256 "675ff6a15cfacb88ab07724dde5cdd6f9f0b97c83a3cfa32f2a0223ab6cf8a0c" => :mojave
    sha256 "6edc5643a255601adc1564db75f6a8bc47233cf23a2dbabd0e4361a7e9a66298" => :high_sierra
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
