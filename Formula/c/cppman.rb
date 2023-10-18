class Cppman < Formula
  include Language::Python::Virtualenv

  desc "C++ 98/11/14/17/20 manual pages from cplusplus.com and cppreference.com"
  homepage "https://github.com/aitjcize/cppman"
  url "https://files.pythonhosted.org/packages/55/32/beede58634c85d82b92139a64e514718e4af914461c5477d5779c4e9b6c4/cppman-0.5.6.tar.gz"
  sha256 "3cd1a6bcea268a496b4c4f4f8e43ca011c419270b24d881317903300a1d5e9e0"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f20011fee92a9fd80601c856055bc9a0bc6385165b178a6cde649770068fcdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32cb44dfb79316b097b53e5bef365b8ad9afd4de8174737c029aa6c4cf202b7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "051cc71e6f033a19ed973811b47cde9366b1d15782b906e7c1b8cd66c56258ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "7420f850300e0afe2e6540b5e57061fdb7c06f7b509d6e256d7ec2fac9b08bc6"
    sha256 cellar: :any_skip_relocation, ventura:        "14406183f5eafb7f3e45e28615c9e2229d47a78b00f43e1fdd3291196c054382"
    sha256 cellar: :any_skip_relocation, monterey:       "1cfa005eedac90624fb96db9a7d61df6fce66aebcdf7d0e3749e825d16c2ecf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab08285118872e0476506fa77e160f52bf7001550a1cffc1c8011f9229f68c4c"
  end

  depends_on "python@3.12"
  depends_on "six"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
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
