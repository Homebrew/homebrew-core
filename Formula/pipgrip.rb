class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/37/40/e241ad03b7f6ac6adce4943af37252ff92227bd6c90ea2580bf625371595/pipgrip-0.8.4.tar.gz"
  sha256 "1c6ee78705f60a01934cb03fdd0146c899209c2f08e03e4e75afb31cd5c309e7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05a497b4cd3e7829f62882501ac99810ec740cffe1bab59de5d06955c233c4e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b65056fa75577ae6963843fdebea204c4131be3e05400dab04ff271c69d75696"
    sha256 cellar: :any_skip_relocation, monterey:       "2f57a65a3a4cca989bc7683fa6a20246c5132fb962ad3d0f480cfb26cb58dfd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "5144dcd6cb61ef2971e713538e7a093f8aaebb0a741a20b83ad8654efc19b4af"
    sha256 cellar: :any_skip_relocation, catalina:       "c7689dd675cfd0a01a247452aa0bbc87a913d495527c82fcba96e05aba8a9c8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "557630f7808662f9ed90cec66d92172b88ad23e5f85b10d7ad9d2d3d22fff183"
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
