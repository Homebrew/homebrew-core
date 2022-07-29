class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/13/44/f222edfce27d958976ceb52b6002925bfd4cc8ef2ef1ae2a71394446f413/pipgrip-0.8.5.tar.gz"
  sha256 "172a204b6b613c7e2b25ea03ed2639971b1e0c9963453a6acc0b569344b04f0a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76f7f0e8c2d7885a4303ee780e02a859db024028382ec38dc21343292c417f8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e03a7a6f0b8070d672c3db2a25f73c6c241e8b4dfef1c6b7ec528d281eb5f1d"
    sha256 cellar: :any_skip_relocation, monterey:       "598b9fc02889849731a1b7aa335a0644bfd5a7aa56479b2fa4fe13a333a46d79"
    sha256 cellar: :any_skip_relocation, big_sur:        "7754274885d5a6c1e28ea5bb667f1c4f61c7999388498ccb4c3ec10b9a63bfd5"
    sha256 cellar: :any_skip_relocation, catalina:       "39e0c5ca17a11374055f6ece2bc9d0c0dadab22850a1fc69798d3bdd902ee304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c864030a788e512056c25a0cc24e5ec2ea235ed05563c4fcc01092d587f86c31"
  end

  depends_on "python@3.10"
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
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/23/3f/f2251c754073cda0f00043a707cba7db103654722a9afed965240a0b2b43/pkginfo-1.7.1.tar.gz"
    sha256 "e7432f81d08adec7297633191bbf0bd47faf13cd8724c3a13250e51d542635bd"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/c0/6c/9f840c2e55b67b90745af06a540964b73589256cb10cc10057c87ac78fc2/wheel-0.37.1.tar.gz"
    sha256 "e9a504e793efbca1b8e0e9cb979a249cf4a0a7b5b8c9e8b65a5e39d49529c1c4"
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
