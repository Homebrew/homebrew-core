class Libcython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/7f/a2/fd5ced5dd33597ef291861bfadd46820de417b41bcb6ca2fa0b5f6fa8152/Cython-3.0.0.tar.gz"
  sha256 "350b18f9673e63101dbbfcf774ee2f57c20ac4636d255741d76ca79016b1bd82"
  license "Apache-2.0"

  livecheck do
    formula "cython"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac5d6f50b1733204c1081a4f281cbd764c9c54da360dc947dd8342a1e35885ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39d73ba299bbe56052c78e1985aa86a859f06bf5d3309b64a798e457b7694343"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c92bb4753d1616112242f376dc79fd17aeddcd46fdbaa8f6eff2d8d2242ac1dd"
    sha256 cellar: :any_skip_relocation, ventura:        "f066474b198d21f3a5aeafaa64c043f40541e308ff8c041b1c5a53242630e2be"
    sha256 cellar: :any_skip_relocation, monterey:       "f8adf04a82bc3f4f9ecc1af1b9bd423e34a435189bd6ddea26dbe59635bc8552"
    sha256 cellar: :any_skip_relocation, big_sur:        "9916538d6f7d53fa62a80e1d79dc26ca61ea16a5623ca20bcacce7dd2cfb4222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4621bf731ee0e86c5c538d199975d029538bb97b76f45eb7cb89708c1407db3a"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]

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
      from distutils.core import setup
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
