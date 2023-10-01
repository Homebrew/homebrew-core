class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/2f/81/c9fb4b69823f674e1e2acc484eac93a47a1e3a59d4d051c76259dadd6984/Cython-3.0.2.tar.gz"
  sha256 "9594818dca8bb22ae6580c5222da2bc5cc32334350bd2d294a00d8669bcc61b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a0d77ad64a7159146d5be50dacb10433a3813f65f2a2aa2b821e8166589d268"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a1f1ef80cef19a1258a94c534b7b342acab33180bbb82fc56fa7a9aefa651d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ff7f0e1b087291617aa011f08fc56d660f0c7d039aa7c335f7e126729302a13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81c913d15ab144c304e2b832a3e5474ae87934c36e062290bfc09c72374d56e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "c50b99d95febc3b97dd3db300e8ab582445eddd0fe44b7f1ed1c6d605a1a9840"
    sha256 cellar: :any_skip_relocation, ventura:        "758ca74b1247fe1ac11dc5c20374455839ce3cfe361100f4e7a17444a08b932d"
    sha256 cellar: :any_skip_relocation, monterey:       "3c0323d36db221f372f7b48372b8b5d661c8ab8034ae6ca473fadf13cfb14727"
    sha256 cellar: :any_skip_relocation, big_sur:        "02ec9a7a42fa27f6481e23a8eaa060c389b6bf7c5f0bacb98c95ef697c3be956"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bf229bc50117bf016755ca58d7de370a6d35c2b1593610687e3088d9494b981"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@3.11"

  def python3
    "python3.11"
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
