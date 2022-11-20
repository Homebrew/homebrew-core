class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/4c/76/1e41fbb365ad20b6efab2e61b0f4751518444c953b390f9b2d36cf97eea0/Cython-0.29.32.tar.gz"
  sha256 "8733cf4758b79304f2a4e39ebfac5e92341bce47bcceb26c1254398b2f8c1af7"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0bacf71713fc06516224737da332607e62570dd9b09db621e2bcbbc3f9f1fd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf2d6933b68b87cfa36a047f49774f59e8f0193a2f53fd4284d2e81b8c6e13f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb954cb6e538d5619560ff5598f58dfff45071599be7593bc9477ea96e606dac"
    sha256 cellar: :any_skip_relocation, ventura:        "9616a0d104d024823eaca33d7e6ec9f52724f6e86c11a3703949fbf80095cfe4"
    sha256 cellar: :any_skip_relocation, monterey:       "37c7b39c9ea3300d07dbf86e96d6365f2fd305ebd953ed87e6231606960a4c65"
    sha256 cellar: :any_skip_relocation, big_sur:        "48374cefbe3fed92a24b60688956302ea807ae2d7b0346d280198920e5381dcf"
    sha256 cellar: :any_skip_relocation, catalina:       "b02e83dbf1ccd76667e5e16626473646cdfeee9bbd37676093284d3035ed366b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0277874feeaa8f509bb7ee2d6c6ff0e6183983c6186095581ad19e6f25d03a1"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@3.11"

  def install
    python = "python3.11"
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python)
    system python, *Language::Python.setup_install_args(libexec, python)

    bin.install (libexec/"bin").children
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    python = Formula["python@3.11"].opt_bin/"python3.11"
    ENV.prepend_path "PYTHONPATH", libexec/Language::Python.site_packages(python)

    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~EOS
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    EOS
    system python, "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("#{python} -c 'import package_manager'")
  end
end
