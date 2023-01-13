class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/4c/fc/48fb28d8615c2bdbc2555da0c2f2f52a20d95ba606a4d5f4f67aad6fbd46/pipgrip-0.10.4.tar.gz"
  sha256 "ccdd5068d0171093e3a8e2670dceb17e609ed1ed05a7d533d41678e48e938e31"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c18cb820ee0e1bc055151788d53615de04d92906cfa797fd1f7ae0845bd37bc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4355b59405f1da21ae2e551cb93be0cac817d110ac351d1de15cd2d494a7490c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6aae463dd8bb2149655b22555385a4130de5ccd91d73fa4513b3d6b8d856befb"
    sha256 cellar: :any_skip_relocation, ventura:        "13d25363d7a764ee74e3f4b065bb5f22031acde890a96ceedc5b4d40c495cec7"
    sha256 cellar: :any_skip_relocation, monterey:       "f979a0ef7ad5ac34d753eea71cedc1c91470793afe243eca1a2915df07f316f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "755f6718559d08e0e346542743dfcae15f3e3af7ec18c637780706e3073cf7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b788320b39cf5db887f51d994170a33fe4c19431bb914a5f327b5a6ad83a3c9"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/d8/45/de59861abc8cb66e9e95c02b214be4d52900aa92ce34241a957dcf1d569d/anytree-2.8.0.tar.gz"
    sha256 "3f0f93f355a91bc3e6245319bf4c1d50e3416cc7a35cc1133c1ff38306bbccab"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/23/3f/f2251c754073cda0f00043a707cba7db103654722a9afed965240a0b2b43/pkginfo-1.7.1.tar.gz"
    sha256 "e7432f81d08adec7297633191bbf0bd47faf13cd8724c3a13250e51d542635bd"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/a2/b8/6a06ff0f13a00fc3c3e7d222a995526cbca26c1ad107691b6b1badbbabf1/wheel-0.38.4.tar.gz"
    sha256 "965f5259b566725405b05e7cf774052044b1ed30119b5d586b2703aafe8719ac"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipgrip==#{version}", shell_output("#{bin}/pipgrip pipgrip --no-cache-dir")
    # Test gcc dependency
    assert_match "dxpy==", shell_output("#{bin}/pipgrip dxpy --no-cache-dir")
  end
end
