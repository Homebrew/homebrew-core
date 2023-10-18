class Cycode < Formula
  include Language::Python::Virtualenv

  desc "Boost security in your dev lifecycle via SAST, SCA, Secrets & IaC scanning"
  homepage "https://github.com/cycodehq-public/cycode-cli"
  url "https://files.pythonhosted.org/packages/fe/d5/99df1e57cf5af1a3316aeb420429d9738d1bee3ec990907a287f34a61577/cycode-1.4.0.tar.gz"
  sha256 "4083b4d54ec367b79e8052e610a539335a354b6e362a3f4be6fa6340b9bede9a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "932ae2f79bff929e345814e3837a8284bfaf29e1732897da46529632f6510f98"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd80495477f57fc989dba58c3742976c45caff1f13da7ad34d6f9a970929e714"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c087c7c89eb00f2e6eb7bcf03fb7944a267dc50ad74994565013b1556b75566"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fb1890a3719e93070bc4c08536598f64271fb64df70916fb9b0553060b600f0"
    sha256 cellar: :any_skip_relocation, ventura:        "c6d6bd63af52b9148296cde18118fe0b35bb06bb7e3d009d808ae1f6c75c7f1b"
    sha256 cellar: :any_skip_relocation, monterey:       "ec66d4e16bf009416326238ceec9fb61c2bfd388727d51dbc7c8411aac4be85a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ed0c28c6c9ceccafd28924db6e2eb9f649013e1d0a72cbf834e8c20f57ef92d"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/7f/c0/c601ea7811f422700ef809f167683899cdfddec5aa3f83597edf97349962/arrow-1.2.3.tar.gz"
    sha256 "3934b30ca1b9f292376d9db15b19446088d12ec58629bc3f0da28fd55fb633a1"
  end

  resource "binaryornot" do
    url "https://files.pythonhosted.org/packages/a7/fe/7ebfec74d49f97fc55cd38240c7a7d08134002b1e14be8c3897c0dd5e49b/binaryornot-0.4.4.tar.gz"
    sha256 "359501dfc9d40632edc9fac890e19542db1a287bbcfa58175b66658392018061"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/c6/33/5e633d3a8b3dbec3696415960ed30f6718ed04ef423ce0fbc6512a92fa9a/GitPython-3.1.37.tar.gz"
    sha256 "f9b9ddc0761c125d5780eab2d64be4873fc6817c2899cbcb34b02344bdc7bc54"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/e4/e0/3e49c0f91f3e8954806c1076f4eae2c95a9d3ed2546f267c683b877d327b/marshmallow-3.20.1.tar.gz"
    sha256 "5d2371bbe42000f2b3fb5eaa065224df7d8f8597bc19a1bbfa5bfe7fba8da889"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/a0/2a/bd167cdf116d4f3539caaa4c332752aac0b3a0cc0174cdb302ee68933e81/pathspec-0.11.2.tar.gz"
    sha256 "e0d8d0ac2f12da61956eb2306b69f9469b42f4deb0f3cb6ed47b9cce9996ced3"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/88/04/b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baa/smmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/1c/dc/0aff23d6036a4d3bf4f1d8c8204c5c79c4437e25e0ae94ffe4bbb55ee3c2/texttable-1.7.0.tar.gz"
    sha256 "2d2068fb55115807d3ac77a4ca68fa48803e84ebb0ee2340f858107a36522638"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/dd/19/9e5c8b813a8bddbfb035fa2b0c29077836ae7c4def1a55ae4632167b3511/urllib3-1.26.17.tar.gz"
    sha256 "24d6a242c28d29af46c3fae832c36db3bbebcc533dd1bb549172cd739c82df21"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Error: ignore by type is missing", shell_output("#{bin}/cycode ignore 2>&1", 1)
    assert_match "Error: Cycode client id needed.", shell_output("#{bin}/cycode scan path 2>&1", 1)
    output = shell_output("#{bin}/cycode scan -t test 2>&1", 2)
    assert_match "Error: Invalid value for '--scan-type' / '-t'", output
    assert_equal "Cycode authentication failed", shell_output("#{bin}/cycode auth check").strip
    assert_match version.to_s, shell_output("#{bin}/cycode version")
  end
end
