class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/7f/59/22e9647cd3a6ea424d55ba3045cc599c1a06280feab219f0142cf59bbc4b/pipgrip-0.10.1.tar.gz"
  sha256 "7cb309d82fea751cea5b3e546521cb5d7fda4935c6576c26a8bacdedc45ad004"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66ce1c2da4c0f9cd272c124aa8a8d2ebb49c4c7972c1aec07dd64255dd9b183a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b42635f29047cd94b55ae9ba4d7b89482b99158730532207037576cd23244ee7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87fb0ed3562913a0931fb4daffaa27ffa9925a93c86b0b883ec66a17b6d1be2b"
    sha256 cellar: :any_skip_relocation, ventura:        "0f19d2497439cd225aef6a355a20991376d8db475ccf06181a931483284da98f"
    sha256 cellar: :any_skip_relocation, monterey:       "15f924451576ed3002bd38548db64d0a85456de01dbb9844fcfb57b6c5c3ccc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "c60c96d17ef5bea80bd7579d9ac96462c8c260cb373578796db2aba3883991a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc6540b5259c0726a90f67a8346555e2be59859b31ab02876a679c7dcf4d0d92"
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
