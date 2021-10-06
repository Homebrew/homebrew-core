class Pywhat < Formula
  include Language::Python::Virtualenv

  desc "🐸 Identify anything: emails, IP addresses, and more 🧙"
  homepage "https://github.com/bee-san/pyWhat"
  url "https://files.pythonhosted.org/packages/ef/eb/6863e62793ba4b6bb80fe7c77338be0f7c3cb4083b72e5b537a076c03040/pywhat-4.1.0.tar.gz"
  sha256 "67e403f1ecba217c0f31147766c2f48be61ccb2037f6546d6b9a52e147c45daa"
  license "MIT"
  head "https://github.com/bee-san/pyWhat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "24a702751d3e16c8b2062d0e05cc4e6b2ac28ce2d9e29229bb195c6eb879de9b"
    sha256 cellar: :any_skip_relocation, big_sur:       "b67921e1bf327276441e138ea652edda87c1192c6a1a958052553fc357c174a3"
    sha256 cellar: :any_skip_relocation, catalina:      "27d404e3cb2de1604384b504cfec52a8c276d08f46c863c4a517359c2ebe6fe4"
    sha256 cellar: :any_skip_relocation, mojave:        "9cc875f60d28854f4ab145154d7ebfa9cb8c53a9e8721b1cd6faa58958715613"
  end

  depends_on "python@3.9"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/57/3f/a8ba181148dcb9184cb0afac66d075fce60f06f926ce9cdab3dc61fd6497/rich-10.11.0.tar.gz"
    sha256 "016fa105f34b69c434e7f908bb5bd7fefa9616efdb218a2917117683a6394ce5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Internet Protocol (IP)", shell_output("#{bin}/pywhat 127.0.0.1").strip
  end
end
