class Chardet < Formula
  include Language::Python::Virtualenv

  desc "Python character encoding detector"
  homepage "https://chardet.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/1d/94/7af830a4c63df020644aa99d76147d003a1463f255d0a054958978be5a8a/chardet-7.2.0.tar.gz"
  sha256 "4ef7292b1342ea805c32cce58a45db204f59d080ed311d6cdaa7ca747fcc0cd5"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c2feb9898523b30930683209fec677f5b8272c811bb13aade70aa11fda47cafa"
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
