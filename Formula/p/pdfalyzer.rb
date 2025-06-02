class Pdfalyzer < Formula
  include Language::Python::Virtualenv

  desc "PDF analysis toolkit"
  homepage "https://github.com/michelcrypt4d4mus/pdfalyzer"
  url "https://files.pythonhosted.org/packages/1f/e4/3310a02630e6f6a3309fb724e94c31c67f63c467bc42c4ad00bdc7e35d46/pdfalyzer-1.16.2.tar.gz"
  sha256 "3dc9f1e4b6b542dca44e9e5dee887ddbef2f697b2393383791b6cfdf65994afc"
  license "GPL-3.0-or-later"
  head "https://github.com/michelcrypt4d4mus/pdfalyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "495b99c25533d988489121de8684db726b9745a2fefc94e33ef5443a0c8e8349"
    sha256 cellar: :any,                 arm64_sonoma:  "0bff2364cdca473977532fb2fa9d2f4df0f7de072974289f700f559d979cab8a"
    sha256 cellar: :any,                 arm64_ventura: "c21de38e8749af76b07927f39841ff08070ffb69b9c8c97367d8b3862cd2fef8"
    sha256 cellar: :any,                 sonoma:        "a3d36da767e2ac75bb97875c611d8ce6cb30a94dd9a21f8544886daef17eca78"
    sha256 cellar: :any,                 ventura:       "4144083c26d065d68863f7cec6cc9df686cdda4159e5c17ad192fb2588b0a95b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5132a7ed4c428843c1f30233f3197f1e9dd1178cfa0e62f176f062ef70da33d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea0b75f1b5d97e7cfa50dda9069142c161e97e4fcdb667a0af6ce92eada5ae34"
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
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/e0/c8/543f8ae1cd9e182e9f979d9ab1df18e3445350471abadbdabc0166ae5741/pypdf-5.5.0.tar.gz"
    sha256 "8ce6a18389f7394fd09a1d4b7a34b097b11c19088a23cfd09e5008f85893e254"
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
    url "https://files.pythonhosted.org/packages/f0/12/73703b53de2d3aa1ead055d793035739031793c32c6b20aa2f252d4eb946/yara_python-4.5.2.tar.gz"
    sha256 "9086a53c810c58740a5129f14d126b39b7ef61af00d91580c2efb654e2f742ce"
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
