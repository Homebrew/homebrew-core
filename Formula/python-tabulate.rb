class PythonTabulate < Formula
  desc "Pretty-print tabular data in Python"
  homepage "https://github.com/astanin/python-tabulate"
  url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
  sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb133399eb9eac5597456ff97ad2998098d51b92a306f2ac69b6ddab10b1d7a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59b5698b0f1d90ce0f4db412cfbe18173a9ff1c07bbce8b7e32f9618f3eeddb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ac5018fabca43b5fda8c0c527152a0dc305b5f6ea13146a0e15a0b74e417880"
    sha256 cellar: :any_skip_relocation, ventura:        "340787a971287aee2cb7419e2a1c5b8dbc5361e1ccd943efe0e6202b6933e5c3"
    sha256 cellar: :any_skip_relocation, monterey:       "3e58adc3d2ab1940c6ee27404186fbc871fb9c5cf246039c7309e06430083322"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4ac8f5dc44de25a24a0ee597e7fef637e40f7f9d0490142769a5142f95762a2"
    sha256 cellar: :any_skip_relocation, catalina:       "31f07e4ef0661c4da765fbca3f8c6bf8571996a6cf2b661c0dff8f18cb9e6c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83dbafc2f1d09361907a7746347f6dfe0c3a0add8dc66710ea50ff39abe3725b"
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
