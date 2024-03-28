class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/0e/17/c5b026cea7a634ee3b8950a7be16aaa49deeb3b9824ba5e81c13ac26f3c4/Cython-3.0.9.tar.gz"
  sha256 "a2d354f059d1f055d34cfaa62c5b68bc78ac2ceab6407148d47fb508cf3ba4f3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11be1cb7c3864e7ff277eae101795f495c55890a1c086ce143ec56f5271d41a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e951f308796e0ae7790cdc9aca3203f3647750a5809e658a89897178b688d0f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff439fccb4f55f829764f7bf281888ce28f6e7c3c142d88293ac7b3981ce0911"
    sha256 cellar: :any_skip_relocation, sonoma:         "e78797ce1d585d36f0b884118f77d8fb2c15d11daefd758e1b1e13410b97c89e"
    sha256 cellar: :any_skip_relocation, ventura:        "3520ebf21e90dcbc74b80c504df141889aaa9ffc3e324345694b5caa66c58632"
    sha256 cellar: :any_skip_relocation, monterey:       "5ac8e66f0a982d6430565878bc3be0dbb9a96957a325a737aa64a2e297c0bfc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c189e9b63b6722448779b1ba667f44519a9d93dfa1594c3bee5634f15dd26e4"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python-setuptools" => [:build, :test]
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)
    system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."

    bin.install (libexec/"bin").children
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    ENV.prepend_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)

    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~EOS
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    EOS
    system python3, "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("#{python3} -c 'import package_manager'")
  end
end
