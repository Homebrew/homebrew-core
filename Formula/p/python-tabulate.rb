class PythonTabulate < Formula
  include Language::Python::Virtualenv

  desc "Pretty-print tabular data in Python"
  homepage "https://github.com/astanin/python-tabulate"
  url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
  sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cf5d7aede52290a5bf98484a5d72b5475f88a6cf877a8b2e04a6d284f927bf3d"
  end

  depends_on "python@3.14"

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
