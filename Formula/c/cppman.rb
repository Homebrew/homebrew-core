class Cppman < Formula
  include Language::Python::Virtualenv

  desc "C++ 98/11/14/17/20 manual pages from cplusplus.com and cppreference.com"
  homepage "https://github.com/aitjcize/cppman"
  url "https://files.pythonhosted.org/packages/55/32/beede58634c85d82b92139a64e514718e4af914461c5477d5779c4e9b6c4/cppman-0.5.6.tar.gz"
  sha256 "3cd1a6bcea268a496b4c4f4f8e43ca011c419270b24d881317903300a1d5e9e0"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a570e7970c982fa1e1c1ea6c222d7d8488785237f2ac36217e2ee2a4f5268c52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcdd4cef8369692f90a7891a5f55451b6cee56a5d67ff6bf1a3f1ea7b840640a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3be32eb590705a33067dc2c13953c7ba9d537e12a6da22c1073949d1386fafd2"
    sha256 cellar: :any_skip_relocation, sonoma:         "50bd9bf3a46a4ff11aa274d786633b863d2346773731243cfb97721a79321786"
    sha256 cellar: :any_skip_relocation, ventura:        "a5790e90df73eaffbce4c098be3f7c2ea567f2ff1720255b70c87dc8b16c73ca"
    sha256 cellar: :any_skip_relocation, monterey:       "7cf93e2ceb1cc87971b932a39cc5ac93133f5cd94c6e74605f61700388633a4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd1d8e0b3eb0e6cf71be41fd1b3de80029f5f7bc8737c91b59433fb378d574bd"
  end

  depends_on "python@3.12"
  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/b3/ca/824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58/beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
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
