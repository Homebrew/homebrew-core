class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "http://cython.org"
  url "https://files.pythonhosted.org/packages/98/bb/cd2be435e28ee1206151793a528028e3dc9a787fe525049efb73637f52bb/Cython-0.27.2.tar.gz"
  sha256 "265dacf64ed8c0819f4be9355c39beaa13dc2ad2f85237a2c4e478f5ce644b48"

  bottle do
    cellar :any_skip_relocation
    sha256 "53dc7306ccf0dbecf3bca5327297938ac58f3322460edd9ca669eeb4d2ab77b2" => :high_sierra
    sha256 "5a870d8f3ebf7a97af46d6edb974915746499eee9a10ec2a5a64e7df4979947c" => :sierra
    sha256 "4b1fcf174da9e6edb9e7930be4c2fa377ba3d1113295aaf3ef62e1c0d99886d6" => :el_capitan
  end

  keg_only <<~EOS
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
