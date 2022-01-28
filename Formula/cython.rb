class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/eb/46/80dd9e5ad67ebc766ff3229901bde4a7bc82907efe93cd7007c4df458dd5/Cython-0.29.27.tar.gz"
  sha256 "c6a442504db906dfc13a480e96850cced994ecdc076bcf492c43515b78f70da2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a18f2f10716310edcc6b06fb7d268875fc0fac70e011cdd12e67def8f1ff801f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aae25ac748da12a699f07a1d4b9b4ae9bf01dbe81129aec012024507d015f8ac"
    sha256 cellar: :any_skip_relocation, monterey:       "90717e6ce284a0db961b7c5c0708b058dc70fe78a46669d5697592f265ea92cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a8158098d2a41392113b7814d7350fe486654189c8157fcad0a856ee6eff7b9"
    sha256 cellar: :any_skip_relocation, catalina:       "66abd6f85ae50525f3e29973c0f370f066a70dab06225eb963de1c6185750683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb776a76cc465716bc8bf5995807a82cd0bef0988afd143ef3aa03f5aac1250a"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@3.9"

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
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
    system Formula["python@3.9"].opt_bin/"python3", "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("#{Formula["python@3.9"].opt_bin}/python3 -c 'import package_manager'")
  end
end
