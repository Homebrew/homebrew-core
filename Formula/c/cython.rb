class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/83/36/cce2972e13e83ffe58bc73bfd9d37340b5e5113e8243841a57511c7ae1c2/cython-3.2.1.tar.gz"
  sha256 "2be1e4d0cbdf7f4cd4d9b8284a034e1989b59fd060f6bd4d24bf3729394d2ed8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8ebe580190d2c509fd516dbaf1dbe90a6835e68b8a9df6815ab1e10affaad27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0481ddc041c18d1435822d58b3c444c67136f2f9aef4975a8691541a961bc759"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76638cc1b8134b8b6b41259573fee6f80e1527e91f70b85bad408e26d39ff36a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d46409b83c4305488175f7d9b35899d868a517eb3902a92bb195147caf8dfd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79dd2353e8214cf8e8db1fd1fa802ee34f09c0132584e24e50672b64d8e3f3ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a5450dc641c319e945b258917f6a03a2b641b0ec2ae3a1c8cbdf89c79d1d9c7"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python-setuptools" => [:build, :test]
  depends_on "python@3.14"

  def python3
    "python3.14"
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
    (testpath/"setup.py").write <<~PYTHON
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    PYTHON
    system python3, "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("#{python3} -c 'import package_manager'")
  end
end
