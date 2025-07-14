class Pdfalyzer < Formula
  include Language::Python::Virtualenv

  desc "PDF analysis toolkit"
  homepage "https://github.com/michelcrypt4d4mus/pdfalyzer"
  url "https://files.pythonhosted.org/packages/83/c4/1f72b314bbe964e3569ebf66bb84c508e20eaba8204b1df30608d69dd836/pdfalyzer-1.16.6.tar.gz"
  sha256 "2e07d0772c66448ec664167cd54c41cd3339ba459c24d84df833e49163c0f7c3"
  license "GPL-3.0-or-later"
  head "https://github.com/michelcrypt4d4mus/pdfalyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0bfca5f39e0290151395be5248498c4e90b98e5953d3abcee509eafb739c6cd2"
    sha256 cellar: :any,                 arm64_sonoma:  "78a66a0020255256d33a7598e3e76e6ee346a928d5be7f1564908e42d6478fd0"
    sha256 cellar: :any,                 arm64_ventura: "78525bbaed8d0b82a5e92dff94f32ac28bbc59622c5ba3693309f5b9b923935f"
    sha256 cellar: :any,                 sonoma:        "2ff2e4b78d0468497c1bdeb15890c5c65b42d5af54e880492fa617c9d4cffb24"
    sha256 cellar: :any,                 ventura:       "157e79e118cb9d4d4c9a207a2ac5b5dbae2b8cbbbef20799f2a4e841cde1ce64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a00ff132e64c7be14e44b66a479ce0732481fd89c42828f83a7c756c783b99d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2217a872cc68cc94d50444dd8522a7b8e4b2c5039237c7ccfc876b7f5caeb4a"
  end

  depends_on "openssl@3"
  depends_on "python@3.13"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/bc/a8/eb55fab589c56f9b6be2b3fd6997aa04bb6f3da93b01154ce6fc8e799db2/anytree-2.13.0.tar.gz"
    sha256 "c9d3aa6825fdd06af7ebb05b4ef291d2db63e62bb1f9b7d9b71354be9d362714"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/7b/42/fbc37af367b20fa6c53da81b1780025f6046a0fac8cbf0663a17e743b033/pypdf-5.7.0.tar.gz"
    sha256 "68c92f2e1aae878bab1150e74447f31ab3848b1c0a6f8becae9f0b1904460b6f"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f5/d7/d548e0d5a68b328a8d69af833a861be415a17cb15ce3d8f0cd850073d2e1/python-dotenv-0.21.1.tar.gz"
    sha256 "1c93de8f636cde3ce377292818d0e440b6e45a82f215c3744979151fa8151c49"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/11/23/814edf09ec6470d52022b9e95c23c1bef77f0bc451761e1504ebd09606d3/rich-12.6.0.tar.gz"
    sha256 "ba3a3775974105c221d31141f2c116f4fd65c5ceb0698657a11e9f295ec93fd0"
  end

  resource "rich-argparse-plus" do
    url "https://files.pythonhosted.org/packages/9b/34/75eaf9752783aa93498d46ccbc7046e25cc1d44e5f6c43d829d90b9dcd02/rich_argparse_plus-0.3.1.4.tar.gz"
    sha256 "aab9e49b4ba98ff501705678330eda8e9bc07d933edc5cac5f38671ee53f9998"
  end

  resource "yara-python" do
    url "https://files.pythonhosted.org/packages/51/38/347d1fcde4edabd338d5872ca5759ccfb95ff1cf5207dafded981fd08c4f/yara_python-4.5.4.tar.gz"
    sha256 "4c682170f3d5cb3a73aa1bd0dc9ab1c0957437b937b7a83ff6d7ffd366415b9c"
  end

  resource "yaralyzer" do
    url "https://files.pythonhosted.org/packages/a2/78/9f3c2619e0974731a491a972ddc157f61fc240bdf7074594cbdc0d82a858/yaralyzer-0.9.6.tar.gz"
    sha256 "e234af284e8edafbb923fe1b37ea9e00d1ee6b455d5486f135743e6ec0c962b4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdfalyze --version")

    resource "homebrew-test-pdf" do
      url "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"
      sha256 "3df79d34abbca99308e79cb94461c1893582604d68329a41fd4bec1885e6adb4"
    end

    resource("homebrew-test-pdf").stage testpath

    output = shell_output("#{bin}/pdfalyze dummy.pdf")
    assert_match "'/Producer': 'OpenOffice.org 2.1'", output
  end
end
