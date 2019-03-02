class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/36/da/fcb979fc8cb486a67a013d6aefefbb95a3e19e67e49dff8a35e014046c5e/Cython-0.29.6.tar.gz"
  sha256 "6c5d33f1b5c864382fbce810a8fd9e015447869ae42e98e6301e977b8165e7ae"

  bottle do
    cellar :any_skip_relocation
    sha256 "36f1b06b106c26fe8b7abc6ee29666a9aa83914d3aa95f240dc631fe4dd5aca2" => :mojave
    sha256 "8a1f515a8d57a6ee95b08ec79a866b25d6a9b35cae2dfd7d29fc0eb56631cb87" => :high_sierra
    sha256 "37bdb759075fa4bbe073762019f7d1b18ab2137c69f1c98fc9fcf2a7a444dbc6" => :sierra
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    xy = Language::Python.major_minor_version "python3"
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
    system "python3", "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("python3 -c 'import package_manager'")
  end
end
