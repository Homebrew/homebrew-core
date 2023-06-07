class Pycparser < Formula
  desc "C parser in Python"
  homepage "https://github.com/eliben/pycparser"
  url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
  sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "882d005d9bcc429f3eee0d5cdb3c5065302ec25c96ea1ae3d5a32fb1f6f08cb8"
  end

  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    system python3, *Language::Python.setup_install_args(prefix, python3)
    pkgshare.install "examples"
  end

  test do
    examples = pkgshare/"examples"
    system python3, examples/"c-to-c.py", examples/"c_files/basic.c"
  end
end
