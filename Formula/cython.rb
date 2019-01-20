class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/02/24/f73045afb049295b34ac55aaf6ea1592604cda3749632a22e563e66604a3/Cython-0.29.3.tar.gz"
  sha256 "d687fb1cd9df28c1515666174c62e54bd894a6a6d0862f89705063cd47739f83"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3923063e47ef8b9f3e495f8898b082a80c58034d713df24acca2ff7f25cf91d" => :mojave
    sha256 "648f84c8d3226e1da1c5bed6d95d9de62c25a3a752f3be20e36366179faa6114" => :high_sierra
    sha256 "69fc5ad0d96f5661e43eff9537ad4af18ed9bfaf805e6e61f805c574ead273ae" => :sierra
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
