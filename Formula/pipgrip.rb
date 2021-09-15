class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/6d/58/498fceb2264c03e3a7cc672aea29c363995ff7a61d169f2cce7bc297eeba/pipgrip-0.6.10.tar.gz"
  sha256 "775b82aa6fc33b31bfadb483946172c235285d019f0577ab40fde219a7ff977d"
  license "BSD-3-Clause"
  revision 1

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
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/36/d3/f56bbbb9e03812de99be566a4c8ed90a0202b9aebd4528b2ad98900b9063/pkginfo-1.7.0.tar.gz"
    sha256 "029a70cb45c6171c329dfc890cde0879f8c52d6f3922794796e06f577bb03db4"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/ed/46/e298a50dde405e1c202e316fa6a3015ff9288423661d7ea5e8f22f589071/wheel-0.36.2.tar.gz"
    sha256 "e11eefd162658ea59a60a0f6c7d493a7190ea4b9a85e335b33489d9f17e0245e"
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
