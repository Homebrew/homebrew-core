class PythonTabulate < Formula
  desc "Pretty-print tabular data in Python"
  homepage "https://pypi.org/project/tabulate/"
  url "https://files.pythonhosted.org/packages/7a/53/afac341569b3fd558bf2b5428e925e2eb8753ad9627c1f9188104c6e0c4a/tabulate-0.8.10.tar.gz"
  sha256 "6c57f3f3dd7ac2782770155f3adb2db0b1a269637e42f27599925e64b114f519"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e521ca072a0ffb9f7e0cd463b7b9988a8285584172dabb197663c1b60ab3c1c8"
  end

  depends_on "libpython-tabulate"
  depends_on "python@3.10"

  def install
    # Install the binary only, the lib part is provided by libpython-tabulate
    system "python3.10", "setup.py", "--no-user-cfg", "install_scripts", "--install-dir=#{bin}", "--skip-build"
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
