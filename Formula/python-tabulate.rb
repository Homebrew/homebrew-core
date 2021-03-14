class PythonTabulate < Formula
  desc "Pretty-print tabular data in Python"
  homepage "https://pypi.org/project/tabulate/"
  url "https://files.pythonhosted.org/packages/ae/3d/9d7576d94007eaf3bb685acbaaec66ff4cdeb0b18f1bf1f17edbeebffb0a/tabulate-0.8.9.tar.gz"
  sha256 "eb1d13f25760052e8931f2ef80aaf6045a6cceb47514db8beab24cded16f13a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a0c0264bb2566ba54fea39d410ac559adc9bd064a7459590f276f6bc806de18d"
    sha256 cellar: :any_skip_relocation, big_sur:       "a2261b94cbed74c1dd639cfcfcfeb862e36776f9e1c0c7992b77b2598bd277f3"
    sha256 cellar: :any_skip_relocation, catalina:      "d3cf2f4240d1017a944a2f0853b4e2080ec208c8e4907d47edc2d7549a9da3bc"
    sha256 cellar: :any_skip_relocation, mojave:        "9b36addf9d6d81022caef2e3ec8b874c2b7463cee9c4098dae3613c8e600900d"
  end

  depends_on "python@3.9"

  def install
    system Formula["python@3.9"].bin/"python3", *Language::Python.setup_install_args(prefix)
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
    system Formula["python@3.9"].opt_bin/"python3", "-c", "from tabulate import tabulate"
  end
end
