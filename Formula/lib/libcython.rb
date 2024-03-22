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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac98b6388268ae84b8b336a42376b4b90a66456983f66abeb8506605f2e98a93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aff87e4c976f54b0894f9fdf1701ad73fb0cf3045d8bf3422f9b8e58cd6e7329"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01ce3264df5f89dfa4f3fb0b19bcb2d235987a5b13e7f0b13ed4b82e11bd478a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2472c81a98ea989469e7f5a7590ae3046ae30c95c83cbc549d682659e67f993"
    sha256 cellar: :any_skip_relocation, ventura:        "babd8cd308d6c871792d5ab8e86edde6d6730d3272e8fd6b50d27fedda270003"
    sha256 cellar: :any_skip_relocation, monterey:       "6544c9ff76704a23c43ba50eda96ad85a310a6ca5618351480b56f51f23ad7fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33ae89771207f97bc19b34a965bbb0fef90988b044375cde22da6de7ae367b72"
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
