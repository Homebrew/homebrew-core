class LibpythonTabulate < Formula
  desc "Pretty-print tabular data in Python"
  homepage "https://pypi.org/project/tabulate/"
  url "https://files.pythonhosted.org/packages/7a/53/afac341569b3fd558bf2b5428e925e2eb8753ad9627c1f9188104c6e0c4a/tabulate-0.8.10.tar.gz"
  sha256 "6c57f3f3dd7ac2782770155f3adb2db0b1a269637e42f27599925e64b114f519"
  license "MIT"
  revision 1

  livecheck do
    formula "python-tabulate"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f58920620a2e967a0d918dad5ef9f636f0b5883e525bf1c4967d49bfd38699ec"
  end

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, *Language::Python.setup_install_args(prefix, python)
    end

    # Remove bin folder, use tabulate from the python-tabulate formula instead.
    # This is necessary to keep all the Python versions as build/test
    # dependencies only for the libpython-tabulate
    rm_rf prefix/"bin"
  end

  test do
    pythons.each do |python|
      system python, "-c", "from tabulate import tabulate"
    end
  end
end
