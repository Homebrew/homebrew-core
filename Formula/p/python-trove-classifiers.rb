class PythonTroveClassifiers < Formula
  desc "Canonical source for classifiers on PyPI"
  homepage "https://github.com/pypa/trove-classifiers"
  url "https://files.pythonhosted.org/packages/98/01/e2bc94b71ebaa2c8092cd392caaf5ad42d55c5aaa21a575ab7684e080851/trove_classifiers-2024.5.22.tar.gz"
  sha256 "8a6242bbb5c9ae88d34cf665e816b287d2212973c8777dfaef5ec18d72ac1d03"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "60b794b825880dce65e9024a83930814c42be20b2cac8c4f162e92d83fe86eed"
  end

  disable! date: "2024-07-05", because: "does not meet homebrew/core's requirements for Python library formulae"

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  def caveats
    <<~EOS
      Additional details on upcoming formula removal are available at:
      * https://github.com/Homebrew/homebrew-core/issues/157500
      * https://docs.brew.sh/Python-for-Formula-Authors#libraries
      * https://docs.brew.sh/Homebrew-and-Python#pep-668-python312-and-virtual-environments
    EOS
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      classifiers = shell_output("#{python_exe} -m trove_classifiers")
      assert_match "Environment :: MacOS X", classifiers
    end
  end
end
