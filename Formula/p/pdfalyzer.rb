class Pdfalyzer < Formula
  include Language::Python::Virtualenv

  desc "PDF analysis toolkit"
  homepage "https://github.com/michelcrypt4d4mus/pdfalyzer"
  url "https://files.pythonhosted.org/packages/5c/76/42c17b19399e723ddfa954d5780478113e942f728cb3ae673d9b2c9a7b19/pdfalyzer-1.17.9.tar.gz"
  sha256 "54876e775890c333473749102d0a331685247ac11251e542fe39528c1bebdf8d"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/michelcrypt4d4mus/pdfalyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9131653c7f4b1e493539d68415516955a4c97e83409a945aa47dc02445a2a894"
    sha256 cellar: :any,                 arm64_sequoia: "91049fa3d687f0d038f6bd599cb611ef53bd50054566b8d87ecc8ad87673aacd"
    sha256 cellar: :any,                 arm64_sonoma:  "e372bad2ac5e75edec13ac245750d732e7c2c8eca76f4b3f78b1b1703c0ec06d"
    sha256 cellar: :any,                 sonoma:        "d2f8402f938d939950a86d9102dc0995898a313ad0b3c22b3c629404def6bb54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bcdf319962a5e9471d1d8a232fae6a3a3f5782e417fc9fce2400d9af21d1340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8e30f6219639c38120c622f1fdb6b2b81afc859574ab935a182bf6b24538480"
  end

  depends_on "openssl@3"
  depends_on "pillow"
  depends_on "python@3.14"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/bc/a8/eb55fab589c56f9b6be2b3fd6997aa04bb6f3da93b01154ce6fc8e799db2/anytree-2.13.0.tar.gz"
    sha256 "c9d3aa6825fdd06af7ebb05b4ef291d2db63e62bb1f9b7d9b71354be9d362714"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/f3/01/f7510cc6124f494cfbec2e8d3c2e1a20d4f6c18622b0c03a3a70e968bacb/pypdf-6.4.0.tar.gz"
    sha256 "4769d471f8ddc3341193ecc5d6560fa44cf8cd0abfabf21af4e195cc0c224072"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f0/26/19cadc79a718c5edbec86fd4919a6b6d3f681039a2f6d66d14be94e75fb9/python_dotenv-1.2.1.tar.gz"
    sha256 "42667e897e16ab0d66954af0e60a9caa94f0fd4ecf3aaf6d2d260eec1aa36ad6"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
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
    url "https://files.pythonhosted.org/packages/f0/0c/37c23b6071370b8fce6776b8dd440badb7a95d248cd40441d1c382033fe9/yaralyzer-1.0.9.tar.gz"
    sha256 "8f37e0ad243d3db47afaefbe30093ee8ea9b168f58e771e7c765dc48614d49ad"
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
