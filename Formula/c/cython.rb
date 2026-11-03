class Cython < Formula
  include Language::Python::Virtualenv

  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/99/ca/18e324972e5cac914816fdd7bb03e19a455b90039c277a538f7781b50c85/cython-3.3.1.tar.gz"
  sha256 "e0e45989e821bef6aa9ae15c7d583ab5e055f7406c4b3624e49e06d24e90375a"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/cython/cython.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ec376b088188fab2a3541ee936c37e7ad603f75e6c6aba1ef961524e1fa7b10c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "347e0180b57746a528c6fa89905c88eaa4949541abf35df4a4c151a595634ec6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fffe7ff3859e2d5a29e389f89ecff6cad4b689a48d230db78bcfa1866af3a5d1"
    sha256 cellar: :any,                 arm64_linux:       "a5b16ec3ed6c70e73bb6b75d3b70b4c4f16d8afb20762c7a39874d26baf8d392"
    sha256 cellar: :any,                 x86_64_linux:      "a48a6b25bf63e74f9b14657570c5c39cf2dee58375988805fcd1e2d51405c8bc"
  end

  depends_on "python@3.15"

  # https://github.com/cython/cython/issues/5976
  pypi_packages extra_packages: "setuptools"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    phrase = "You are using Homebrew"
    (testpath/"example.pyx").write "print '#{phrase}'"

    system bin/"cythonize", "--inplace", "example.pyx"
    assert_match phrase, shell_output("#{libexec}/bin/python -c 'import example'")
  end
end
