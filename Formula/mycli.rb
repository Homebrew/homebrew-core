class Mycli < Formula
  include Language::Python::Virtualenv

  desc "CLI for MySQL with auto-completion and syntax highlighting"
  homepage "http://mycli.net/"
  url "https://files.pythonhosted.org/packages/06/e4/748f932427af83fc9c7f3311e580476e9686c301630a3096b3e18f60a4d0/mycli-1.8.1.tar.gz"
  sha256 "5514ec779a211acb2d2776561b17f5bdb2583e333cc05e1b219865985faa799c"

  bottle do
    sha256 "05e2153e0cd10ac3de544196ac676aa25565d0cce08ff8a299f858c847ef6433" => :sierra
    sha256 "7e96245ecbbe76ee83e0f6f6fbb66cf785a2a3349be2a86c16b601f64655e028" => :el_capitan
    sha256 "ab332f9bc19a11e48049ca56a663fd2f1b60be2158d0fd559f3bb8f661e77bc8" => :yosemite
  end

  depends_on :python
  depends_on "openssl"

  resource "click" do
    url "https://files.pythonhosted.org/packages/7a/00/c14926d8232b36b08218067bcd5853caefb4737cda3f0a47437151344792/click-6.6.tar.gz"
    sha256 "cc6a19da8ebff6e7074f731447ef7e112bd23adf3de5c597cf9989f2fd8defe9"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/7f/72/845e3e5678ebe016fe2cff2ffaf91fc9615b9b1a630134f34cf394aa3927/prompt_toolkit-1.0.8.tar.gz"
    sha256 "b686ff216fc016dcbdf9ddf18d0ded480457213886ed4cda9fbc21002d18be54"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b8/67/ab177979be1c81bc99c8d0592ef22d547e70bb4c6815c383286ed5dec504/Pygments-2.1.3.tar.gz"
    sha256 "88e4c8a91b2af5962bfa5ea2447ec6dd357018e86e94c7d14bd8cacbc5b55d81"
  end

  resource "PyMySQL" do
    url "https://files.pythonhosted.org/packages/a4/c4/c15457f261fda9839637de044eca9b6da8f55503183fe887523801b85701/PyMySQL-0.7.9.tar.gz"
    sha256 "2331f82b7b85d407c8d9d7a8d7901a6abbeb420533e5d5d64ded5009b5c6dcc3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/c3/c4/6159720e7a100cd419bac31a202898e291e5af29e4ada09ee58f7eeaa076/sqlparse-0.2.1.tar.gz"
    sha256 "1c98a2bdffe67f1bb817b72a7ba4d38be592e0f07c5acea4adebcec12c4377d1"
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
