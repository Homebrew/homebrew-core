class PythonTabulate < Formula
  desc "Pretty-print tabular data in Python"
  homepage "https://pypi.org/project/tabulate/"
  url "https://files.pythonhosted.org/packages/ae/3d/9d7576d94007eaf3bb685acbaaec66ff4cdeb0b18f1bf1f17edbeebffb0a/tabulate-0.8.9.tar.gz"
  sha256 "eb1d13f25760052e8931f2ef80aaf6045a6cceb47514db8beab24cded16f13a7"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5bd465f5fd9a0e3eb107c4cdd244b63090a2ce102346f7d7fecfcdbabc1812a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2beca641f9753d21b695dd61d57f2557dee3231c78dad9d7e5c456554b792f44"
    sha256 cellar: :any_skip_relocation, monterey:       "f5bd465f5fd9a0e3eb107c4cdd244b63090a2ce102346f7d7fecfcdbabc1812a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6dc3b60616b7fc6d810a17471bdd2ca872224560a5283039eae5dd618b8c65d"
    sha256 cellar: :any_skip_relocation, catalina:       "9e8e0c24b82a80db0e474a1cbb4cfd4e8628513fc8d70dfe6dde0c49b197df17"
    sha256 cellar: :any_skip_relocation, mojave:         "3d9e98f92133a5c058618584b0178645eafb0230531fbef665d3ed2546f63f0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5bd465f5fd9a0e3eb107c4cdd244b63090a2ce102346f7d7fecfcdbabc1812a"
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
