class Pdfalyzer < Formula
  include Language::Python::Virtualenv

  desc "PDF analysis toolkit"
  homepage "https://github.com/michelcrypt4d4mus/pdfalyzer"
  url "https://files.pythonhosted.org/packages/69/e4/39183a9674a5eb292143d9a3dd1c4fa9541fffcf567f5295efefd5be86db/pdfalyzer-1.19.6.tar.gz"
  sha256 "888df3252f73fe28132a017824bc60f7a686c6a05800f3b026f76f48ee655dd3"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/michelcrypt4d4mus/pdfalyzer.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "79718d8e764001c00f91d2f196fc288b9346c125c52e559258345de413c10ae9"
    sha256 cellar: :any, arm64_tahoe:       "686eb6fc2113a400a608bcf00d280e99b96a2211ead4ece7b185168a20f15917"
    sha256 cellar: :any, arm64_sequoia:     "0bb5b9132d348824abe0d2b38880698d5e7df4ff733fb99e8dc16a0367ae4ca4"
    sha256 cellar: :any, arm64_linux:       "53d89f9de7d41e05cc1bb2579047d943a6b533e9113bd14c6b9b94944ab96d8a"
    sha256 cellar: :any, x86_64_linux:      "6adf9a3a5b63a339decd7e4f2f44a91d332b45d952675cd5b21f4e952e879edc"
  end

  depends_on "pillow"
  depends_on "python@3.15"
  depends_on "yara"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/bc/a8/eb55fab589c56f9b6be2b3fd6997aa04bb6f3da93b01154ce6fc8e799db2/anytree-2.13.0.tar.gz"
    sha256 "c9d3aa6825fdd06af7ebb05b4ef291d2db63e62bb1f9b7d9b71354be9d362714"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/d8/f4/801632a8b62a805378b6af2b5a3fcbfd8923abf647e0ed1af846a83433b2/pypdf-6.6.0.tar.gz"
    sha256 "4c887ef2ea38d86faded61141995a3c7d068c9d6ae8477be7ae5de8a8e16592f"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/74/26/2fbeedb218a787a5eea551c7532cac4e009f83d689dd2faa0d0353473f86/python_dotenv-1.2.4.tar.gz"
    sha256 "f0d53e69935a851c0dcc78f3ab7aaccd8cabef0b92382b576b824212902873c0"
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
    url "https://files.pythonhosted.org/packages/be/9a/2751156fa98de5ea0aeff92006273d384110e5696030e04080862412f3b8/yaralyzer-1.3.17.tar.gz"
    sha256 "d33fc7a6361ca780bd019602bfee5f0834dd3b1a65f169981e4ffbbaf4664442"
  end

  resource "homebrew-test-pdf", :test do
    url "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"
    sha256 "3df79d34abbca99308e79cb94461c1893582604d68329a41fd4bec1885e6adb4"
  end

  def install
    venv = virtualenv_install_with_resources without: "yara-python"

    resource("yara-python").stage do
      inreplace "setup.py", "self.dynamic_linking = None", "self.dynamic_linking = True"
      venv.pip_install Pathname.pwd
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdfalyze --version")

    resource("homebrew-test-pdf").stage testpath

    output = shell_output("#{bin}/pdfalyze dummy.pdf")
    assert_match "Producer", output
    assert_match "OpenOffice.org 2.1", output
  end
end
