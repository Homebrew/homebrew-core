class Cppman < Formula
  include Language::Python::Virtualenv

  desc "C++ 98/11/14/17/20 manual pages from cplusplus.com and cppreference.com"
  homepage "https://github.com/aitjcize/cppman"
  url "https://files.pythonhosted.org/packages/f7/c1/0ee5b360b7e5941fac6b3e4749e0f02c45154b1747f097ca925e8f605ea2/cppman-0.5.7.tar.gz"
  sha256 "008729416e754dd2f4b59df83496cb36c8174605f5ed02813c7d28c36c560f1a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d56f3be4d16ea7bb421e12b887350feef3605fbd7d00fdada9cfe0746177fae0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d56f3be4d16ea7bb421e12b887350feef3605fbd7d00fdada9cfe0746177fae0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b50609ac2b38f553aa5a1a1220207518b553fa183fb4e834e15dc498af82dea"
    sha256 cellar: :any_skip_relocation, sonoma:         "d56f3be4d16ea7bb421e12b887350feef3605fbd7d00fdada9cfe0746177fae0"
    sha256 cellar: :any_skip_relocation, ventura:        "d56f3be4d16ea7bb421e12b887350feef3605fbd7d00fdada9cfe0746177fae0"
    sha256 cellar: :any_skip_relocation, monterey:       "9b50609ac2b38f553aa5a1a1220207518b553fa183fb4e834e15dc498af82dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d02fccc87385689cb5b22ff7a6e9810456d3eff92b70758ac66cfaf3c1de6e8"
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
