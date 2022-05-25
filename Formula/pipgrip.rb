class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/c7/4f/686a01a7fa103f110b58a5f29ee08c8963ede9a72d83a0385bce0fed76d0/pipgrip-0.8.1.tar.gz"
  sha256 "61c8648a818ad21f0899a46f5931d1c48b27a927241f9fcef654b0273e90bf82"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6649e39662473dbef5835f402f0ad0a48770a665329b0fcfb4daf11bd982be95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bbcd0d9d08454262702b862ac2ae684b37a818d5519ce7a76e20adaca52baaf"
    sha256 cellar: :any_skip_relocation, monterey:       "fe6410854f180cfa11e7aa54f13211703a64d61739a2e38abe958cdf0a44dbe4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a11313b9be83d528622329acd27ff4d86741b3b50a8de57ebf843ac1d26e145a"
    sha256 cellar: :any_skip_relocation, catalina:       "f21ba90df060ce1c93583c65b6ddbc8063758aa442a56ab186bcd612a75ea4d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93e140231135aae6b68c9ad0c8cb791f7b3120fd9968917d9f88fa28f8b32c88"
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
