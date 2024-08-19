class PassImport < Formula
  include Language::Python::Virtualenv

  desc "Pass extension for importing data from most existing password managers"
  homepage "https://github.com/roddhjav/pass-import"
  url "https://files.pythonhosted.org/packages/f1/69/1d763287f49eb2d43f14280a1af9f6c2aa54a306071a4723a9723a6fb613/pass-import-3.5.tar.gz"
  sha256 "e3e5ec38f58511904a82214f8a80780729dfe84628d7c5d6b1cedee20ff3fb23"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/roddhjav/pass-import.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0d69b84ce9e662596c3e5dd4b2835c4d77d9d26d40a6cbe8323b8be0f110bce4"
    sha256 cellar: :any,                 arm64_ventura:  "45ceaf511092c243e8f589975704dd48c750f2e40e803f427805d9d8c1b7485b"
    sha256 cellar: :any,                 arm64_monterey: "b76b1a55b0e873930845fa0669f2626cf2a31dc42ec4f8e09e8bb7cf0b8f5d5e"
    sha256 cellar: :any,                 sonoma:         "8571e378fec7cd4bb6a0a6f0239a3e1bf8a9b962a5eb345b3b24d7486a2231c2"
    sha256 cellar: :any,                 ventura:        "1f55d62391d55b3b20c620df0c74de09d757f7c111e187b9ef4b0f6c1eff5789"
    sha256 cellar: :any,                 monterey:       "17012c55f43c32ede37e6fd6bf0aa5ba698b7399bdbfff040613e86f596e9426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fee5a088814e42cd56808b08055a18a16cef380541af6d66e956bb5e3ce7524"
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
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
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
