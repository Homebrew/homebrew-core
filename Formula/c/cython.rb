class Cython < Formula
  include Language::Python::Virtualenv

  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/a9/d8/4981ef716ad0e3ff0d3ef383aefc6b03c4a88dee33b272bf8e0d833001ca/cython-3.3.0.tar.gz"
  sha256 "eed0d93fbca7087f143b42c34b05a825849bdf17f101572c2105acfa49aa88b8"
  license "Apache-2.0"
  head "https://github.com/cython/cython.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba606038a685137c36cf9844a77d39c17b974cee8f9e699584fcf28180cde6b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6694351a7f7b57d29b8fcb39bc567a6531ac42fe4f384fb03a234d8498ae4a45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "423af487eff0811cbf816765929615027d7441324ff4bfa796c97310c985ac2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0b558f07ca2ee0cbeafe32928965f2f14eefe12437745bcf843b2c25dc6094d"
    sha256 cellar: :any,                 arm64_linux:   "825f8e43a501144b527cd0b0524031668d10344e33dadf0047e5a5d5d76673ef"
    sha256 cellar: :any,                 x86_64_linux:  "30813a87f3a151bd3dc797dfcab7a69a3d7310a096c38e42aa771b7172b6e6fe"
  end

  depends_on "python@3.14"

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
