class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/bb/ba/2d7dc76ba18dd7ab3c8ea4ef9399dd3b088d2fb52e017037f1465fb3acde/pipgrip-0.7.0.tar.gz"
  sha256 "52808acd8caaa0be04adbc783522e44a2ff84e3c64c9f473fa8aa14c4e4ac0ae"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d65001dbc6d0ac1df870abdb5b9b0c9832ec025271818ada4c7ef87a135347e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2da3ba78c6eb9bbd45b27c4cad8e4e61fc7d30bd331f1fc629068310fbde3c72"
    sha256 cellar: :any_skip_relocation, monterey:       "55f5f4a0b959301383def35c9c444c1e63b9a0c2580dcccee292e59d49cffd2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "beb1cefe7072013544c220d685834fba8183018395d220c5eb10f4539ccb33bb"
    sha256 cellar: :any_skip_relocation, catalina:       "c990e3bd386fc9220f1114699adc5f9aeef7303f724c42ec350712bf9b2889f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d9db6c2a9974a1813f8cfcadd75082f87ad874fdbddd1df2136fc6e35ebcf9e"
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
