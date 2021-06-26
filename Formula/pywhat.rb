class Pywhat < Formula
  include Language::Python::Virtualenv

  desc "🐸 Identify anything: emails, IP addresses, and more 🧙"
  homepage "https://github.com/bee-san/pyWhat"
  url "https://files.pythonhosted.org/packages/a8/2d/c0c98cca2922c80abb0f45396caf4b737fb87590851074eb85c321ce4364/pywhat-3.1.0.tar.gz"
  sha256 "89177b77b14f0c1caac3b1cb511dec50edaeeecc4ee8015df6ee4524a3ef33e8"
  license "GPL-3.0-or-later"
  head "https://github.com/bee-san/pyWhat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9ca178e8048065ba110356214e813a11e6db1796c6c82f5063b3336052597d60"
    sha256 cellar: :any_skip_relocation, big_sur:       "9dad47ac4c69ae7fed2dddc2f1d7b64d54fde24bf1b6aacf0856e33eba8eab76"
    sha256 cellar: :any_skip_relocation, catalina:      "9081e261fd949da9b35fd26105ba023debae053d5599c4c10fdc0567f610ae37"
    sha256 cellar: :any_skip_relocation, mojave:        "35497bff2bdf89f4169ad57ad454ee8e87b91bc4cc64bd263aad976ef5d051b2"
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

  resource "name-that-hash" do
    url "https://files.pythonhosted.org/packages/32/58/1f4052bd4999c5aceb51c813cc8ef32838561c8fb18f90cf4b86df6bd818/name-that-hash-1.10.0.tar.gz"
    sha256 "aabe1a3e23f5f8ca1ef6522eb1adcd5c69b5fed3961371ed84a22fc86ee648a2"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/2f/b7/b8b950458f88c6d74978a37ad1d1fb9885464372fcb3d4077c2d9186a5c3/rich-10.4.0.tar.gz"
    sha256 "6e8a3e2c61e6cf6193bfcffbb89865a0973af7779d3ead913fdbbbc33f457c2c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Internet Protocol (IP)", shell_output("#{bin}/pywhat 127.0.0.1").strip
  end
end
