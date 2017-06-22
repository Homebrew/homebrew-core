class IpythonAT5 < Formula
  include Language::Python::Virtualenv

  desc "Interactive computing in Python"
  homepage "https://ipython.org/"
  url "https://files.pythonhosted.org/packages/21/86/58d06db0c82af66c2d47faead027c3ce775cfbf9bc9d2f13f85d95f0a162/ipython-5.4.1.tar.gz"
  sha256 "afaa92343c20cf4296728161521d84f606d8817f963beaf7198e63dfede897fb"
  head "https://github.com/ipython/ipython.git", :branch => "5.x"

  bottle do
    cellar :any_skip_relocation
    sha256 "2acce5ad0cdf5e9de01e685aa91b40d9cdc9bd2295fafd6e011ccbc424d6591b" => :sierra
    sha256 "23f82ddbe0fc67badbf7f255fdbd46cfec4297e371edc44b2b60f8e68a7a4f12" => :el_capitan
    sha256 "a65a771f84259592ad67d43097aa22e7a7b614b3d3b8dc79800efe9eb06b52f0" => :yosemite
  end

  keg_only :versioned_formula

  depends_on :python

  resource "appnope" do
    url "https://files.pythonhosted.org/packages/26/34/0f3a5efac31f27fabce64645f8c609de9d925fe2915304d1a40f544cff0e/appnope-0.1.0.tar.gz"
    sha256 "8b995ffe925347a2138d7ac0fe77155e4311a0ea6d6da4f5128fe4b3cbe5ed71"
  end

  resource "backports.shutil_get_terminal_size" do
    url "https://files.pythonhosted.org/packages/ec/9c/368086faa9c016efce5da3e0e13ba392c9db79e3ab740b763fe28620b18b/backports.shutil_get_terminal_size-1.0.0.tar.gz"
    sha256 "713e7a8228ae80341c70586d1cc0a8caa5207346927e23d09dcbcaf18eadec80"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/cc/ac/5a16f1fc0506ff72fcc8fd4e858e3a1c231f224ab79bb7c4c9b2094cc570/decorator-4.0.11.tar.gz"
    sha256 "953d6bf082b100f43229cf547f4f97f97e970f5ad645ee7601d55ff87afdfe76"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "ipython_genutils" do
    url "https://files.pythonhosted.org/packages/e8/69/fbeffffc05236398ebfcfb512b6d2511c622871dca1746361006da310399/ipython_genutils-0.2.0.tar.gz"
    sha256 "eb2e116e75ecef9d4d228fdc66af54269afa26ab4463042e33785b887c628ba8"
  end

  resource "pathlib2" do
    url "https://files.pythonhosted.org/packages/ab/d8/ac7489d50146f29d0a14f65545698f4545d8a6b739b24b05859942048b56/pathlib2-2.2.1.tar.gz"
    sha256 "ce9007df617ef6b7bd8a31cd2089ed0c1fed1f7c23cf2bf1ba140b3dd563175d"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e8/13/d0b0599099d6cd23663043a2a0bb7c61e58c6ba359b2656e6fb000ef5b98/pexpect-4.2.1.tar.gz"
    sha256 "3d132465a75b57aa818341c6521392a06cc660feb3988d7f1074f39bd23c9a92"
  end

  resource "pickleshare" do
    url "https://files.pythonhosted.org/packages/69/fe/dd137d84daa0fd13a709e448138e310d9ea93070620c9db5454e234af525/pickleshare-0.7.4.tar.gz"
    sha256 "84a9257227dfdd6fe1b4be1319096c20eb85ff1e82c7932f36efccfe1b09737b"
  end

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/55/56/8c39509b614bda53e638b7500f12577d663ac1b868aef53426fc6a26c3f5/prompt_toolkit-1.0.14.tar.gz"
    sha256 "cc66413b1b4b17021675d9f2d15d57e640b06ddfd99bb724c73484126d22622f"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/db/d7/b465161910f3d1cef593c5e002bff67e0384898f597f1a7fdc8db4c02bf6/ptyprocess-0.5.1.tar.gz"
    sha256 "0530ce63a9295bfae7bd06edc02b6aa935619f486f0f1dc0972f516265ee81a6"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  resource "scandir" do
    url "https://files.pythonhosted.org/packages/bd/f4/3143e0289faf0883228017dbc6387a66d0b468df646645e29e1eb89ea10e/scandir-1.5.tar.gz"
    sha256 "c2612d1a487d80fb4701b4a91ca1b8f8a695b1ae820570815e85e8c8b23f1283"
  end

  resource "simplegeneric" do
    url "https://files.pythonhosted.org/packages/3d/57/4d9c9e3ae9a255cd4e1106bb57e24056d3d0709fc01b2e3e345898e49d5b/simplegeneric-0.8.1.zip"
    sha256 "dc972e06094b9af5b855b3df4a646395e43d1c9d0d39ed345b7393560d0b9173"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/a5/98/7f5ef2fe9e9e071813aaf9cb91d1a732e0a68b6c44a32b38cb8e14c3f069/traitlets-4.3.2.tar.gz"
    sha256 "9c4bd2d267b7153df9152698efb1050a5d84982d3384a37b2c1f7723ba3e7835"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz"
    sha256 "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "4", shell_output("#{bin}/ipython -c 'print 2+2'").chomp
  end
end
