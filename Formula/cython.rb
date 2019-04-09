class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/36/da/fcb979fc8cb486a67a013d6aefefbb95a3e19e67e49dff8a35e014046c5e/Cython-0.29.6.tar.gz"
  sha256 "6c5d33f1b5c864382fbce810a8fd9e015447869ae42e98e6301e977b8165e7ae"

  bottle do
    cellar :any_skip_relocation
    sha256 "160bf3b99006737857f859995640f2e7a6034925866d2f3fb1d11384c2308a86" => :mojave
    sha256 "5dbb62c2f7110d8dc73792036326a6282242837a98cf6c1122f7ddd7ff937eca" => :high_sierra
    sha256 "28e1eb3bf054ce949d40076fa46e59642b2db629fe4091747f2bab4fdfa57005" => :sierra
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
