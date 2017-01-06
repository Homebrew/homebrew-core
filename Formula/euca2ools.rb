class Euca2ools < Formula
  include Language::Python::Virtualenv

  desc "Eucalyptus client API tools-works with Amazon EC2 and IAM"
  homepage "https://github.com/eucalyptus/euca2ools"
  url "https://downloads.eucalyptus.com/software/euca2ools/3.3/source/euca2ools-3.3.2.tar.xz"
  sha256 "16825975ac1af7baceb8e0fc872ebefe867c22bf9b64e70dffd8d64309b203b7"
  head "https://github.com/eucalyptus/euca2ools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d8ed6ae8ea4524a3d2c2143b00b6d1d580e5f9aa1f3031aa0363a55805354cb" => :sierra
    sha256 "abd969d35cd0a0693a5c3f73a294e55eb58f5e0a6bdb47020baef16ba92ebb5a" => :el_capitan
    sha256 "43f6e9f3d4a278a9a15f9c7d37c61e4b34441a401b073464f38683f8263329d7" => :yosemite
    sha256 "8812367d62d4732a09e01865693751bba1c971db979106bf2c0db4e69027ea47" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "requestbuilder" do
    url "https://files.pythonhosted.org/packages/ac/b5/8b1c6c102760785ce22a08f32fb6fc8c745445ed8f1f9195d2517c79511c/requestbuilder-0.7.1.tar.gz"
    sha256 "84ed99ab55e6a549686af32328b2b15a1f5416800ee23b65346edd7a84706089"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5b/0b/34be574b1ec997247796e5d516f3a6b6509c4e064f2885a96ed885ce7579/requests-2.12.4.tar.gz"
    sha256 "ed98431a0631e309bb4b63c81d561c1654822cb103de1ac7b47e45c26be7ae34"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/c4/68/cf0ab7e26de58d14d441f19f7f9c2ab15eb109b0b2640f8b19c1da34e9e0/lxml-3.7.1.tar.gz"
    sha256 "1c7f6771838300787cfa1bb3ed6512e9dc78e60ecb308a8ed49ac956569c1cca"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/euca-version"
    system "#{bin}/euca-describe-instances", "--help"
  end
end
