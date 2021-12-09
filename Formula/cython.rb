class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/09/45/10c39337ba73c38a798165f97e4798827a532eaac71071842cbe0ee13dc5/Cython-0.29.25.tar.gz"
  sha256 "a87cbe3756e7c464acf3e9420d8741e62d3b2eace0846cb39f664ad378aab284"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6545af6073fbabd78b9500357983396d0befd7863afb94f6c181b8d670165e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81df73f17ee0651a1d8410d84f301877896141d2e2b2a41ce1954b6ca235783c"
    sha256 cellar: :any_skip_relocation, monterey:       "f41b8403e8b46e3d34960e9f4faefba7f291351c8d750abfdab47bafc2078d36"
    sha256 cellar: :any_skip_relocation, big_sur:        "944f12e06dd55adb53bb859f7f41ea3370c39b42d46199b460fdd16bcb1e046a"
    sha256 cellar: :any_skip_relocation, catalina:       "7d34d62aca3182ca450a39042ef663d522820b3ed5a321547ad3d80f4169b284"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff925f4adf00784257c326490a1f20830590e9d1647516337617ca0bac1faa92"
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
