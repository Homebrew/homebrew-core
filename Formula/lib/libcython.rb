class Libcython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/0e/17/c5b026cea7a634ee3b8950a7be16aaa49deeb3b9824ba5e81c13ac26f3c4/Cython-3.0.9.tar.gz"
  sha256 "a2d354f059d1f055d34cfaa62c5b68bc78ac2ceab6407148d47fb508cf3ba4f3"
  license "Apache-2.0"

  livecheck do
    formula "cython"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2aece23ad8e946b8b068422113d807258037b7664719f5c3f0e16cb10a51beb2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4d25e856bf8d112e5ea5b81e04f5e97608081e2b2b0b99b194dd93624472bcb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b71eb107fe1599deb2365ce7827c0ffa7ff4dafbac2114e5625544688b36ceaf"
    sha256 cellar: :any_skip_relocation, sonoma:         "0882d1a3357dde26f7d1fda9c4aa15d594115b06ea94a178e9fabc9032131d2c"
    sha256 cellar: :any_skip_relocation, ventura:        "2eb75ff0c37d1d6a61c09273068ab66656bda9f64d5ad239b0a1b2f898c3f0b0"
    sha256 cellar: :any_skip_relocation, monterey:       "5979671e642438e0d4006a56b8a2bf792607af38b489edae255b0f12643d3250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bba67cf5174ef5e102b9fcbc44c32f86786efe6b6cc55fd5cfcc1d1ae802ff7"
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
