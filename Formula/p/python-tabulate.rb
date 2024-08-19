class PythonTabulate < Formula
  include Language::Python::Virtualenv

  desc "Pretty-print tabular data in Python"
  homepage "https://github.com/astanin/python-tabulate"
  url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
  sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  license "MIT"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0512d6d0541a35bb5f78c28b6d03f75dd5356f4214feec5d57ddf29dee8ab0b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0512d6d0541a35bb5f78c28b6d03f75dd5356f4214feec5d57ddf29dee8ab0b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0512d6d0541a35bb5f78c28b6d03f75dd5356f4214feec5d57ddf29dee8ab0b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "0512d6d0541a35bb5f78c28b6d03f75dd5356f4214feec5d57ddf29dee8ab0b6"
    sha256 cellar: :any_skip_relocation, ventura:        "0512d6d0541a35bb5f78c28b6d03f75dd5356f4214feec5d57ddf29dee8ab0b6"
    sha256 cellar: :any_skip_relocation, monterey:       "0512d6d0541a35bb5f78c28b6d03f75dd5356f4214feec5d57ddf29dee8ab0b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f68075d1e03e127ee0fc20bcc6202d26823d36e7637ca2f52b9384b3d067a3b"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"in.txt").write <<~EOS
      name qty
      eggs 451
      spam 42
    EOS

    (testpath/"out.txt").write <<~EOS
      +------+-----+
      | name | qty |
      +------+-----+
      | eggs | 451 |
      +------+-----+
      | spam | 42  |
      +------+-----+
    EOS

    assert_equal (testpath/"out.txt").read, shell_output("#{bin}/tabulate -f grid #{testpath}/in.txt")
  end
end
