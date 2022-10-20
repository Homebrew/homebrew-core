class Libcython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/4c/76/1e41fbb365ad20b6efab2e61b0f4751518444c953b390f9b2d36cf97eea0/Cython-0.29.32.tar.gz"
  sha256 "8733cf4758b79304f2a4e39ebfac5e92341bce47bcceb26c1254398b2f8c1af7"
  license "Apache-2.0"

  livecheck do
    formula "cython"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03da2421a3ee299de5c0faa2830aa98025e235a8992a3ee2a8705387b4c63de2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78b4e2d714c1b787bd695dab44825f0115ed0f1982b946185c8c6ac9893c455e"
    sha256 cellar: :any_skip_relocation, monterey:       "1ec609eb60279d5200fbdc69034ab2511450395fd19d729e0bed5ed154df0516"
    sha256 cellar: :any_skip_relocation, big_sur:        "c01a590c2e9bf5d3d486c75a041d0c7d7f44b1cf7e3a4a8ae4f30eb7f5438be0"
    sha256 cellar: :any_skip_relocation, catalina:       "0e6e09e0c66544ebd68a7144ffd894c9587bbbbc09a963317f50090da5fc37de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87756c4a74bf13790e32c17aea4626e808d2fe214602761d4f7d8e9e2073e18d"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python)
      system python, *Language::Python.setup_install_args(libexec, python)
    end
  end

  test do
    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~EOS
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    EOS
    pythons.each do |python|
      ENV.prepend_path "PYTHONPATH", libexec/Language::Python.site_packages(python)
      system python, "setup.py", "build_ext", "--inplace"
      assert_match phrase, shell_output("#{python} -c 'import package_manager'")
    end
  end
end
