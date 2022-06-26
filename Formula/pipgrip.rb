class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/6b/0e/fb6db73fa6fe581f2f2e66fc747c88754f7bf36ae87f092c75c3b7b24d6d/pipgrip-0.8.2.tar.gz"
  sha256 "e8ae2009fca122dc4410b28b31505eb447dffc600b74347e75d911543eb65e88"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a996381ca0b954b97e90869fd22edd611d91c9c531d4d0bbb8f69971fab698a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a59ece0ec362a568adbe0c22424d7df9dae748a7a86934dea2760fee02b4da3f"
    sha256 cellar: :any_skip_relocation, monterey:       "8f60a9b05de092c0bec6bf0536b7045ee074c1327b9e24042cd19340b40c71c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e82b7cefe4345acf2af5ab0d0409add516715a7af9f99753d0a0ccdba91d2cb7"
    sha256 cellar: :any_skip_relocation, catalina:       "5b3a27aa3b79e8a22fe14732dfc210093f399e0e0f5a397b487a8d1e8923f0c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f149e7e2c9e915fb1ca305c567959f4a03ddc2b495673cf5209f3ca8d3cf8c4"
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
