class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "http://cython.org"
  url "https://files.pythonhosted.org/packages/be/08/bb5ffd1c32a951cbc26011ecb8557e59dc7a0a4975f0ad98b2cd7446f7dd/Cython-0.28.1.tar.gz"
  sha256 "152ee5f345012ca3bb7cc71da2d3736ee20f52cd8476e4d49e5e25c5a4102b12"

  bottle do
    cellar :any_skip_relocation
    sha256 "50a5f8928e750f0f51572265550b680b75def6b2bff16847c3fee4fe968ee1f0" => :high_sierra
    sha256 "e0e1da2e224c839e0fa93fee56e92261b4fc33c286a7c6b9decbc09d5995e5c3" => :sierra
    sha256 "68500af222ef5dc5f50686731cc31360ab11e4a3c2467e51d88b1075ffe35b38" => :el_capitan
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@2" if MacOS.version <= :snow_leopard

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
