class Pywhat < Formula
  include Language::Python::Virtualenv

  desc "🐸 Identify anything: emails, IP addresses, and more 🧙"
  homepage "https://github.com/bee-san/pyWhat"
  url "https://files.pythonhosted.org/packages/3e/44/79b8aaf9053c0a08f63906118b2452145279d6a1f03bf7e0c17813fe5406/pywhat-3.4.1.tar.gz"
  sha256 "47895046deceb13e9a4dce0f09df174b842e49a243ce487d76ab8460a07e0a7c"
  license "MIT"
  head "https://github.com/bee-san/pyWhat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2dd5fa32877e896e9a3394a002af1c845b15592d9d3e35ab19a56ddead220a1c"
    sha256 cellar: :any_skip_relocation, big_sur:       "d7df846ffcc04a6216233627dd7fd5f71ae14bbb3a0a2620c22d68c919158a55"
    sha256 cellar: :any_skip_relocation, catalina:      "6ec50cddeeefe152b13fa31e4784f55f4b862d626c6c68a6c9b0465b7b58b91e"
    sha256 cellar: :any_skip_relocation, mojave:        "d90df27e0be6d69edea374a1d4c7c5a9cd6ec3943fa1c537884e42e770428cc1"
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
    url "https://files.pythonhosted.org/packages/6b/ea/af2a2218d57cc52dc7f14e4350ee9647fa79c6c820cfc05c438795fb13b4/rich-10.7.0.tar.gz"
    sha256 "13ac80676e12cf528dc4228dc682c8402f82577c2aa67191e294350fa2c3c4e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Internet Protocol (IP)", shell_output("#{bin}/pywhat 127.0.0.1").strip
  end
end
