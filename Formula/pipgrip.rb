class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/ea/71/91e6a2efe4aaea01fa2baf14134ba797154fe696b6de57322206b9717d46/pipgrip-0.10.0.tar.gz"
  sha256 "16347df9099d891eb283f1373dbd49857a3ec7b73ac281ec93ceef8073629a53"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca827b00fd8189c748b8f900953099e7aba08fda227e43be24423c1d8304034a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3db558fdfa5d5c5c896213d3769b01f700601bee836d9f2cbee76be1bcec934e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69c8d8963fd6106529fc48bb663ee8bc543a80404e0e8597a3b36742daaceb9b"
    sha256 cellar: :any_skip_relocation, ventura:        "9e1de63e7f10b912accdf25dbeca968882d90703019d089b4600b17edcbd33c4"
    sha256 cellar: :any_skip_relocation, monterey:       "9ca4670c5c94441f297d0da48bc7a994898a58dd50624dc52067032742f748b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4b5eebbf8768e6357055677e5758cc7a1af33b435855746f288d2610690fad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b186db1ca45dca08cc36ee9c0c94cc878c052792f3187c62e95f8e1f812f875"
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
    url "https://files.pythonhosted.org/packages/6b/f7/c240d7654ddd2d2f3f328d8468d4f1f876865f6b9038b146bec0a6737c65/packaging-22.0.tar.gz"
    sha256 "2198ec20bd4c017b8f9717e00f0c8714076fc2fd93816750ab48e2c41de2cfd3"
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
