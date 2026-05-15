class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/91/85/7574c9cd44b69a27210444b6650f6477f56c75fee1b70d7672d3e4166167/cython-3.2.4.tar.gz"
  sha256 "84226ecd313b233da27dc2eb3601b4f222b8209c3a7216d8733b031da1dc64e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2275bff675c022e817525d3506587e8493146285c2c903e2cc52bcf14c963c0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b5a3f554069a98e3651123e5d1614e3ab0db62e0a7707338c11ccf7bdc6a59f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b20515999f8665929b6ee05b9132c688f53965720b91dec161eb2d18bff6818"
    sha256 cellar: :any_skip_relocation, sonoma:        "96d84017528cb1850a627c5d0e3665bd39572542808e9c0053cb5eb3d5509e35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df8630249fef1eebb4d86fedf72037eeba54fbe0c44190f07aad274dcc27a925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16afa410ecef6646080b4b82f376f5f00aabc41d342c59bc4317fa5120785d29"
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
