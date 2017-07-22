class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "http://cython.org"
  url "https://files.pythonhosted.org/packages/10/d5/753d2cb5073a9f4329d1ffed1de30b0458821780af8fdd8ba1ad5adb6f62/Cython-0.26.tar.gz"
  sha256 "4c24e2c22ddaed624d35229dc5db25049e9e225c6f64f3364326836cad8f2c66"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d07c028127e8664c7205b3b03391a6d61715da0b0786392202e5637bf9e95e8" => :sierra
    sha256 "bdb424de2643b23a8f9e6082f69de09e3914140b99ec134dbd73665a3c6abc47" => :el_capitan
    sha256 "c464b7984210219436fd918b6441d569f6f17ce7a274be92d501af8c401237d1" => :yosemite
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
