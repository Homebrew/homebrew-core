class PythonTabulate < Formula
  desc "Pretty-print tabular data in Python"
  homepage "https://pypi.org/project/tabulate/"
  url "https://files.pythonhosted.org/packages/ae/3d/9d7576d94007eaf3bb685acbaaec66ff4cdeb0b18f1bf1f17edbeebffb0a/tabulate-0.8.9.tar.gz"
  sha256 "eb1d13f25760052e8931f2ef80aaf6045a6cceb47514db8beab24cded16f13a7"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5cc7ddf671e6767d31b3fa40a8ebdd387c91251ce79751933d20479867d694a4"
  end

  depends_on "libpython-tabulate"
  depends_on "python@3.9"

  def install
    # Install the binary only, the lib part is provided by libpython-tabulate
    system "python3", "setup.py", "--no-user-cfg", "install_scripts", "--install-dir=#{bin}", "--skip-build"
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
