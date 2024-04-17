class Goolabs < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for morphologically analyzing Japanese language"
  homepage "https://pypi.python.org/pypi/goolabs"
  url "https://files.pythonhosted.org/packages/ce/86/2d3b5bd85311ee3a7ae7a661b3619095431503cd0cae03048c646b700cad/goolabs-0.4.0.tar.gz"
  sha256 "4f768a5b98960c507f5ba4e1ca14d45e3139388669148a2750d415c312281527"
  license "MIT"
  revision 9

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00c37a4b0d07a6352c9bf356e8f900a5743529062fec7a4a0f76325ac2465d94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00c37a4b0d07a6352c9bf356e8f900a5743529062fec7a4a0f76325ac2465d94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00c37a4b0d07a6352c9bf356e8f900a5743529062fec7a4a0f76325ac2465d94"
    sha256 cellar: :any_skip_relocation, sonoma:         "00c37a4b0d07a6352c9bf356e8f900a5743529062fec7a4a0f76325ac2465d94"
    sha256 cellar: :any_skip_relocation, ventura:        "00c37a4b0d07a6352c9bf356e8f900a5743529062fec7a4a0f76325ac2465d94"
    sha256 cellar: :any_skip_relocation, monterey:       "00c37a4b0d07a6352c9bf356e8f900a5743529062fec7a4a0f76325ac2465d94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44c5d7f6729928cd91dc3b82ca6aa8811b7a9f517b15781a9d9b16e2085e7877"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Usage: goolabs morph", shell_output("#{bin}/goolabs morph test 2>&1", 2)
  end
end
