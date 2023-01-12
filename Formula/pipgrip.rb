class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/4c/fc/48fb28d8615c2bdbc2555da0c2f2f52a20d95ba606a4d5f4f67aad6fbd46/pipgrip-0.10.4.tar.gz"
  sha256 "ccdd5068d0171093e3a8e2670dceb17e609ed1ed05a7d533d41678e48e938e31"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8c2440fcb301194d6593c7ac600b019cf81dd049b1c852cd4e4e02ee2c1681f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "284c3ab9cbdc2c482531f152ad2b90fddf0cabc575edfe05023f93003c4be551"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6611de88bad605d92e220dc6e5da65ac55c7d9c514265eb2ee5c2e280fc7cf19"
    sha256 cellar: :any_skip_relocation, ventura:        "aab27d1bfc28234b1bbb75f9fd130f159e77db6f934ba0df76c085013f59e3e4"
    sha256 cellar: :any_skip_relocation, monterey:       "e40b8ad2d8554d9321043c3eacc95d46c1d2c273f6070bb90dc427d2fa32b72d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f341ea593380e32a9e4d2491172020801a5a17977cad18b991a4e57580dec7f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ce425b7442a0f9624fdcdc7af18c86e7a9cc19cc0e5872f1681740a4337d2a1"
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
