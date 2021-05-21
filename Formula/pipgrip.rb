class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/ab/26/fc90c4c5b010838ec83a204ad7ed4fb91d1de864c1e8141b44c071a7a3be/pipgrip-0.6.9.tar.gz"
  sha256 "1c0d0726e94ef87f7ee7355b3417d36b637c5510efca7454c953ce24762b91a4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "797398c5cfe5088b6b9ba88c3d9c44fb6dfee11747ff7fc58eabb6b6b51b01f0"
    sha256 cellar: :any_skip_relocation, big_sur:       "1cb4071cb3e9ce021d3b87c07810b018a1995e35400452711593baac72ca8e33"
    sha256 cellar: :any_skip_relocation, catalina:      "4fd455f7c74bdcf802b9c0313572bbadac1b7662e23f9c38b485329ba0c34ccf"
    sha256 cellar: :any_skip_relocation, mojave:        "faa0543cc81c8c0033142882eecfcbbcc83b9e3fde4051452725ab92a9e7f997"
  end

  depends_on "python@3.9"

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

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
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
