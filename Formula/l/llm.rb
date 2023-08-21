class Llm < Formula
  include Language::Python::Virtualenv

  desc "Access large language models from the command-line"
  homepage "https://llm.datasette.io/"
  url "https://files.pythonhosted.org/packages/a5/ef/88950afa00b4bb9f574edc71c5becf1a6d45180d9ab9381586a02b995c80/llm-0.7.1.tar.gz"
  sha256 "7e148b4b2935436fef88ea1eb133335458a7f176955c347d39ef401d80f28282"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "484c7bb51bf3c89256ab08eb642daad9684d4b3c5f6a1858dd8b8e60a1c7fd37"
    sha256 cellar: :any,                 arm64_monterey: "2c4b92ee091605384af5914ce611c12e680ea9c4db6ee85c8080f0fb07dd0c2a"
    sha256 cellar: :any,                 arm64_big_sur:  "37c9f30c263a1227b781301481da64c87c9b36bbf012b0708ac0da03af1b29c3"
    sha256 cellar: :any,                 ventura:        "21d803f03d0caa30e3ebdb0e7d6f423a97ab4daee19e290a9c8878d2bc12fc52"
    sha256 cellar: :any,                 monterey:       "8635329cbd95691cecaec416714c827d8573239ff55785cfc9937c1c64f9a8e1"
    sha256 cellar: :any,                 big_sur:        "d87a09bfdf50c8ab14ac2f2d789e03a84fee08b5baffc3cfc3b8068053343bd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b6472cad492f932027bcc31797041a9c39e654be729cfc68cc78782f3fd2f95"
  end

  depends_on "rust" => :build
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-tabulate"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/d6/12/6fc7c7dcc84e263940e87cbafca17c1ef28f39dae6c0b10f51e4ccc764ee/aiohttp-3.8.5.tar.gz"
    sha256 "b9552ec52cc147dbf1944ac7ac98af7602e51ea2dcd076ed194ca3c0d1c7d0bc"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/42/97/41ccb6acac36fdd13592a686a21b311418f786f519e5794b957afbcea938/annotated_types-0.5.0.tar.gz"
    sha256 "47cdc3490d9ac1506ce92c7aaa76c579dc3509ff11e098fc867e5130ab7be802"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/87/d6/21b30a550dafea84b1b8eee21b5e23fa16d010ae006011221f33dcd8d7f8/async-timeout-4.0.3.tar.gz"
    sha256 "4640d96be84d82d02ed59ea2b7105a0f7b33abe8703703cd0ab0bf87c427522f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-default-group-wheel" do
    url "https://files.pythonhosted.org/packages/3d/da/f3bbf30f7e71d881585d598f67f4424b2cc4c68f39849542e81183218017/click-default-group-wheel-1.2.2.tar.gz"
    sha256 "e90da42d92c03e88a12ed0c0b69c8a29afb5d36e3dc8d29c423ba4219e6d7747"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/8c/1f/49c96ccc87127682ba900b092863ef7c20302a2144b3185412a08480ca22/frozenlist-1.4.0.tar.gz"
    sha256 "09163bdf0b2907454042edb19f887c6d33806adc71fbd54afc14908bfdc22251"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/89/ee/84bbd0161090f0f24e8a2ac175e6b6a936289ee02e9d5da414ce14d3d332/openai-0.27.8.tar.gz"
    sha256 "2483095c7db1eee274cebac79e315a986c4e55207bb4fa7b82d185b3a2ed9536"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/8a/42/8f2833655a29c4e9cb52ee8a2be04ceac61bcff4a680fb338cbd3d1e322d/pluggy-1.2.0.tar.gz"
    sha256 "d12f0c4b579b15f5e054301bb226ee85eeeba08ffec228092f8defbaa3a4c4b3"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/61/d3/e707508ce5b2f3015ec50db40c51f9deb1d69538d496deba27a1704dec58/pydantic-2.2.1.tar.gz"
    sha256 "31b5cada74b2320999fb2577e6df80332a200ff92e7775a52448b6b036fce24a"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/d9/5f/3db8f8cd1234ef6c3c3aeb8c3f7e3a9da62ebf178dd59d19d991d30cc987/pydantic_core-2.6.1.tar.gz"
    sha256 "5b4efa68bcfa6f2b93624c6660b6cf4b7b4336d4225afb314254a0ed9c9f4153"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-ulid" do
    url "https://files.pythonhosted.org/packages/e8/8b/0580d8ee0a73a3f3869488856737c429cbaa08b63c3506275f383c4771a8/python-ulid-1.1.0.tar.gz"
    sha256 "5fb5e4a91db8ca93e8938a613360b3def299b60d41f847279a8c39c9b2e9c65e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "sqlite-fts4" do
    url "https://files.pythonhosted.org/packages/c2/6d/9dad6c3b433ab8912ace969c66abd595f8e0a2ccccdb73602b1291dbda29/sqlite-fts4-1.0.3.tar.gz"
    sha256 "78b05eeaf6680e9dbed8986bde011e9c086a06cb0c931b3cf7da94c214e8930c"
  end

  resource "sqlite-utils" do
    url "https://files.pythonhosted.org/packages/73/4f/a652fe1b36ac71f7f7bd85219f233d3619f327efcfe0a1c235b262a5ab53/sqlite-utils-3.35.tar.gz"
    sha256 "8f6fe7f8d12772cd5cf4594703a98dcd0c37c0fd6820dd20541ba74b9fca363a"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/5f/3f/04b3c5e57844fb9c034b09c5cb6d2b43de5d64a093c30529fd233e16cf09/yarl-1.9.2.tar.gz"
    sha256 "04ab9d4b9f587c06d801c2abfe9317b77cdf996c65a90d5e84ecc45010823571"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["OPENAI_API_BASE"] = "https://openai-canned-completion.vercel.app/v1"
    ENV["OPENAI_API_KEY"] = "x"
    assert_match "Hello! How can I assist you today?", shell_output("#{bin}/llm hello --no-log")

    assert_match "llm, version", shell_output("#{bin}/llm --version")
  end
end
