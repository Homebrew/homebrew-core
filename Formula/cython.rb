class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/d3/38/adc49a5aca4f644e6322237089fdcf194084f5fe41445e6e632f28b32bf7/Cython-0.29.22.tar.gz"
  sha256 "df6b83c7a6d1d967ea89a2903e4a931377634a297459652e4551734c48195406"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "25de8b45d7c75bfb7f64b29eb1b477ec428a8fddba29b23a20e6374c56f3baa3"
    sha256 cellar: :any_skip_relocation, big_sur:       "a6eaff0adba4768eb2e8fa91b4e8a8dbf15925c229660ed4785a449a477213fb"
    sha256 cellar: :any_skip_relocation, catalina:      "359be6b86db3786a71d316eed3d4a6610aace16695674668e3e7780944bc891b"
    sha256 cellar: :any_skip_relocation, mojave:        "ec40d5e6d90a6ded90c194397909fd96ad1a2fe0650d457c117f662f11ee60ac"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@3.9"

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~EOS
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    EOS
    system Formula["python@3.9"].opt_bin/"python3", "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("#{Formula["python@3.9"].opt_bin}/python3 -c 'import package_manager'")
  end
end
