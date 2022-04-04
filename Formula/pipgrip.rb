class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/55/8d/6306404ba7d7ad9cf60cb16ddc9673148794a6d55972bdd5ed226bde703e/pipgrip-0.7.2.tar.gz"
  sha256 "e7f2ef078b1db1ebb0abf31adc34d77061ed73102257c99acba12ca15f98ecd1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38e01dfdbe6ed06ba8377e25c8a618d9efcbdff67b95e77186129113720a8d5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95ed855947b19181426bb07aecf7ea2a3606b7e1257f3d4787a28dc8d66d049e"
    sha256 cellar: :any_skip_relocation, monterey:       "c3aa765845acded32d1c373fbe5bf75fd93011ee0ccea63ac4cfd4566cb898df"
    sha256 cellar: :any_skip_relocation, big_sur:        "342608ccc74ae1ac5d0a6367e72d2792cbcff4bbdcd20baab4aafe06ac2ca9f4"
    sha256 cellar: :any_skip_relocation, catalina:       "65c1e8389dcae45bb1b8970594f407ee1cbaedf484c63cbd328c87a8f41ddcfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec4bd19c920d0ee82f3b88815bc8e9d5036cfd31db10d1eb1194de4fc100eccd"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/d8/45/de59861abc8cb66e9e95c02b214be4d52900aa92ce34241a957dcf1d569d/anytree-2.8.0.tar.gz"
    sha256 "3f0f93f355a91bc3e6245319bf4c1d50e3416cc7a35cc1133c1ff38306bbccab"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/42/e1/4cb2d3a2416bcd871ac93f12b5616f7755a6800bccae05e5a99d3673eb69/click-8.1.2.tar.gz"
    sha256 "479707fe14d9ec9a0757618b7a100a0ae4c4e236fac5b7f80ca68028141a1a72"
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
    url "https://files.pythonhosted.org/packages/d6/60/9bed18f43275b34198eb9720d4c1238c68b3755620d20df0afd89424d32b/pyparsing-3.0.7.tar.gz"
    sha256 "18ee9022775d270c55187733956460083db60b37d0d0fb357445f3094eed3eea"
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
