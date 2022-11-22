class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/32/9f/2bb2d03ce4bb044756a754721d7d8d7ee6d439b0334134826ae02d0c6c8a/pipgrip-0.9.0.tar.gz"
  sha256 "42248132a6b190ea255618b94d39fa21b8987d2934d03e3add410e1f3b9d4d54"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a208544fc56d66489695b0b2b69071d5aaf7d1029b0eb28e4c27366e7235a6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd9bad7cdb008507a2a9d8b23a7f8533b444f68a1519ad8acb01d276b4f06b56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c48897863c4051661461838e47d76d6b1c8bfde721f845e7ea88ef69bd06c415"
    sha256 cellar: :any_skip_relocation, monterey:       "23bdda846347c2c012e6c9d39ab8f5195c09ac2eacc52420898a4bbb9c0ca52e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c94a4bd9dafa11e5f20b63d060ee33a213c0768e1c15c20244558b304639ee7"
    sha256 cellar: :any_skip_relocation, catalina:       "607fa87cef9d62d7d92662bceac994712217513a4d822ae79f70654d0ba8167d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f271147998794b84762ca9ef4795c818265b1c2715717f6dc53a01ec85795228"
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
