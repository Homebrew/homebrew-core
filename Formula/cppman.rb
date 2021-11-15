class Cppman < Formula
  include Language::Python::Virtualenv

  desc "C++ 98/11/14/17/20 manual pages from cplusplus.com and cppreference.com"
  homepage "https://github.com/aitjcize/cppman"
  url "https://files.pythonhosted.org/packages/99/9e/c0c3f4d8a3b5e45533a11ec7882623a5f59195173fdd7124b913e62dda47/cppman-0.5.3.tar.gz"
  sha256 "27b8cee7e99055770d8251f969dcb9c4972342f92250e341bf9e10b9678a9140"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0ca30d561477d9d2dc9f358ca8ee1667de84768086fa6a5915295c755e8c4f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7be03e0509903bce8c018175cffdf173e339456aa555cb91a86e5093feab947"
    sha256 cellar: :any_skip_relocation, monterey:       "6a88f88450153e891a470d20482131005fdf1c26d3eeb5da819b2ce7d351183b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8d9a3470010dac2167e6bf34e165a5ed30ade83fd3d435e0ec47ecea37c7391"
    sha256 cellar: :any_skip_relocation, catalina:       "2604a65f2ec97aa523f1efdb7723fd85009ba2b357891dcfb9a912737fdc1b9b"
    sha256 cellar: :any_skip_relocation, mojave:         "cb190a51ebdbf7c322627b64665c9384cb2f161a30158e5211aa700fead3b507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ee5f9cc3bca54588fa24dafc9379f81c0eeeeb59b3c46dc5587074450b7bf14"
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
