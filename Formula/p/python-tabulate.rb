class PythonTabulate < Formula
  desc "Pretty-print tabular data in Python"
  homepage "https://github.com/astanin/python-tabulate"
  url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
  sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f01d2154c35a96175ed58d764e513c83f939f0bdba62f617360df67a469a690"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f4936777a24b5061f87e299884aef95136b4d252b923ae305d9bbe73e2dad28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5e460cc4ab943bd3df71621927870d82c82e9cf04952685777da57f6f617623"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7520c9d33cb5d3a87400aa0c08cf34ca4af36fd0a37f4efef343d4babc859cd5"
    sha256 cellar: :any_skip_relocation, sonoma:         "d60449053b74014e77ef43fc1545ad2c9e785f2371ccb7300962d1920aa413dd"
    sha256 cellar: :any_skip_relocation, ventura:        "6262b211e0254a8e7201f596ed6e7ad7901f943d095e59f73d87a1e6af420d53"
    sha256 cellar: :any_skip_relocation, monterey:       "76ef2b0a509160d8cd16b0e8311f91ededec7e46f318143d6b96059b86032c53"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bf325d06152ecf195d458012ac7be874b25bd6329fceb463be171d0c5a8c9ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47496825538f1a5d0ab294a6fd11f303db31bdfbc88703df81603b903ba8815f"
  end

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test] # FIXME: should be runtime dependency

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
