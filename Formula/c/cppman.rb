class Cppman < Formula
  include Language::Python::Virtualenv

  desc "C++ 98/11/14/17/20 manual pages from cplusplus.com and cppreference.com"
  homepage "https://github.com/aitjcize/cppman"
  url "https://files.pythonhosted.org/packages/55/32/beede58634c85d82b92139a64e514718e4af914461c5477d5779c4e9b6c4/cppman-0.5.6.tar.gz"
  sha256 "3cd1a6bcea268a496b4c4f4f8e43ca011c419270b24d881317903300a1d5e9e0"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e8318f7ad48430b865690662c367d9567eb59dff05aa52779f3ff302ade6c945"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8318f7ad48430b865690662c367d9567eb59dff05aa52779f3ff302ade6c945"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8318f7ad48430b865690662c367d9567eb59dff05aa52779f3ff302ade6c945"
    sha256 cellar: :any_skip_relocation, sonoma:         "e8318f7ad48430b865690662c367d9567eb59dff05aa52779f3ff302ade6c945"
    sha256 cellar: :any_skip_relocation, ventura:        "e8318f7ad48430b865690662c367d9567eb59dff05aa52779f3ff302ade6c945"
    sha256 cellar: :any_skip_relocation, monterey:       "e8318f7ad48430b865690662c367d9567eb59dff05aa52779f3ff302ade6c945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc6a4bba4cd38b9f4d56cdddd6ba802bd5a0b584d53bd48a46abcefa5f4e9d81"
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
