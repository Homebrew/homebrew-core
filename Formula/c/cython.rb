class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/3f/3b/ebd94c8b85f8e41b5015a9ed94ee3df866024d480d05cd08b774684fb81d/cython-3.2.5.tar.gz"
  sha256 "3dd42e4cf36ad15f265bdfec2337cc00c688c8eb6d374ffd13bb19437c27bba1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "469dbf2babd705ab27e6c19d70d964fd8da381d8907fe4926114e74b5c816bd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a867ce8de6086ddf0b6fe1697c307375b12c9cbdea47162ef39eed38bf1dadd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34c2ac76543b7fdb635df9f7146a3566df3d84f93cac65bd41aaba00858b6b50"
    sha256 cellar: :any_skip_relocation, sonoma:        "4af7ddae3310a6a1f90c4d042362fa4f661028c8f955a7410c1b151a4aad38a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9d533348123264e28abc46b76a7752dd12cc725eece683380a726c46193369b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "491ad02804857d4ce19f629f2776eb09b49dc261c01133fdfcbfed08e21a0bf2"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python-setuptools" => [:build, :test]
  depends_on "python@3.14"

  def python3
    "python3.14"
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
