class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/eb/46/80dd9e5ad67ebc766ff3229901bde4a7bc82907efe93cd7007c4df458dd5/Cython-0.29.27.tar.gz"
  sha256 "c6a442504db906dfc13a480e96850cced994ecdc076bcf492c43515b78f70da2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a6ff3640e54f2992e6e6e784be73ff7995021e1ad079d7fd1ef9294cbae7ffa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87960da8cdf4f9970782c68ac1b7873cae95e9000f9674451f3c6bb60e265e78"
    sha256 cellar: :any_skip_relocation, monterey:       "e09b91ecdb96c5a685d1acb95ef35e10ccc12058d24b72e90da4d728b6bb0266"
    sha256 cellar: :any_skip_relocation, big_sur:        "88e280167ed30df0ee60adf71bd9546a4ffd12636bc6b38db80caeec381c3119"
    sha256 cellar: :any_skip_relocation, catalina:       "08f8c42e0d5ce2143788320f7ce6c3aaee16652fac553503d20c06befe1573cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e9ab748b78e718b018c245264d5b38559443ca10617d2110a59a2958a9ca1d3"
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
