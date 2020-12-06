class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/29/60/8ff9dcb5eac7f4da327ba9ecb74e1ad783b2d32423c06ef599e48c79b1e1/Pygments-2.7.3.tar.gz"
  sha256 "ccf3acacf3782cbed4a989426012f1c535c9a90d3a7fc3f16d231b9372d2b716"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "be5cc6d5c5cac34d16d088b2ba774d6cec53c41d579f86a94e68fa235e4b7309" => :big_sur
    sha256 "8e900db6179b52b2a216430b5b1f7c5962f421c6bea365023cfa22f4198f9aee" => :catalina
    sha256 "0a869fbf52f375e695e13bac636e543f5696fd40372bb6a5085618976d09a617" => :mojave
    sha256 "9f8e6c987e2d6e4f296266501489a0b8f8708588a824cdf1555277f77e6c3036" => :high_sierra
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
