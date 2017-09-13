class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "http://cython.org"
  url "https://files.pythonhosted.org/packages/68/41/2f259b62306268d9cf0d6434b4e83a2fb1785b34cfce27fdeeca3adffd0e/Cython-0.26.1.tar.gz"
  sha256 "c2e63c4794161135adafa8aa4a855d6068073f421c83ffacc39369497a189dd5"

  bottle do
    cellar :any_skip_relocation
    sha256 "638b92c666264c3cd545829105c367fec7880715f4c77c299cf3689329157b35" => :sierra
    sha256 "8ea087e6c76859af0a50b46de26093e00ed8ec9bb20fe15066be4aaa42ec0582" => :el_capitan
    sha256 "1522c512cfa00fd1bbb1695c568a7d407f6b87ff105efe341a116e4d94033865" => :yosemite
  end

  keg_only <<-EOS.undent
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on :python if MacOS.version <= :snow_leopard

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
    (testpath/"setup.py").write <<-EOS.undent
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
