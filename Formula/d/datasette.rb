class Datasette < Formula
  include Language::Python::Virtualenv

  desc "Open source multi-tool for exploring and publishing data"
  homepage "https://docs.datasette.io/en/stable/"
  url "https://files.pythonhosted.org/packages/80/26/80b5480921d71891b8ff880fed6d44150b9164903d683efe2eb7405b61d8/datasette-0.65.2.tar.gz"
  sha256 "be956fb2633b8380d7f818b5ddab40d5c7346d5e9d4d24e81c43b1fb60267432"
  license "Apache-2.0"
  revision 3
  head "https://github.com/simonw/datasette.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e30a0b27f9ad366cddaaf5048681e04a61d2fa97ca20676c89949c82d4ba0932"
    sha256 cellar: :any,                 arm64_sequoia: "938a03f5cb768d640f937114b78d5f87e3aadc602b693ccbbcb9e687e4f65285"
    sha256 cellar: :any,                 arm64_sonoma:  "987e4faaceeaa3b7e6135b0477d86ebcd2e720832db11776a25eb5c920178c9f"
    sha256 cellar: :any,                 sonoma:        "e8e14ad897b3e0f7dec41b7a1ce29fd69d34665e7fa5559e9ebd8393c880ccc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39aefc697b34c27b473333ad209fcc66af455a99d7895d107e547ba65f1ac668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7700238801f541277c4acf591d54b20f8d8ad7aff815ecacb8f29cf9c779e32"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/41/c3/534eac40372d8ee36ef40df62ec129bee4fdb5ad9706e58a29be53b2c970/aiofiles-25.1.0.tar.gz"
    sha256 "a8d728f0a29de45dc521f18f07297428d56992a742f0cd2701ba86e44d23d5b2"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
  end

  resource "asgi-csrf" do
    url "https://files.pythonhosted.org/packages/0a/59/2b54a274b9c9cbe1c0edbe5d324925ffd88a31567fb50dc2138e0160bdef/asgi_csrf-0.11.tar.gz"
    sha256 "e19a4f87d5af3feabde04c57921ee15510c3bfb0565627df9cb20bcb303282c2"
  end

  resource "asgiref" do
    url "https://files.pythonhosted.org/packages/63/40/f03da1264ae8f7cfdbf9146542e5e7e8100a4c66ab48e791df9a03d3f6c0/asgiref-3.11.1.tar.gz"
    sha256 "5f184dc43b7e763efe848065441eac62229c9f7b0475f41f80e207a114eda4ce"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "flexcache" do
    url "https://files.pythonhosted.org/packages/55/b0/8a21e330561c65653d010ef112bf38f60890051d244ede197ddaa08e50c1/flexcache-0.3.tar.gz"
    sha256 "18743bd5a0621bfe2cf8d519e4c3bfdf57a269c15d1ced3fb4b64e0ff4600656"
  end

  resource "flexparser" do
    url "https://files.pythonhosted.org/packages/82/99/b4de7e39e8eaf8207ba1a8fa2241dd98b2ba72ae6e16960d8351736d8702/flexparser-0.4.tar.gz"
    sha256 "266d98905595be2ccc5da964fe0a2c3526fbbffdc45b65b3146d75db992ef6b2"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "hupper" do
    url "https://files.pythonhosted.org/packages/bd/e6/bb064537288eee2be97f3e0fcad8e7242bc5bbe9664ae57c7d29b3fa18c2/hupper-1.12.1.tar.gz"
    sha256 "06bf54170ff4ecf4c84ad5f188dee3901173ab449c2608ad05b9bfd6b13e32eb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ce/cc/762dfb036166873f0059f3b7de4565e1b5bc3d6f28a414c13da27e442f99/idna-3.13.tar.gz"
    sha256 "585ea8fe5d69b9181ec1afba340451fba6ba764af97026f92a91d4eef164a242"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "janus" do
    url "https://files.pythonhosted.org/packages/d8/7f/69884b6618be4baf6ebcacc716ee8680a842428a19f403db6d1c0bb990aa/janus-2.0.0.tar.gz"
    sha256 "0970f38e0e725400496c834a368a67ee551dc3b5ad0a257e132f5b46f2e77770"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/3a/41/580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270/mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/9f/4a/0883b8e3802965322523f0b200ecf33d31f10991d0401162f4b23c698b42/platformdirs-4.9.6.tar.gz"
    sha256 "3bfa75b0ad0db84096ae777218481852c0ebc6c727b3168c1b9e0118e458cf0a"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/69/9b/f23807317a113dc36e74e75eb265a02dd1a4d9082abc3c1064acd22997c4/python_multipart-0.0.27.tar.gz"
    sha256 "9870a6a8c5a20a5bf4f07c017bd1489006ff8836cff097b6933355ee2b49b602"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/1f/93/041fca8274050e40e6791f267d82e0e2e27dd165627bd640d3e0e378d877/uvicorn-0.46.0.tar.gz"
    sha256 "fb9da0926999cc6cb22dc7cd71a94a632f078e6ae47ff683c5c420750fb7413d"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"datasette", shell_parameter_format: :click)
  end

  test do
    assert_match "15", shell_output("#{bin}/datasette --get '/_memory.json?sql=select+3*5'")
    assert_match "<title>Datasette:", shell_output("#{bin}/datasette --get '/'")
  end
end
