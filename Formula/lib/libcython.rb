class Libcython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/d3/20/02f4961b4315b95989abfe4b7cedff263cc89693834222d210a7a62a6214/Cython-3.0.6.tar.gz"
  sha256 "399d185672c667b26eabbdca420c98564583798af3bc47670a8a09e9f19dd660"
  license "Apache-2.0"

  livecheck do
    formula "cython"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb0c6a454c730b4624d93976a5befaa0bb86a53b280b5c90a878739dd3d93d6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a632f42973c57bc05a0b20e18d46c1fb7e83dccd51d64be2ee10c1799dabf3a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e6573adc2f1cad0e497eaa33cbafc62c6331d40e4008e26b501adbc430a4b3e"
    sha256 cellar: :any_skip_relocation, sonoma:         "1fce1688407547e7ee8e103e456f5617dd9630365528637a88b8073c7d12271f"
    sha256 cellar: :any_skip_relocation, ventura:        "8f5a2e8d65680f4bb2d9d9651a4ef852633008f790177b217af096c7d1d452de"
    sha256 cellar: :any_skip_relocation, monterey:       "ff926b459082b369e96c0cbff2d63d7a2623dfa7171d20df7eea327ab4787622"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "944dde97f5c82b743a13e214405fa921151ebbf996e58d92f7f540fd897ad7d3"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python-setuptools" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .sort_by(&:version)
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."
    end
  end

  test do
    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~EOS
      from setuptools import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    EOS
    pythons.each do |python|
      with_env(PYTHONPATH: libexec/Language::Python.site_packages(python)) do
        system python, "setup.py", "build_ext", "--inplace"
        assert_match phrase, shell_output("#{python} -c 'import package_manager'")
      end
    end
  end
end
