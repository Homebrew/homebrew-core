class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/dc/f6/e8e302f9942cbebede88b1a0c33d0be3a738c3ac37abae87254d58ffc51c/Cython-0.29.33.tar.gz"
  sha256 "5040764c4a4d2ce964a395da24f0d1ae58144995dab92c6b96f44c3f4d72286a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "785d54a5b55a33ad43c703809f7e0f47968fffe08716a7d21096e2d53d8e3908"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c280428e686d8e4369473a440bab37e484c91626a3233abdc70832ccde0e63de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67cc8a6c1a6c4d9a2ba884bf5f0922a4c33dffc988e80396dd0233ec1a34c15f"
    sha256 cellar: :any_skip_relocation, ventura:        "667e88115110c948f94ba7d0539257df6e3f074a63f5415a846055e62b1dabd8"
    sha256 cellar: :any_skip_relocation, monterey:       "2147cd1970cc25b4fa99fef1b1cf3fb86200425cedf4c5658f662ede4d38e142"
    sha256 cellar: :any_skip_relocation, big_sur:        "c63a8a477db07a7102ee23ce177ab2f8a3b754cfe48c94ce32454d3410e83a63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c77c90c884634aa8ef832a96da1007b81522063de39c14d8f177ef6ff786c9ec"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@3.11"

  def install
    python = "python3.11"
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python)
    system python, *Language::Python.setup_install_args(libexec, python)

    bin.install (libexec/"bin").children
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    python = Formula["python@3.11"].opt_bin/"python3.11"
    ENV.prepend_path "PYTHONPATH", libexec/Language::Python.site_packages(python)

    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~EOS
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    EOS
    system python, "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("#{python} -c 'import package_manager'")
  end
end
