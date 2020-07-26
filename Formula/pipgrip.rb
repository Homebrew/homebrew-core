class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/2d/51/7d3b80ded0bfd14f2febb57b8710eff9638c474fdffd2489d5c1ad566528/pipgrip-0.4.2.tar.gz"
  sha256 "a367c4a2c04f6325419f813c39b03c5462a522b812b5c677341cff85ae568ba5"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "2825087e05bd56389394e201d3681de393f422993b8d5e9a1a5df650158a6869" => :catalina
    sha256 "5e1d242d11a3a15bfd206384d814f4cb2e5857d6b6702b58d6409f77e96a2a9a" => :mojave
    sha256 "b970cb4a4f1520d551e8a63d4cbd48fc8a649ea9c52eecbcfd6025a9914068aa" => :high_sierra
  end

  depends_on "python@3.8"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/d8/45/de59861abc8cb66e9e95c02b214be4d52900aa92ce34241a957dcf1d569d/anytree-2.8.0.tar.gz"
    sha256 "3f0f93f355a91bc3e6245319bf4c1d50e3416cc7a35cc1133c1ff38306bbccab"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/55/fd/fc1aca9cf51ed2f2c11748fa797370027babd82f87829c7a8e6dbe720145/packaging-20.4.tar.gz"
    sha256 "4357f74f47b9c12db93624a82154e9b120fa8293699949152b22065d556079f8"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/6c/04/fd6683d24581894be8b25bc8c68ac7a0a73bf0c4d74b888ac5fe9a28e77f/pkginfo-1.5.0.1.tar.gz"
    sha256 "7424f2c8511c186cd5424bbf31045b77435b37a8d604990b79d4e70d741148bb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipgrip==#{version}", shell_output("#{bin}/pipgrip pipgrip -v --no-cache-dir")
  end
end
