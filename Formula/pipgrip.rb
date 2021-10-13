class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/37/af/0240a7a53fc3375cd56e63e62c05f0a0d12b878b8e6709dc9e772fbe9182/pipgrip-0.6.11.tar.gz"
  sha256 "a9842a01985203cbc18afdf17671b4b41204bccf86a1a352a1cde2f461969d6f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c52cb1d2e5972128efe598fcc62745b5e1fa6f066901d1366dbbbea4c0a9fe62"
    sha256 cellar: :any_skip_relocation, big_sur:       "c9e14ba251606734a6d88de7594d82e4d62a843800772058275707c291c07fc8"
    sha256 cellar: :any_skip_relocation, catalina:      "7dfd7fe685e31aba9deace2a2d4d51c21bab66ac74ed2876a822c10356223150"
    sha256 cellar: :any_skip_relocation, mojave:        "09a8db46fa81ece85eb5819d911447e9feaf4c5b36da8650a7a59ef0f937806f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b45eb66bb44eb6774f6157b8ca749b9b942fe8a7409fe3e80e8ebcda82b07c9f"
  end

  depends_on "python@3.9"
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
