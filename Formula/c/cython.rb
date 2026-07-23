class Cython < Formula
  include Language::Python::Virtualenv

  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/b6/6b/80101e02ebacaf9232ecf32bf6a788d36b27d820ee02434746252569ef98/cython-3.2.8.tar.gz"
  sha256 "f4f23a56b25221a06f91817fe8f3114ab8b48a4fac73187dbb64bc2c4a87961f"
  license "Apache-2.0"
  head "https://github.com/cython/cython.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dee3caa30fd60b55f5e48e5980e34d504a819282445c13618c77a5ac12e4074f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cecf57851f1a107f05be70108eaaae75d35e6975225a50ece15825f3d3afa90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f96e8610eaf2b33349af4d0e6cd4b0e00b833f646fd0b64c3cc04152303526d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4c903f7a5f57346add8b09bab97ceb1a4becc0e14bd30010cdabc0b4dc1839d"
    sha256 cellar: :any,                 arm64_linux:   "162d1860c8f19d1b0f05b43988aaf9a4ee48cafab1a883d3c9d93c3dd9e1eedb"
    sha256 cellar: :any,                 x86_64_linux:  "0a2bf44dfb82d24457b02eaafa2f8aa4e4bfaff818c0aae24f87342095cb0311"
  end

  depends_on "python@3.14"

  # https://github.com/cython/cython/issues/5976
  pypi_packages extra_packages: "setuptools"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/34/26/f5d29e25ffdb535afef2d35cdb55b325298f96debd670da4c325e08d70f4/setuptools-83.0.0.tar.gz"
    sha256 "025bccbbf0fa05b6192bc64ae1e7b16e001fd6d6d4d5de03c97b1c1ade523bef"
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
