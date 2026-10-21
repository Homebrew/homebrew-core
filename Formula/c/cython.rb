class Cython < Formula
  include Language::Python::Virtualenv

  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/a9/d8/4981ef716ad0e3ff0d3ef383aefc6b03c4a88dee33b272bf8e0d833001ca/cython-3.3.0.tar.gz"
  sha256 "eed0d93fbca7087f143b42c34b05a825849bdf17f101572c2105acfa49aa88b8"
  license "Apache-2.0"
  head "https://github.com/cython/cython.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "37f19a469bf74bda0c572e2e2e7be3814ffe92c5aad593f0cf26b64e43e5d187"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2a208c5730f3da08c8c95aa77842e59abb8a92f7f2c0c5e11744d3ddabd26385"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9a949b85b17f37f0b082e40464e798b136b5ce62f3dcc44ed780eb65a58dc7f9"
    sha256 cellar: :any,                 arm64_linux:       "4ef15461753572eebc88566433af830d52ff75649fed50403916c20397c008f4"
    sha256 cellar: :any,                 x86_64_linux:      "f19c58b1803794a428b237f7193dfdb594afa08f570aa3cb0177016d6dcd585e"
  end

  depends_on "python@3.15"

  # https://github.com/cython/cython/issues/5976
  pypi_packages extra_packages: "setuptools"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
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
