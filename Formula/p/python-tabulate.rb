class PythonTabulate < Formula
  desc "Pretty-print tabular data in Python"
  homepage "https://github.com/astanin/python-tabulate"
  url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
  sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82adfd13997556aaa1a2c3d70df498ff8ce85bc14a5cd05a71c20e17f06aa28c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f14c4a0547033da7bbd63156643bc74a9637edf100c663cc411cf8fd5b3ac042"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3a6e9aa47ae45a92384d4232dc5f4e1cfb207da717943255140b52920aab6b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "adffa4d3698dca4606a5c17a3eda30904c4733e0102aa53d65b24a17cccf849c"
    sha256 cellar: :any_skip_relocation, ventura:        "b9e431bc31ccc805517121f05b2401b4a9bba39ae24a9291e1ea43b7006bd806"
    sha256 cellar: :any_skip_relocation, monterey:       "10e6f0b23030d5abea903d88d64a8a78ac4c82750063e12f628cd35b549fec66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e359253d90d409f0c8c98916ab2ee01a39b680ecc567f62f34dab245eddb4654"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test] # FIXME: should be runtime dependency

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .sort_by(&:version)
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
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
