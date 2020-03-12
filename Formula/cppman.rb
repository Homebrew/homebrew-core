class Cppman < Formula
  include Language::Python::Virtualenv

  desc "C++ 98/11/14/17/20 manual pages from cplusplus.com and cppreference.com"
  homepage "https://github.com/aitjcize/cppman"
  url "https://files.pythonhosted.org/packages/53/9a/4908e1de68541c43961bea068c7062e91f8c8b656ea5fcf6ce0d7138a702/cppman-0.5.0.tar.gz"
  sha256 "0041943ca756c4736e5b1daca56f1e07f0953bbd438464ee3b8322c95a9f4cff"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "dbb2e70d0843395577a38d7f69ca8d1ad038bdd5f5660cfeb96ae85737d2bfd2" => :catalina
    sha256 "32ea0e98475d464c6ba0b7abd4471836e1f0a1ab54fba8e37008ac5593601387" => :mojave
    sha256 "5671d5634754c20e664efdd99f27f5a93adbbbd3e599fdb3a084b73ffc04c8a9" => :high_sierra
  end

  depends_on "python@3.8"

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/3e/edcf6fef41d89187df7e38e868b2dd2182677922b600e880baad7749c865/six-1.13.0.tar.gz"
    sha256 "30f610279e8b2578cab6db20741130331735c781b56053c59c4076da27f06b66"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/85/3e/cf449cf1b5004e87510b9368e7a5f1acd8831c2d6691edd3c62a0823f98f/html5lib-1.0.1.tar.gz"
    sha256 "66cb0dcfdbbc4f9c3ba1a63fdb511ffdbd4f513b2b6d81b80cd26ce6b3fb3736"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/86/cd/495c68f0536dcd25f016e006731ba7be72e072280305ec52590012c1e6f2/beautifulsoup4-4.8.1.tar.gz"
    sha256 "6135db2ba678168c07950f9a16c4031822c6f4aec75a65e0a97bc5ca09789931"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/7f/4e/95a13527e18b6f1a15c93f1c634b86d5fa634c5619dce695f4e0cd68182f/soupsieve-1.9.4.tar.gz"
    sha256 "605f89ad5fdbfefe30cdc293303665eff2d188865d4dbe4eb510bba1edfbfce3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "std::extent", shell_output("#{bin}/cppman -f :extent")
  end
end
