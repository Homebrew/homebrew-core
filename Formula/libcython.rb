class Libcython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/70/fa/f1c0a37b5d37378cd37eaa16341b65f98df13bc53042e0081a31bd63c929/Cython-0.29.29.tar.gz"
  sha256 "ce70dbbfbe374ee0d02fd16c26d5e512424fd0ab2927150a3f99d108bd0d8a20"
  license "Apache-2.0"

  livecheck do
    formula "cython"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5c850a15d384ed1229f2a226c1a9d23862680cf2ff024c3b08a62c03b0796e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff2966424699bee2213a31c5048bfe1b00b60e04334c47fe5d64ee8f85e770a7"
    sha256 cellar: :any_skip_relocation, monterey:       "434ed341dd977160cfb2c404603f05a25d52dbc349e5faa9097f517311bf1fe3"
    sha256 cellar: :any_skip_relocation, big_sur:        "bae3e8ad96d38036b4195a445eb81c3f3365e5648a343b1dff5a83c3d0d51d30"
    sha256 cellar: :any_skip_relocation, catalina:       "464625e441600155216b7d1b43d6a19956a940d61996d348dd7c6e01edd7a4ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8caa9a9089a4cb97e076ae81e0098b13b57dc6882421be1210fa44d67d9c0afb"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/python@\d\.\d+/) }
        .map(&:opt_bin)
        .map { |bin| bin/"python3" }
  end

  def install
    pythons.each do |python|
      ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python)
      system python, *Language::Python.setup_install_args(libexec),
             "--install-lib=#{libexec/Language::Python.site_packages(python)}"
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
