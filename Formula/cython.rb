class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/70/fa/f1c0a37b5d37378cd37eaa16341b65f98df13bc53042e0081a31bd63c929/Cython-0.29.29.tar.gz"
  sha256 "ce70dbbfbe374ee0d02fd16c26d5e512424fd0ab2927150a3f99d108bd0d8a20"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "099731b2cb64d18f20d345abfcf399c6323cab7e04905044bd6146a16b0666fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80131b19218032d50b7db33bb4b28219631ed401c7675e12dc80feba0397a2c5"
    sha256 cellar: :any_skip_relocation, monterey:       "11143d02ec38a888c57be195115fbdea4e166fa13fb2d7cdaf43d65aeddd3ef2"
    sha256 cellar: :any_skip_relocation, big_sur:        "75716727b7311c7b3507ad5b9255627438432774770f518de46b687a3b242553"
    sha256 cellar: :any_skip_relocation, catalina:       "b228b75c54a63705a5f4273a6970736988d6eb8ad7e28f1890be19660b301354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bb7fac70da34e144b248aa8874f153f0b7d862b781d7af76fa2cf221da01bdb"
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
