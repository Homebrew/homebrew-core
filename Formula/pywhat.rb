class Pywhat < Formula
  include Language::Python::Virtualenv

  desc "🐸 Identify anything: emails, IP addresses, and more 🧙"
  homepage "https://github.com/bee-san/pyWhat"
  url "https://files.pythonhosted.org/packages/ed/52/5b08d8417e4b9711e7cefed9ca6499beec84401117f55e9c86e251b3360b/pywhat-3.3.0.tar.gz"
  sha256 "f62e16ae0f0a6cd1abbbe2ba56f28946e3b83a5ceec6ad6f0f1358540a00740d"
  license "GPL-3.0-or-later"
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
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/72/f5/1f06eb039318ae8eb4d13e4abe52dd0b1fdd466b35cf9e52a2e505509532/rich-10.6.0.tar.gz"
    sha256 "128261b3e2419a4ef9c97066ccc2abbfb49fa7c5e89c3fe4056d00aa5e9c1e65"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Internet Protocol (IP)", shell_output("#{bin}/pywhat 127.0.0.1").strip
  end
end
