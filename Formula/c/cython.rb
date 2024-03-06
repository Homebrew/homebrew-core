class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/0e/17/c5b026cea7a634ee3b8950a7be16aaa49deeb3b9824ba5e81c13ac26f3c4/Cython-3.0.9.tar.gz"
  sha256 "a2d354f059d1f055d34cfaa62c5b68bc78ac2ceab6407148d47fb508cf3ba4f3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25008e22b534538114e9472ae7e7ccdc12322a1baa3ad230ef747100541577b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cad308ba5a06856696420b130ca9f7059d466c7daffb75d73f81cca1461e4924"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a741f0a93219636a3e2eea4115cf247d1d0b4931c1f57e7892a824153e290559"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fac6970a43a10f65bf737e46978f4ad920f81944014fe39d1a8b240ada9b042"
    sha256 cellar: :any_skip_relocation, ventura:        "1e8cc18c2be4a07fc68325f644ea78767233b30243ca73716adec44c1269e077"
    sha256 cellar: :any_skip_relocation, monterey:       "e2dbe49a0e3e8d4db24c8ec04182706d0c84615001b15f5d9a5dc958ab16f674"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b95b4defb4ae282beafe47eeadf1aa16531ad99d90ca9e7be7d80f30684c2aa"
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
