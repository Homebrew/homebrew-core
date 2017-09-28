class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "http://cython.org"
  url "https://files.pythonhosted.org/packages/94/63/f54920c2ddbe3e1341a4c268f7091bf1bf53c3d84f4b115aa5beea64aef9/Cython-0.27.tar.gz"
  sha256 "b932b5194e87a8b853d493dc1b46e38632d6846a86f55b8346eb9c6ec3bdc00b"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c686cee7b44c203626c5cc45aee3e4294a57fe40f7d3159ed4e4dbb88e9d811" => :high_sierra
    sha256 "86473587bb530454989fb9c6b6a4425a18355110721abc5fe76c50ffdef1c316" => :sierra
    sha256 "5bb8db8c4bd88e55916ffc82e847acd89ae432afb60e6a6cb97eac9f3515f50a" => :el_capitan
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
