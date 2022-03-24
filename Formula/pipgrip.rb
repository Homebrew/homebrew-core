class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/f4/0c/eda6ebf43b91fb02e9652d2ef67e1cbda9265b3476239dc2b2e744949db9/pipgrip-0.7.1.tar.gz"
  sha256 "894c864788562babb1845c74d9887c93956e5ccaf7410c08c1934bae5e9737af"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e91edd520012977e37ab4f054c16dab4ea8eb430672a93807838a6757bfc23b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7db75a4a39a1c0e20ad694412ee8fa30f942b3a1d1991b45728e91fda52d9b28"
    sha256 cellar: :any_skip_relocation, monterey:       "0829c332142902545eb7963f9de106a6af2d7b9fe3b04fb0214786d5f55c03e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1ba29888064ebc66a1950d2990f0ebe20c8c931faeba6860d87b8f73a0c6e20"
    sha256 cellar: :any_skip_relocation, catalina:       "8928a4d6088a97e2e8f867cd08e66dd2269733b17a3eeb49c7f31dd78656af6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53a85d97b298d454a0b769ec844170aa4859b76e0e66ab2740ac3a99d812e112"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/d8/45/de59861abc8cb66e9e95c02b214be4d52900aa92ce34241a957dcf1d569d/anytree-2.8.0.tar.gz"
    sha256 "3f0f93f355a91bc3e6245319bf4c1d50e3416cc7a35cc1133c1ff38306bbccab"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/dd/cf/706c1ad49ab26abed0b77a2f867984c1341ed7387b8030a6aa914e2942a0/click-8.0.4.tar.gz"
    sha256 "8458d7b1287c5fb128c90e23381cf99dcde74beaf6c7ff6384ce84d6fe090adb"
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
