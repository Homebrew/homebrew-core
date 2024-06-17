class PassImport < Formula
  include Language::Python::Virtualenv

  desc "Pass extension for importing data from most existing password managers"
  homepage "https://github.com/roddhjav/pass-import"
  url "https://files.pythonhosted.org/packages/f1/69/1d763287f49eb2d43f14280a1af9f6c2aa54a306071a4723a9723a6fb613/pass-import-3.5.tar.gz"
  sha256 "e3e5ec38f58511904a82214f8a80780729dfe84628d7c5d6b1cedee20ff3fb23"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/roddhjav/pass-import.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7821ae62f9212c3ff475f9e7221c46c3862d7e2b8336cc874034fac67c1dc6e5"
    sha256 cellar: :any,                 arm64_ventura:  "e7e1c7cff3c4c7110ccdfe1733a166f59a2e003116745798775c81efea6e1ebe"
    sha256 cellar: :any,                 arm64_monterey: "789424c619b81a8118f4be51c669d2ae0a63409eb6ceaa41801c4953a120ef5d"
    sha256 cellar: :any,                 sonoma:         "eeb34517519248a131d666ac3cb7a9fd08520cd7567f2d48c808bff536a6657c"
    sha256 cellar: :any,                 ventura:        "8ce3ce1d40ba691b2e92a23dc03a4cc6da969f1bd0767108716e2d0ec4a7801a"
    sha256 cellar: :any,                 monterey:       "1bafc8fa4b45d53aa8335547fe053775c6b7ece8492178db1f41e12734ef3a04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7073d12e49b3b5edce260baecffd93dfc69d644bd36cb41ea6d7c4145aa5a5ea"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "pyaml" do
    url "https://files.pythonhosted.org/packages/a1/b4/41000b97447aba34a5054e90852e6b7ff5c0bc2a7e0306172176530c89e7/pyaml-24.4.0.tar.gz"
    sha256 "0e483d9289010e747a325dc43171bcc39d6562dd1dd4719e8cc7e7c96c99fce6"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/86/ec/535bf6f9bd280de6a4637526602a146a68fde757100ecf8c9333173392db/requests-2.32.2.tar.gz"
    sha256 "dd951ff5ecf3e3b3aa26b40703ba77495dab41da839ae72ef3c8e5d8e2433289"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "zxcvbn" do
    url "https://files.pythonhosted.org/packages/54/67/c6712608c99e7720598e769b8fb09ebd202119785adad0bbce25d330243c/zxcvbn-4.4.28.tar.gz"
    sha256 "151bd816817e645e9064c354b13544f85137ea3320ca3be1fb6873ea75ef7dc1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    importers = shell_output("#{bin}/pimport --list-importers")
    assert_match(/The \d+ supported password managers are:/, importers)

    exporters = shell_output("#{bin}/pimport --list-exporters")
    assert_match(/The \d+ supported exporter password managers are/, exporters)
  end
end
