class Pdfalyzer < Formula
  include Language::Python::Virtualenv

  desc "PDF analysis toolkit"
  homepage "https://github.com/michelcrypt4d4mus/pdfalyzer"
  url "https://files.pythonhosted.org/packages/6f/93/6efa6cc16febb047ffcabea8cb02dafb11ab3de6addc1cfe310e8d5cc20b/pdfalyzer-1.16.3.tar.gz"
  sha256 "d6603631ac55a74f0d6c9d9b4356cb0caf635324f85cd8c5d69a4bbf5ac42e42"
  license "GPL-3.0-or-later"
  head "https://github.com/michelcrypt4d4mus/pdfalyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "681fbdcaabd4976e428572aa61c8cb696c2fa77612108223434bd9d18e7eaa85"
    sha256 cellar: :any,                 arm64_sonoma:  "d94357aa58d032c894a701e1148076e9382240715820d863553e9329044e1520"
    sha256 cellar: :any,                 arm64_ventura: "a8765f1cd08a97096720ba081d137e703d785a67b0d4de04025fbd59c3adb398"
    sha256 cellar: :any,                 sonoma:        "992f2a837f5eacfcf2aa279ea315fe9e102348e5be2036a4038e06437c1715f4"
    sha256 cellar: :any,                 ventura:       "d1c670a4cea7bf532d92ed86e1c69bca2dd5a43140ff1028788e2d321225aab4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82daabce73119e0d631edb62fd55583d5d0de9751f0254203237f09bf45252f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6d6dc5663bddffef84c8f360aabb2db8a9cd0a1734f404a12d031deb14f1e8f"
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
    url "https://files.pythonhosted.org/packages/40/46/67de1d7a65412aa1c896e6b280829b70b57d203fadae6859b690006b8e0a/pypdf-5.6.0.tar.gz"
    sha256 "a4b6538b77fc796622000db7127e4e58039ec5e6afd292f8e9bf42e2e985a749"
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
