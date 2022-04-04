class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/55/8d/6306404ba7d7ad9cf60cb16ddc9673148794a6d55972bdd5ed226bde703e/pipgrip-0.7.2.tar.gz"
  sha256 "e7f2ef078b1db1ebb0abf31adc34d77061ed73102257c99acba12ca15f98ecd1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c2e5d067e868d2be9fd4fac63bc1a5105dba6974cb33b6f3668c35220c73107"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a119edfe60379bd7d125b4820721a922f90571fde1e6e7ccb88badf7af8af48"
    sha256 cellar: :any_skip_relocation, monterey:       "aeaf79332a21b34004208e426fafd2dec0af5bf73cf3095ce3c620b007803bd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "badf096b0eee025090355c943a64aed3ffd197de8af9f433cc20cf837d265ec0"
    sha256 cellar: :any_skip_relocation, catalina:       "7e3c9c9c75cf444a1fb39d2ad1c3e37281072979e4cf7c0b675f33f0996e92f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "462b1fd4daa7476d71df37f0edd901114113bb591caf3ad8b32413bbdae9cb0e"
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
