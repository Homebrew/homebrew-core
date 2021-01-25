class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/73/3a/02c79107df8aa23def1022cdaf7a874ee266487ea8f7ac9a0de74ce7e57a/pipgrip-0.6.2.tar.gz"
  sha256 "5faf98aba48af53f67aecd1a5bda307c3def56e72f77d67c6533d7f33a4eebaa"
  license "BSD-3-Clause"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "13b01f35d30b10a0caeb39c486d2bc7bf4d652736de3e28fa2684ac881e83a98" => :big_sur
    sha256 "1152cc9a5ff6ac31cca1a13d230b7f6b94bb21720d007735f1d32cfdbf5907f2" => :arm64_big_sur
    sha256 "26d79927450050d2db8ca89c4144e3be93405ff096df8466cd91f422d1e9c914" => :catalina
    sha256 "98fbc2f6d513292d4d072375836d4502e3ba39d848cf5bee45309ea78c01d7e2" => :mojave
  end

  depends_on "python@3.9"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/d8/45/de59861abc8cb66e9e95c02b214be4d52900aa92ce34241a957dcf1d569d/anytree-2.8.0.tar.gz"
    sha256 "3f0f93f355a91bc3e6245319bf4c1d50e3416cc7a35cc1133c1ff38306bbccab"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/c5/e81b9fb8033fe78a2355ea7b1774338e1dca2c9cbd2ee140211a9e6291ab/packaging-20.8.tar.gz"
    sha256 "78598185a7008a470d64526a8059de9aaa449238f280fc9eb6b13ba6c4109093"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/30/e3/5b17405ee8c8a78b5ae6ede4c5f296bebd97eb5982b28bbe37d61802bbc5/pkginfo-1.6.1.tar.gz"
    sha256 "a6a4ac943b496745cec21f14f021bbd869d5e9b4f6ec06918cffea5a2f4b9193"
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
    assert_match "pipgrip==#{version}", shell_output("#{bin}/pipgrip pipgrip --no-cache-dir")
    # Test gcc dependency
    assert_match "dxpy==", shell_output("#{bin}/pipgrip dxpy --no-cache-dir")
  end
end
