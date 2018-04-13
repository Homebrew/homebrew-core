class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "http://cython.org"
  url "https://files.pythonhosted.org/packages/79/9d/dea8c5181cdb77d32e20a44dd5346b0e4bac23c4858f2f66ad64bbcf4de8/Cython-0.28.2.tar.gz"
  sha256 "634e2f10fc8d026c633cffacb45cd8f4582149fa68e1428124e762dbc566e68a"

  bottle do
    cellar :any_skip_relocation
    sha256 "54f912c944fd4aa1aaeeb64ec9ee35d4bfc1f9a939df945688a2ef0a004548d2" => :high_sierra
    sha256 "14d48f493d1a420671323b7eac2291ae45443beb523e78adca1e7aea99e6e7a0" => :sierra
    sha256 "2276b9218aabeb91d9d7d383db52c7efb245c1a63a6089fcf5abaf1d2c663c8c" => :el_capitan
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@2"

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
