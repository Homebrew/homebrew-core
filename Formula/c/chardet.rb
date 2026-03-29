class Chardet < Formula
  include Language::Python::Virtualenv

  desc "Python character encoding detector"
  homepage "https://chardet.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/03/4b/1fe1ade6b4d33abff0224b45a8310775b04308668ad1bdef725af8e3fcaa/chardet-7.4.0.post2.tar.gz"
  sha256 "21a6b5ca695252c03385dcfcc8b55c27907f1fe80838aa171b1ff4e356a1bb67"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "af03e594bf8ee317227d55fe9d8d8690008fc79b9e108db85deddf61a723ceaf"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.txt").write "你好"
    output = shell_output("#{bin}/chardetect #{testpath}/test.txt")
    assert_match "test.txt: utf-8 with confidence", output
  end
end
