class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/37/af/0240a7a53fc3375cd56e63e62c05f0a0d12b878b8e6709dc9e772fbe9182/pipgrip-0.6.11.tar.gz"
  sha256 "a9842a01985203cbc18afdf17671b4b41204bccf86a1a352a1cde2f461969d6f"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ce3dd5b1c1ab09096abf41da8232aaf1816567e12f6cd3e4b89656286358ceb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc692e49f66513bb51a34430923aa3d1118a7f75b9152b46fdf2cd5cb7b95839"
    sha256 cellar: :any_skip_relocation, monterey:       "9d937406051aafc1e3db327b616f3ef21780397b7521eef970626102dcc92d5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a67a2c90e5074e757d5698572e5b9ab3ced8646fa404fbe593463099f5ff2eb"
    sha256 cellar: :any_skip_relocation, catalina:       "e6c178b93ee57c1666364b397d4779804df9932f7dc6132e76a3211955fc16a9"
    sha256 cellar: :any_skip_relocation, mojave:         "019e6176aa868cf0239c7453327efe451bc017c83f6a9a71bc1dccb080890556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff5e852cc19aae300f9cd978d5b88b69ead11455780935b41b6a8e17103a1f7b"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/d8/45/de59861abc8cb66e9e95c02b214be4d52900aa92ce34241a957dcf1d569d/anytree-2.8.0.tar.gz"
    sha256 "3f0f93f355a91bc3e6245319bf4c1d50e3416cc7a35cc1133c1ff38306bbccab"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/86/aef78bab3afd461faecf9955a6501c4999933a48394e90f03cd512aad844/packaging-21.0.tar.gz"
    sha256 "7dc96269f53a4ccec5c0670940a4281106dd0bb343f47b7471f779df49c2fbe7"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/23/3f/f2251c754073cda0f00043a707cba7db103654722a9afed965240a0b2b43/pkginfo-1.7.1.tar.gz"
    sha256 "e7432f81d08adec7297633191bbf0bd47faf13cd8724c3a13250e51d542635bd"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/4e/be/8139f127b4db2f79c8b117c80af56a3078cc4824b5b94250c7f81a70e03b/wheel-0.37.0.tar.gz"
    sha256 "e2ef7239991699e3355d54f8e968a21bb940a1dbf34a4d226741e64462516fad"
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
