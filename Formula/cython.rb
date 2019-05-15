class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/f8/da/c979464858b257b21a6472a85285548c91f5b4dc773cb049cfdfb3ceeb02/Cython-0.29.7.tar.gz"
  sha256 "55d081162191b7c11c7bfcb7c68e913827dfd5de6ecdbab1b99dab190586c1e8"

  bottle do
    cellar :any_skip_relocation
    sha256 "9fe95cb70735055c92745b1fbd7fc510ef63bd2c7beb352051480ea4dfabb575" => :mojave
    sha256 "efd423f95e2123fbe7b00284efe21e6c03787cd6f5283e771e84980893318763" => :high_sierra
    sha256 "f07c3c3b7c2cd82fdf0ce0823a5d4d8c8df4e1ae257722af2240e38f4d78f6a7" => :sierra
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
