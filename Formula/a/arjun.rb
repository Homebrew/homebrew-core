class Arjun < Formula
  include Language::Python::Virtualenv

  desc "HTTP parameter discovery suite"
  homepage "https://github.com/s0md3v/Arjun"
  url "https://files.pythonhosted.org/packages/bb/97/ed0189286d98aaf92322a06e23b10fc6c298e0ee9a43cd69ab614a1f76cf/arjun-2.2.6.tar.gz"
  sha256 "15dbc0abf5efcbbe4ba1892ad8edb08fa5efc41bb2ebaadd0be01e47e70240fc"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ec6c342abc1ea5a18fa26ea279ee9e528ff30f61cbaa992857a6aa21d76cab0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "433d23aa5367c870f5378933a122178789e9e5bc2832d4c325d9b40bef104302"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5969ba73df47a54973fa1e71e6636c26381815f4cce3b3c8358ef8958aa4798f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c07c0b1fb274088c67629dd6da08e3b97c613b4ec7cbabda8559031b8b7f8227"
    sha256 cellar: :any_skip_relocation, ventura:        "224e4106d9547c3accea95442fcb7ae24365cfaded72f2747c39e873a4f3c3a0"
    sha256 cellar: :any_skip_relocation, monterey:       "68409cd452e52d67a5a4878205f722a40b42d90600afde0525f81304367daaa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9b0e87edf2d2c628a58bf1d8d6cdb181ac074cdf4affd22a17a3d3204ad2fcf"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "dicttoxml" do
    url "https://files.pythonhosted.org/packages/ee/c9/3132427f9e64d572688e6a1cbe3d542d1a03f676b81fb600f3d1fd7d2ec5/dicttoxml-1.7.16.tar.gz"
    sha256 "6f36ce644881db5cd8940bee9b7cb3f3f6b7b327ba8a67d83d3e2caa0538bf9d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "ratelimit" do
    url "https://files.pythonhosted.org/packages/ab/38/ff60c8fc9e002d50d48822cc5095deb8ebbc5f91a6b8fdd9731c87a147c9/ratelimit-2.2.1.tar.gz"
    sha256 "af8a9b64b821529aca09ebaf6d8d279100d766f19e90b5059ac6a718ca6dee42"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/d8/c1/f32fb7c02e7620928ef14756ff4840cae3b8ef1d62f7e596bc5413300a16/requests-2.32.1.tar.gz"
    sha256 "eb97e87e64c79e64e5b8ac75cee9dd1f97f49e289b083ee6be96268930725685"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    dbfile = libexec/Language::Python.site_packages(python3)/"arjun/db/small.txt"
    output = shell_output("#{bin}/arjun -u https://mockbin.org/ -m GET -w #{dbfile}")
    assert_match "No parameters were discovered", output
  end
end
