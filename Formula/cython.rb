class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/4c/76/1e41fbb365ad20b6efab2e61b0f4751518444c953b390f9b2d36cf97eea0/Cython-0.29.32.tar.gz"
  sha256 "8733cf4758b79304f2a4e39ebfac5e92341bce47bcceb26c1254398b2f8c1af7"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84388303d0cd534c4e590d43b4132c74940ad2a6028b1466ee314c2e6092525b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90a105b02c7ed397bc5d4bc7401c7f36461ffc57b8a17e54d1a23329bd59b91d"
    sha256 cellar: :any_skip_relocation, monterey:       "42ba4f89d67ffce14a9d3c03a78b476e736f9e35353fd7edf9a478dc8529334d"
    sha256 cellar: :any_skip_relocation, big_sur:        "27b42b7a895a16502507a7d59c73f0db6c297f00afb60b364b965e44feaf51ef"
    sha256 cellar: :any_skip_relocation, catalina:       "9e73b22f2f15811d094d8fb589900998b9a30e8fd4096d6e1b1fac24ac4f5bad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c053536274e62c840cd3076f821512190f50ede667d1bf19c06e2d4842bdf565"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@3.10"

  def install
    python = "python3.10"
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python)
    system python, *Language::Python.setup_install_args(libexec, python)

    bin.install (libexec/"bin").children
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    python = Formula["python@3.10"].opt_bin/"python3.10"
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
