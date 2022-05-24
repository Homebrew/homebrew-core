class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/d4/ad/7ce0cccd68824ac9623daf4e973c587aa7e2d23418cd028f8860c80651f5/Cython-0.29.30.tar.gz"
  sha256 "2235b62da8fe6fa8b99422c8e583f2fb95e143867d337b5c75e4b9a1a865f9e3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad2353f7568b31bab773f08e7e646536c4ef612278930cc11e93f7207a651a05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2b83be02a2e8ee6496d5d1777cd25e3b15f18927f306bc74d764a8f76f3d63b"
    sha256 cellar: :any_skip_relocation, monterey:       "34348ae1c6d6cbdc7f57c6ffa7a685578f7aeff72e6f5fa3ef58e54082ba23b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2519bb90de816aa04123d24c25f17732d713fbf2fbd159ea115867c6b760540"
    sha256 cellar: :any_skip_relocation, catalina:       "69e7af1f7199459d73ddfd3f06480120283a5561d3eb4a55a8474abc516a680c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c55a2638c5cd13008db21a9663d92ec5d352cfa09bd87409835925a561230229"
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
