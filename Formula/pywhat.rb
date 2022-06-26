class Pywhat < Formula
  include Language::Python::Virtualenv

  desc "🐸 Identify anything: emails, IP addresses, and more 🧙"
  homepage "https://github.com/bee-san/pyWhat"
  url "https://files.pythonhosted.org/packages/ae/31/57bb23df3d3474c1e0a0ae207f8571e763018fa064823310a76758eaef81/pywhat-5.1.0.tar.gz"
  sha256 "8a6f2b3060f5ce9808802b9ca3eaf91e19c932e4eaa03a4c2e5255d0baad85c4"
  license "MIT"
  revision 1
  head "https://github.com/bee-san/pyWhat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c8902e8dd4e43d3a3638a72cae5b10a8c04274ec822c08d30f58053766dbb7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "333d03a8fd236fe7e6b4bfa579c756befdb6e7de84d5e5dc8559095bf9bab25c"
    sha256 cellar: :any_skip_relocation, monterey:       "faad28e769cc332cb3379ca98db957b9b11b06e7ae5343d97ad63d83d47f3e30"
    sha256 cellar: :any_skip_relocation, big_sur:        "57ec0e2ea7275b946131259edc3fa1905c67944ccc392727057f4039d09dfa77"
    sha256 cellar: :any_skip_relocation, catalina:       "d7d5514d9685337f461ad02e1ccfdce706aac177d1991427f8e97793a03f7fe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "126c34962fec06f65f043d4983a15bc245ee279c15f18363c4836dcbb82abdf6"
  end

  depends_on "python@3.10"
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
    url "https://files.pythonhosted.org/packages/8f/22/6241daa2750061ef726ff6b4ebdb9b774166f241997b256620cf20b14da5/rich-10.15.2.tar.gz"
    sha256 "1dded089b79dd042b3ab5cd63439a338e16652001f0c16e73acdcf4997ad772d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Internet Protocol (IP)", shell_output("#{bin}/pywhat 127.0.0.1").strip
  end
end
