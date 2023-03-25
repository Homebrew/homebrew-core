class Cppman < Formula
  include Language::Python::Virtualenv

  desc "C++ 98/11/14/17/20 manual pages from cplusplus.com and cppreference.com"
  homepage "https://github.com/aitjcize/cppman"
  url "https://files.pythonhosted.org/packages/53/d7/e67138a6a1fa199dc1cda6f2c5bb72b2b1d2b0c834ba4a9a58f832c98edf/cppman-0.5.5.tar.gz"
  sha256 "8436c789b020cb6109b27efe881144588ead4ecc710778b39f0a0c42fc01b604"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eadffe3eb9e874c4566ae6d2287a56c69ed7a621a9704741715e74b86a356067"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82f7f4b824d5e413aec3cadf9550387ba2f48da53113fa555cb56f441908fd6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e7d3ae7b4f0649da958f7f4d720e1e8383585fe489cbfc3d9b8e0d89a7696e1"
    sha256 cellar: :any_skip_relocation, ventura:        "5e53ab51fc3f2d0ba208d9ddf58523126742fb3307f5bda41076142ddf9dc991"
    sha256 cellar: :any_skip_relocation, monterey:       "917c2a9ee1cb3f62206cce210adfecf7fa28ecf2c3ecb0eaf0da47e6e9f0d8f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "80edfe2438676e9420d686946e43bff7701cb62cf382ce6d9413a035a2633568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d52e38235852ee12348697e2ce9c18bb917abdf5223bc51b17148a24e446d8d6"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/c5/4c/b5b7d6e1d4406973fb7f4e5df81c6f07890fa82548ac3b945deed1df9d48/beautifulsoup4-4.12.0.tar.gz"
    sha256 "c5fceeaec29d09c84970e47c65f2f0efe57872f7cff494c9691a26ec0ff13234"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/1b/cb/34933ebdd6bf6a77daaa0bd04318d61591452eb90ecca4def947e3cb2165/soupsieve-2.4.tar.gz"
    sha256 "e28dba9ca6c7c00173e34e4ba57448f0688bb681b7c5e8bf4971daafc093d69a"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "std::extent", shell_output("#{bin}/cppman -f :extent")
  end
end
