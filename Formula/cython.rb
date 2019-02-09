class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/e0/31/4a166556f92c469d8291d4b03a187f325c773c330fffc1e798bf83d947f2/Cython-0.29.5.tar.gz"
  sha256 "9d5290d749099a8e446422adfb0aa2142c711284800fb1eb70f595101e32cbf1"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7494be3e94822d287bf3c66d066248d8f5d3c14d2594a402f4b6dbcc81f03b2" => :mojave
    sha256 "8715410ef3645a4e20323a9f1d324e69f7ca7d99596cb486660c1d1b9e717f54" => :high_sierra
    sha256 "8936e7896f71ed692041a82acf59b00c717d49f89c47d18ea684ba9677230bc1" => :sierra
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
