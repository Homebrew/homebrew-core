class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/5a/25/886e197c97a4b8e254173002cdc141441e878ff29aaa7d9ba560cd6e4866/cython-3.0.12.tar.gz"
  sha256 "b988bb297ce76c671e28c97d017b95411010f7c77fa6623dd0bb47eed1aee1bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61f7e6769e2e430f1fc8bfdd8160844c97ddc148586e52125a644265855a4c6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7dab5895e7452dd67ca3be898e59adfe908c0d3187323441ebc1228c7dd9f21"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9a43ca2229987dc45aecf953209472b3ec76d5bd8e155b139680019e7dc7bce"
    sha256 cellar: :any_skip_relocation, sonoma:        "aeaa52ed2d4fc58b91577811eed2e022e6b24da4d4cd8372d862c834c1d5f887"
    sha256 cellar: :any_skip_relocation, ventura:       "1a9c68f744399dd4ae2685056120c84a3a7c6e2c82ada4917635484f4ed8bde5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c741c3b0f335532211ab4746082a1c50e766f558eb9af037747e3bad342f9039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d62655bdfcaacdaa6776745dc1f9eb03afc1d704eb981907e4d519f33ead631f"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python-setuptools" => [:build, :test]
  depends_on "python@3.13"

  def python3
    "python3.13"
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
    (testpath/"setup.py").write <<~PYTHON
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    PYTHON
    system python3, "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("#{python3} -c 'import package_manager'")
  end
end
