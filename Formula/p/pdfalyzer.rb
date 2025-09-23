class Pdfalyzer < Formula
  include Language::Python::Virtualenv

  desc "PDF analysis toolkit"
  homepage "https://github.com/michelcrypt4d4mus/pdfalyzer"
  url "https://files.pythonhosted.org/packages/04/e1/0c345c69a02bd4be18ae30c60d5f29861faedf833b9c51e55d91c457e9ab/pdfalyzer-1.16.14.tar.gz"
  sha256 "0abae20d4d01cc80a49a566732045a3b8e37cb2aa2ac46ef5286b4ce2f335f92"
  license "GPL-3.0-or-later"
  head "https://github.com/michelcrypt4d4mus/pdfalyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "db99d1b80f8217d4c085c6e87a6e4e2e33eca3700b376efcd91c61e40832bf45"
    sha256 cellar: :any,                 arm64_sequoia: "62dbacb5b7321209fc8d087c1f4878bfe2e9dbb1f81938d32f31768859567de8"
    sha256 cellar: :any,                 arm64_sonoma:  "5c28d22f07a063ec377aa21199edd22145e82cbb2bfabefd090f39287880b5b8"
    sha256 cellar: :any,                 arm64_ventura: "9ae04212bc7ac4d7295b155154c6f862a9a462003cad16ca8fc292353d098575"
    sha256 cellar: :any,                 sonoma:        "4f8202449ecd055d29d053586ebb8d73b1dd692a8d737ca5edadc93b37a93d98"
    sha256 cellar: :any,                 ventura:       "c8b561e7ae26258390e6f8d236536aabac506942b230fa546c628179a5175841"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d232520cadf5257919f1d77518cd753cb4973b93b6dc1dd3a91f6a22753d346a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4e70a5d4fdac464ab7484c3c1769ba90ee7cbb3a989013ef547010a35164dcf"
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
    url "https://files.pythonhosted.org/packages/20/ac/a300a03c3b34967c050677ccb16e7a4b65607ee5df9d51e8b6d713de4098/pypdf-6.0.0.tar.gz"
    sha256 "282a99d2cc94a84a3a3159f0d9358c0af53f85b4d28d76ea38b96e9e5ac2a08d"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f6/b0/4bc07ccd3572a2f9df7e6782f52b0c6c90dcbb803ac4a167702d7d0dfe1e/python_dotenv-1.1.1.tar.gz"
    sha256 "a8a6399716257f45be6a007360200409fce5cda2661e3dec71d23dc15f6189ab"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fe/75/af448d8e52bf1d8fa6a9d089ca6c07ff4453d86c65c145d0a300bb073b9b/rich-14.1.0.tar.gz"
    sha256 "e497a48b844b0320d45007cdebfeaeed8db2a4f4bcf49f15e455cfc4af11eaa8"
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
