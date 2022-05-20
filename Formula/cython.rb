class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/70/fa/f1c0a37b5d37378cd37eaa16341b65f98df13bc53042e0081a31bd63c929/Cython-0.29.29.tar.gz"
  sha256 "ce70dbbfbe374ee0d02fd16c26d5e512424fd0ab2927150a3f99d108bd0d8a20"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9cfb8a70313b532be6f6f48ab21e871ef965127ac6e085b0bb9a0cc25a779ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ffd455466d6a78aa0f95dadd4b4018efccd10902804c46709db97fb6f0ba7a8"
    sha256 cellar: :any_skip_relocation, monterey:       "155eeb235101e6ba198cd9f1ae9ea8d884bc530da209fa5fb1dab06e8aeccff8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3ffdd9fbce63403b893f0c93b4dc02195f2b9fbbb00cb5b437d0d4e83d19696"
    sha256 cellar: :any_skip_relocation, catalina:       "d337755389c7d4b73779b53bdd327574a6459123e70ffb4e6fde180f85aab0b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a828c8d37590349241fde08ed7e3a881f47f7432a175550c1769c1f8f80eecc6"
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
