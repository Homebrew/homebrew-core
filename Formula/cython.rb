class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/da/a0/298340fb8412574a0b00a0d9856aa27e7038da429b9e31d6825173d1e6bd/Cython-0.29.35.tar.gz"
  sha256 "6e381fa0bf08b3c26ec2f616b19ae852c06f5750f4290118bf986b6f85c8c527"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37b4ea62f9a6d0e9337b592a322fec14b0ff228ed89513d249d99eec1e48f4ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76efd54188e1d835fe2c62baff9e8c7878d45da4974ee489b03227cf5f262b69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06081134d7c61cb2706017123981c9430a89467252b12d914baa7679d0dcc03c"
    sha256 cellar: :any_skip_relocation, ventura:        "3b59472867ebc95dd6d735fd5a548b55dfbd8b1352e3ade7fa8a34db24195c17"
    sha256 cellar: :any_skip_relocation, monterey:       "a11067c60207b489ed68de46458b15b0f20ca6ce44f86d2e579f5b8f0c43be16"
    sha256 cellar: :any_skip_relocation, big_sur:        "038f6755795313524bbdef3251175124245e1b7c518725e5ea31897228ed2b98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ead75b632fb7cd0d37ab55d0c32862d7f8eb3af37a038bb9147bdb8b293b0ba2"
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
