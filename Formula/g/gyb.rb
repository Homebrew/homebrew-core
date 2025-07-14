class Gyb < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "CLI for backing up and restoring Gmail messages"
  homepage "https://github.com/GAM-team/got-your-back/"
  # Check gyb.py imports for any changes. Update pypi_formula_mappings.json (if necessary)
  # and then run `brew update-python-resources gyb`.
  url "https://github.com/GAM-team/got-your-back/archive/refs/tags/v1.82.tar.gz"
  sha256 "9cd29c81c78fceebe1e7ed34627bb27d758a250ccae92aecf6bacf1da6dfed09"
  license "Apache-2.0"
  revision 1
  head "https://github.com/GAM-team/got-your-back.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82fe01ba45479d98880d0402fecda87902bfd50376f09371f70fa6c9cc44de87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b278278f8d6096b6f3264bec75b3bf422639c9d4268331421463dc573e7b2b0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f1fcc3e4368d85f2eab92cab3f3c6710b95f569c58c074486ae90bf5d68600f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e88326d2329a2be1761e10495e1c9eeb0099264eec04f96574451d405e837d35"
    sha256 cellar: :any_skip_relocation, ventura:       "0dbd278a81ca797e3889453a42c46ff2c4872c42d97eae256807128b8c720685"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c3b8d13436be13a1fd5bc33f5a12aff1eb6e564307cf302e692c0ae7cf55197"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03e01c1b3ee8ca1de0af6a91066ffb926e3278e57629a57cdc7c15b9281c464c"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/6c/81/3747dad6b14fa2cf53fcf10548cf5aea6913e96fab41a3c198676f8948a5/cachetools-5.5.2.tar.gz"
    sha256 "1a661caa9175d26759571b2e19580f9d6393969e5dfca11fdb1f947a23e640d4"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/dc/21/e9d043e88222317afdbdb567165fdbc3b0aad90064c7e0c9eb0ad9955ad8/google_api_core-2.25.1.tar.gz"
    sha256 "d2aaa0b13c78c61cb3f4282c464c046e45fbd75755683c9c525e6e8f7ed0a5e8"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/8f/7e/7c6e43e54f611f0f97f1678ea567fe06fecd545bd574db05e204e5b136fe/google_api_python_client-2.173.0.tar.gz"
    sha256 "b537bc689758f4be3e6f40d59a6c0cd305abafdea91af4bc66ec31d40c08c804"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/9e/9b/e92ef23b84fa10a64ce4831390b7a4c2e53c0132568d99d4ae61d04c8855/google_auth-2.40.3.tar.gz"
    sha256 "500c3a29adedeb36ea9cf24b8d10858e152f2412e3ca37829b3fa18e33d63b77"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/56/be/217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacef/google-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/fb/87/e10bf24f7bcffc1421b84d6f9c3377c30ec305d082cd737ddaa6d8f77f7c/google_auth_oauthlib-1.2.2.tar.gz"
    sha256 "11046fb8d3348b296302dd939ace8af0a724042e8029c1b872d87fabc9f41684"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/39/24/33db22342cf4a2ea27c9955e6713140fedd51e8b141b5ce5260897020f1a/googleapis_common_protos-1.70.0.tar.gz"
    sha256 "0e1b44e0ea153e6594f9f394fef15193a68aaaea2d843f83e2742717ca753257"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/f4/ac/87285f15f7cce6d4a008f33f1757fb5a13611ea8914eb58c3d0d26243468/proto_plus-1.26.1.tar.gz"
    sha256 "21a515a4c4c0088a773899e23c7bbade3d18f9c66c73edd4c7ee3816bc96a012"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/52/f3/b9655a711b32c19720253f6f06326faf90580834e2e83f840472d752bc8b/protobuf-6.31.1.tar.gz"
    sha256 "d8cac4c982f0b957a4dc73a80e2ea24fab08e679c0de9deb835f4a12d69aca9a"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/bb/22/f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60f/pyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/da/8a/22b7beea3ee0d44b1916c0c1cb0ee3af23b700b6da9f04991899d0c555d4/rsa-4.9.1.tar.gz"
    sha256 "e7bdbfdb5497da4c07dfd35530e1a902659db6ff241e39d9953cad06ebd0ae75"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/98/60/f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56/uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def python3
    "python3.13"
  end

  def install
    # change user config location from default of executable own path
    inreplace "gyb.py", "default=getProgPath()",
                        "default='#{pkgetc}'"

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    rw_info = python_shebang_rewrite_info(libexec/"bin/python")
    rewrite_shebang rw_info, "gyb.py"
    bin.install "gyb.py" => "gyb"
    (libexec/Language::Python.site_packages(python3)).install buildpath.glob("*.py")
  end

  def post_install
    pkgetc.mkpath
  end

  def caveats
    <<~EOS
      Default config_folder: #{pkgetc}
    EOS
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/gyb --version 2>&1")
    # Below throws a bad exit code but we can check it actually is failing
    # for the right reasons by asserting. --version never fails even if
    # resources are missing or outdated/too new/etc.
    assert_match "ERROR: --email is required.", shell_output(bin/"gyb", 1)
  end
end
