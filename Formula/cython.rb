class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "http://cython.org"
  url "https://files.pythonhosted.org/packages/d2/12/8ef44cede251b93322e8503fd6e1b25a0249fa498bebec191a5a06adbe51/Cython-0.28.4.tar.gz"
  sha256 "76ac2b08d3d956d77b574bb43cbf1d37bd58b9d50c04ba281303e695854ebc46"

  bottle do
    cellar :any_skip_relocation
    sha256 "8010fecf5f03fcbb5a684351e7541b5c8f9bde6739302d5f0ccdd119b02a2f2b" => :high_sierra
    sha256 "c93ea019dec5719621898455ebc8d0994aab6dd91f0b4b939585e269bb663c2a" => :sierra
    sha256 "5114c9e957d22c4b0ae5325edff8f62a5d012a955b016d18a62d98e0d59facba" => :el_capitan
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@2"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~EOS
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    EOS
    system "python", "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("python -c 'import package_manager'")
  end
end
