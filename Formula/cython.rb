class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/0a/70/1500f05bddb16d795b29fac42954b3c8764c82367b8326c10f038471ae7f/Cython-0.29.34.tar.gz"
  sha256 "1909688f5d7b521a60c396d20bba9e47a1b2d2784bfb085401e1e1e7d29a29a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4fddfd2b25586444dae292a5cbc6bcd4b72a6ccb1f18b60cb20115b70208dbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b7f42331063fd5d9aad2576fc0e8d95113bcabdbae6420d973354f124f59ed0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "965737e5c16da30a30b4fd6e45659837abe8cd5cfcbe8b60952122107e60cca8"
    sha256 cellar: :any_skip_relocation, ventura:        "e0ea9c25e353ca0e77328ee6ea55181a56d68d36756af9b3eb64615d1c4e7317"
    sha256 cellar: :any_skip_relocation, monterey:       "b3fb014f7c876b8b94ffb9202f2fc5cf1a27203df756f51e3f01bd6cf0c8daf7"
    sha256 cellar: :any_skip_relocation, big_sur:        "22520e442bec0235027f90d86293eaa1b61f008193dcd797a790c8a7ef03cd1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9494d941474b6887cb2b2243bae876bb8ea6fb61cc33c2163140ae78d1aa8e91"
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
