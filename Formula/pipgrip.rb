class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/32/9f/2bb2d03ce4bb044756a754721d7d8d7ee6d439b0334134826ae02d0c6c8a/pipgrip-0.9.0.tar.gz"
  sha256 "42248132a6b190ea255618b94d39fa21b8987d2934d03e3add410e1f3b9d4d54"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "218f1e988426b993e1ee10452e1b2f41662281626a45891c5fc5e2e07d5c6407"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d5175748be36158724fbfbc8a9eb7612def2b9a5823e14094bbe996f06725a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "021558d54f86eee573e95ed1e847d097db9e74f07f2683fba2b8be710d3dc19a"
    sha256 cellar: :any_skip_relocation, monterey:       "828b59d8d05719d3f515c0cb7541182c982e67460ff9aa06e6a6dbbb3751936a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f0c82c246b2ebc60730d12568f1504137fdcfa6bb043481a14513187912432e"
    sha256 cellar: :any_skip_relocation, catalina:       "b0df7634094461a0771179b36d06cbed4f037256fbfed0acae2bf938ad45f10c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c05ef8978641347e5a420970ccafc5be0a0c1896078e447e5b8a66949a237501"
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
