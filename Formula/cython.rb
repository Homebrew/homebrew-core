class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/59/e3/78c921adf4423fff68da327cc91b73a16c63f29752efe7beb6b88b6dd79d/Cython-0.29.24.tar.gz"
  sha256 "cdf04d07c3600860e8c2ebaad4e8f52ac3feb212453c1764a49ac08c827e8443"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a9a8847eb09048b42ddf462e7aa72de5d7d4db599f72a5e860d752ca020fe86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "980ed66e30d5adf3dd2102f3a536a09c935fa058f9fef8915a8c14f24d6757a3"
    sha256 cellar: :any_skip_relocation, monterey:       "3512a67f1c93c744682a6633b7a3af2e412541b21a8430b9537149da9bc27589"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ea67bcf72c2fb408a9bfdc74052f17793fe86d463dbb09b50074e8e3bc229aa"
    sha256 cellar: :any_skip_relocation, catalina:       "854687421737032cf7a531a2957f55537e74e3bb3ae2b778ffa73acf3703ce13"
    sha256 cellar: :any_skip_relocation, mojave:         "fd84920b5a706cf47bd9b927137b99f24549608fe3eb3cca4d50757e80589984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84aa64f585372c910dbac840f6164502a1fdb887f79b2f38e222672988c8585c"
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
