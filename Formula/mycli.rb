class Mycli < Formula
  include Language::Python::Virtualenv

  desc "CLI for MySQL with auto-completion and syntax highlighting"
  homepage "http://mycli.net/"
  url "https://files.pythonhosted.org/packages/d3/ba/13b9ca22e77fbe6770c39c6fae912ec2fe95bbbbcc7b1ed287851f04c438/mycli-1.10.0.tar.gz"
  sha256 "e3ff390c66dcd9ea15235ea36ee7ad26630197c21d95e78926df54f41ad1fcc7"

  bottle do
    sha256 "59ac7a804b0b85d1aa8085c55b73cfada367da1cec1d8d3a9c1363e405a4acc5" => :sierra
    sha256 "471856d3be8da3828ec24261dd303ced33d81b012dcc5476fa66847e5ef2bc09" => :el_capitan
    sha256 "ad3c4c954a39248e757e22cafa038fd6cce8d9fe38a8c85916bf531c37a0e445" => :yosemite
  end

  depends_on :python
  depends_on "openssl"

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/55/56/8c39509b614bda53e638b7500f12577d663ac1b868aef53426fc6a26c3f5/prompt_toolkit-1.0.14.tar.gz"
    sha256 "cc66413b1b4b17021675d9f2d15d57e640b06ddfd99bb724c73484126d22622f"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/45/ca/f0c2ca6c65084d60f68553cf072de7db0d918c7bb07ece88781f6af24625/pycryptodome-3.4.5.tar.gz"
    sha256 "be84544eadc2bb71d4ace39e4984ed2990111f053f24267a07afb4b4e1e5428f"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  resource "PyMySQL" do
    url "https://files.pythonhosted.org/packages/29/f8/919a28976bf0557b7819fd6935bfd839118aff913407ca58346e14fa6c86/PyMySQL-0.7.11.tar.gz"
    sha256 "56e3f5bcef6501012233620b54f6a7b8a34edc5751e85e4e3da9a0d808df5f68"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/45/67/14bdaeff492e6d03a055fe80502bae10b679891c25a0dc59be2fe51002f8/sqlparse-0.2.3.tar.gz"
    sha256 "becd7cc7cebbdf311de8ceedfcf2bd2403297024418801947f8c953025beeff8"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz"
    sha256 "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mycli", "--help"
  end
end
