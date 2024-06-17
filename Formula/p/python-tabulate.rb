class PythonTabulate < Formula
  desc "Pretty-print tabular data in Python"
  homepage "https://github.com/astanin/python-tabulate"
  url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
  sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6192893380cdad98357611640c0093ba73dc447b2625f75952cb77e24621b8f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25317d4c2280da78334544b12f43a750e461bd639e377cdbc8db79fc5cf2af1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "530188e12213873fd771c261b559e48b0cd26b42e20c1324ec6b64ab426028ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "a781d2bbbd0f8233087ba16954243be1c84a45138c2d0e1619c68635ea834abd"
    sha256 cellar: :any_skip_relocation, ventura:        "16f57ba4cdec4823690d6f1e100627c8ee8401df5ed257c39d034514b601aa12"
    sha256 cellar: :any_skip_relocation, monterey:       "4999cd9fd9e1ae46b802a439ab1f91cd9b2e18226e782206b7d37361849d627d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a2594750f8c12674c7932cf82e2b2e40b0aef5d91da0cf8fb4906ea8cd173e2"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test] # FIXME: should be runtime dependency

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .sort_by(&:version)
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  def caveats
    <<~EOS
      To run `tabulate`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from tabulate import tabulate"
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
