class Cycode < Formula
  include Language::Python::Virtualenv

  desc "Boost security in your dev lifecycle via SAST, SCA, Secrets & IaC scanning"
  homepage "https://github.com/cycodehq/cycode-cli"
  url "https://files.pythonhosted.org/packages/b7/43/4d3861fe5047917157c2348cd94a2bec2f338bb54c365e9d1d5616897e44/cycode-1.9.1.tar.gz"
  sha256 "5c6bb71235264c062d178bfa84630eec972d9f8e603d85ce46a80c6d5739b69f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fb9dfd46dbd4cb3a1fae95ba549e5c6408fa1381888d6718dc2d9b06bfdc310e"
    sha256 cellar: :any,                 arm64_ventura:  "c260009fa4a8b739f00fc7c296622f6c08f3abf6efff2d0758e36ae97f23900e"
    sha256 cellar: :any,                 arm64_monterey: "55b2b94a365a3140e373bf8570cbe5ed11efb2edb6768cd34f8e9b5466689a80"
    sha256 cellar: :any,                 sonoma:         "91796c340baecf6b1a0f60915c951fa74e75b60e777e2c1438413a533b98f26b"
    sha256 cellar: :any,                 ventura:        "36af6598ab72b4a73e04a5910ca9403e0e27135abc3bc248c61bab4b7a6d09db"
    sha256 cellar: :any,                 monterey:       "d77f111f9a2dff44e7ad3ee86525e3c594d51181f592e2041b73e146fca36fe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4074120d9cea22dfab04ada5c3c471779e8750da4f3ab9fd125e11718775fcb1"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.12"

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
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
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
    url "https://files.pythonhosted.org/packages/19/0d/bbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8ed/gitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/8f/12/71a40ffce4aae431c69c45a191e5f03aca2304639264faf5666c2767acc4/GitPython-3.1.42.tar.gz"
    sha256 "2d99869e0fef71a73cbd242528105af1d6c1b108c60dfabd994bf292f76c3ceb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/03/81/763717b3448e5d3a3906f27ab2ffedc9a495e8077946f54b8033967d29fd/marshmallow-3.20.2.tar.gz"
    sha256 "4c1daff273513dc5eb24b219a8035559dc573c8f322558ef85f5438ddd1236dd"
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

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
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
    url "https://files.pythonhosted.org/packages/0c/39/64487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08/urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"cycode", shells: [:fish, :zsh], shell_parameter_format: :click)
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
