class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/e7/2e/aee8dfff93c7f5d20461ddcefd1da3d43bab18e1666a7777f4d9dbe94065/Cython-0.29.10.tar.gz"
  sha256 "26229570d6787ff3caa932fe9d802960f51a89239b990d275ae845405ce43857"

  bottle do
    cellar :any_skip_relocation
    sha256 "26e27b4d122984d0d0065b6d4c760a153c7344162536669cb7838d32a910e229" => :mojave
    sha256 "88785ae20e24ecf82ca48e2e7217d1370167c23eae2f20d8a0b3b2f602471ae5" => :high_sierra
    sha256 "bed127af8b8f2d01a59c58bdc51e828269eae1037cba35d9b005dd465d3ccf84" => :sierra
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
