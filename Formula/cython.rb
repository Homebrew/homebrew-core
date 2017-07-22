class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "http://cython.org"
  url "https://files.pythonhosted.org/packages/10/d5/753d2cb5073a9f4329d1ffed1de30b0458821780af8fdd8ba1ad5adb6f62/Cython-0.26.tar.gz"
  sha256 "4c24e2c22ddaed624d35229dc5db25049e9e225c6f64f3364326836cad8f2c66"

  bottle do
    cellar :any_skip_relocation
    sha256 "e829747a85647ba52254d87b4af228da072d8629a0f32d3687e6cf8ebf31be54" => :sierra
    sha256 "027291cdf4756b3ef5d74cce90a044ccfcf7213f18f7821274958af41de09ed4" => :el_capitan
    sha256 "48cc08535a7b0dd2d3436885c2b9f8bb175aa519824045ee3372e62731d33084" => :yosemite
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
