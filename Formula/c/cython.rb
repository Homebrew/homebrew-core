class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/1a/1d/c79482ecb7217fc5840eceb724f7ebb4d3a70c5bf46309add0c0cd299891/Cython-3.0.3.tar.gz"
  sha256 "327309301b01f729f173a94511cb2280c87ba03c89ed428e88f913f778245030"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a103f465c7979ee645249cc06c0d5ee5a6f6fc3ae5bfd0b9a3df8eb5d3fbb52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9410c08a4f42362df073f428f43ed811be6a55f5b86eb84613e1c4af80335e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8536e9baa11726200dc89c2644b136d2d3e02abce51be68a810be0347a640b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "4770d77c2c307e8f2b86bd48cbbc94a38d90f068c27662c14d609b1a3476c95b"
    sha256 cellar: :any_skip_relocation, ventura:        "700bc0530a7207dca2c7bad0241381cc3de2d207a935ad9f58df47bd7eb6d54b"
    sha256 cellar: :any_skip_relocation, monterey:       "32eb852b0a3a632ac828003c994be4cf0d628b9a0c46bbb2bc701ea88ab7057a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef7198c6104733a8006a12672d6556cf7b2803ed525c54ef72706619d0584f03"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@3.11"

  def python3
    "python3.11"
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
