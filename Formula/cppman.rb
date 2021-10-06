class Cppman < Formula
  include Language::Python::Virtualenv

  desc "C++ 98/11/14/17/20 manual pages from cplusplus.com and cppreference.com"
  homepage "https://github.com/aitjcize/cppman"
  url "https://files.pythonhosted.org/packages/99/9e/c0c3f4d8a3b5e45533a11ec7882623a5f59195173fdd7124b913e62dda47/cppman-0.5.3.tar.gz"
  sha256 "27b8cee7e99055770d8251f969dcb9c4972342f92250e341bf9e10b9678a9140"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "55e96a488b28443bf7f8ab9752d4efaa4dc079fd85517aad50ded2d8d7dd487a"
    sha256 cellar: :any_skip_relocation, big_sur:       "3f09682974f0f72da904d90c58937d640fdb5a5d29514fefdf62ecff2b8ea8e3"
    sha256 cellar: :any_skip_relocation, catalina:      "dc2eaf5f58fe7ac82917f440b0bed4ac89d241103cda4f0c836d506acaa3be56"
    sha256 cellar: :any_skip_relocation, mojave:        "a3e6362771f2b46001d4c62e7574647dcf06c3af1af47d6e75ff90340987fc34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "344ebbdc2433c6c9b47fd8958307d985e6a047c6490a8aac5b44996e18ffd2bf"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/a1/69/daeee6d8f22c997e522cdbeb59641c4d31ab120aba0f2c799500f7456b7e/beautifulsoup4-4.10.0.tar.gz"
    sha256 "c23ad23c521d818955a4151a67d81580319d4bf548d3d49f4223ae041ff98891"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/c8/3f/e71d92e90771ac2d69986aa0e81cf0dfda6271e8483698f4847b861dd449/soupsieve-2.2.1.tar.gz"
    sha256 "052774848f448cf19c7e959adf5566904d525f33a3f8b6ba6f6f8f26ec7de0cc"
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
