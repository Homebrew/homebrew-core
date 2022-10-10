class PythonTabulate < Formula
  desc "Pretty-print tabular data in Python"
  homepage "https://github.com/astanin/python-tabulate"
  url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
  sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "61e7d23a6d7de917886da888949aef4363ee874ce4d1f153344992b6f2e2c9e5"
  end

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", "--prefix=#{prefix}", "--no-deps", "."
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "from tabulate import tabulate"
    end

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
