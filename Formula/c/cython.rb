class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/3f/aa/1a5c72615e0ba4dc30cc36de7e8a9a2eca2158922b0677654fced0d3476c/Cython-3.0.4.tar.gz"
  sha256 "2e379b491ee985d31e5faaf050f79f4a8f59f482835906efe4477b33b4fbe9ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e284fd57356db76899efe15c864beab146f859f2f659f8e558e322c68a36eb3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b2fbc5fd17fd5b62dfac78e5990eaf51525d9ea7d745e4dda7b65ca493dd232"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f990c2d612aebbe2127032dac55a5ecf122752a1d901e7204d2bb089712c188"
    sha256 cellar: :any_skip_relocation, sonoma:         "3157002728d85f204a0bf4e7e7887327bf84e12e2911b510f0e6b90f64b4c556"
    sha256 cellar: :any_skip_relocation, ventura:        "eb8067be1d86aaa3e4cce0e8a5fb02072768a8735df4a1c46fa49b0c00bea747"
    sha256 cellar: :any_skip_relocation, monterey:       "2115105f71c3bbaaf4470b5054361271507bd1b2373ba8331a912672a5e30ee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c93208acf131b28bee18cad29d1d6f85364053dc950fe7812b1afb894b774815"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)
    system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."

    bin.install (libexec/"bin").children
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    ENV.prepend_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)

    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~EOS
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    EOS
    system python3, "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("#{python3} -c 'import package_manager'")
  end
end
