class Cython < Formula
  include Language::Python::Virtualenv

  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/98/de/dff7f5fcfd06a947b16bbd66568e3e8f291cd9a17c35fd04b43b5a7ad3bf/cython-3.3.2.tar.gz"
  sha256 "e789d9fd939b74fb8c572fc2b689e3b14bd141ba95243693a546064c8179a1d3"
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
