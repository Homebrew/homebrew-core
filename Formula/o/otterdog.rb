class Otterdog < Formula
  include Language::Python::Virtualenv

  desc "Manage GitHub organizations at scale using an infrastructure as code approach"
  homepage "https://otterdog.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/b9/00/7d9570b02427b3e9ca1beb31bb17640290bb11a2eb941653ffef10028ace/otterdog-1.0.4.tar.gz"
  sha256 "6caa83b75c826af27bee96e93f2bcece1385922d0717b767d5be0e8c5f0aea00"
  license "EPL-2.0"
  head "https://github.com/eclipse-csi/otterdog.git", branch: "main"

  # https://github.com/microsoft/playwright-python/issues/2579
  no_autobump! because: "'playwright' resource lacks PyPI sdist"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d6e2674502b6e73dca33248d54514905f60951bd0582f3ac5085c3bc01fb3df9"
    sha256 cellar: :any,                 arm64_sonoma:  "d97abc92f752ec7e3b394c6205a6cb033bc17a07ce6f843da038e31dc0e7ed24"
    sha256 cellar: :any,                 arm64_ventura: "9f5dbe7c5b71e000dbdc332a7b846e535ffd3fe2cbf8103d476142fbc1d1e792"
    sha256 cellar: :any,                 sonoma:        "02f51b42d7ce4249fa6299187a6ca61246be5b573d296fa68e022a6d976f1b75"
    sha256 cellar: :any,                 ventura:       "e85ccf0d9363d8aeee60749b2a582fa83d23ad3ce5da1016657f20e31f718817"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b68419290d6b8f4cbffe254a7e091c26a426d697d685569b21aa10b8bd3ab8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2faee2608164f732b270dedb89bde6693fb8ad3e65a65dca9118d95d6e78f26a"
  end

  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libsodium"
  depends_on "python@3.13"

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/0b/03/a88171e277e8caa88a4c77808c20ebb04ba74cc4681bf1e9416c862de237/aiofiles-24.1.0.tar.gz"
    sha256 "22a075c9e5a3810f0c2e48f3008c94d68c65d763b9b03857924c99e57355166c"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/63/e7/fa1a8c00e2c54b05dc8cb5d1439f627f7c267874e3f7bb047146116020f9/aiohttp-3.11.18.tar.gz"
    sha256 "ae856e1138612b7e412db63b7708735cff4d38d0399f6a5435d3dac2669f558a"
  end

  resource "aiohttp-client-cache" do
    url "https://files.pythonhosted.org/packages/fc/6b/2c09e4a0dd7d8f1b23ad0afac1ebdb200ed59445057f6caca3f653e7510a/aiohttp_client_cache-0.13.0.tar.gz"
    sha256 "dc5cd62340adbee18e0fedc7b0c37542692df08f8ed9945d751b7292a0433853"
  end

  resource "aiohttp-retry" do
    url "https://files.pythonhosted.org/packages/9d/61/ebda4d8e3d8cfa1fd3db0fb428db2dd7461d5742cea35178277ad180b033/aiohttp_retry-2.9.1.tar.gz"
    sha256 "8eb75e904ed4ee5c2ec242fefe85bf04240f685391c4879d8f541d6028ff01f1"
  end

  resource "aioshutil" do
    url "https://files.pythonhosted.org/packages/75/e4/ef86f1777a9bc0c51d50487b471644ae20941afe503591d3a4c86e456dac/aioshutil-1.5.tar.gz"
    sha256 "2756d6cd3bb03405dc7348ac11a0b60eb949ebd63cdd15f56e922410231c1201"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ba/b5/6d55e80f6d8a08ce22b982eafa278d823b541c925f11ee774b0b9c43473d/aiosignal-1.3.2.tar.gz"
    sha256 "a8c255c66fafb1e499c9351d0bf32ff2d8a0321595ebac3b93713656d2436f54"
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/13/7d/8bca2bf9a247c2c5dfeec1d7a5f40db6518f88d314b8bca9da29670d2671/aiosqlite-0.21.0.tar.gz"
    sha256 "131bb8056daa3bc875608c631c678cda73922a2d4ba8aec373b19f18c17e7aa3"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/95/7d/4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840/anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "asyncer" do
    url "https://files.pythonhosted.org/packages/ff/67/7ea59c3e69eaeee42e7fc91a5be67ca5849c8979acac2b920249760c6af2/asyncer-0.0.8.tar.gz"
    sha256 "a589d980f57e20efb07ed91d0dbe67f1d2fd343e7142c66d3a099f05c620739c"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "chevron" do
    url "https://files.pythonhosted.org/packages/15/1f/ca74b65b19798895d63a6e92874162f44233467c9e7c1ed8afd19016ebe9/chevron-0.14.0.tar.gz"
    sha256 "87613aafdf6d77b6a90ff073165a61ae5086e21ad49057aa0e53681601800ebf"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/ee/f4/d744cba2da59b5c1d88823cf9e8a6c74e4659e2b27604ed973be2a0bf5ab/frozenlist-1.6.0.tar.gz"
    sha256 "b99655c32c1c8e06d111e7f41c06c29a5318cb1835df23a45518e02a47c63b68"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/c0/89/37df0b71473153574a5cdef8f242de422a0f5d26d7a9e231e6f169b4ad14/gitpython-3.1.44.tar.gz"
    sha256 "c87e30b26253bf5418b01b0660f818967f3c503193838337fe5e573331249269"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/cf/8c/f834fbf984f691b4f7ff60f50b514cc3de5cc08abfc3295564dd89c5e2e7/importlib_resources-6.5.2.tar.gz"
    sha256 "185f87adef5bcc288449d98fb4fba07cea78bc036455dd44c5fc4a2fe78fed2c"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jsonata-python" do
    url "https://files.pythonhosted.org/packages/ab/d1/9455e5ef09044a550500b32ff276a30f44928ab84b2db9ef13352bffd154/jsonata_python-0.5.3.tar.gz"
    sha256 "c83f45127f8dc45e5ca5f20fd8b8635f094ef6bbb2d203a75bdde11ffece61e2"
  end

  resource "jsonbender" do
    url "https://files.pythonhosted.org/packages/33/ba/b89ab7fb6127eda78e6351568a80cb1e45c5c2c87c3e96df6e6e5a922b43/JSONBender-0.9.3.tar.gz"
    sha256 "54c0503f9e2f9768b113c12ef3d9502da14f0c434853a515cbc9c20e21572538"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/bf/ce/46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914/jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "jwt" do
    url "https://files.pythonhosted.org/packages/ad/66/1e792aef36645b96271b4d27c2a8cc9fc7bbbaf06277a849b9e1a6360e6a/jwt-1.3.1-py3-none-any.whl"
    sha256 "61c9170f92e736b530655e75374681d4fcca9cfa8763ab42be57353b2b203494"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mintotp" do
    url "https://files.pythonhosted.org/packages/c0/b4/126c898d8bdd6d73ee702cf221ab8ddfb8c53db9bc101272542e478eba20/mintotp-0.3.0.tar.gz"
    sha256 "d0f4db5edb38a7481120176a526e8c29539b9e80581dd2dcc1811557d77cfad5"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/91/2f/a3470242707058fe856fe59241eee5635d79087100b7042a867368863a27/multidict-6.4.4.tar.gz"
    sha256 "69ee9e6ba214b5245031b76233dd95408a0fd57fdb019ddcc1ead4790932a8e8"
  end

  resource "playwright" do
    url "https://github.com/microsoft/playwright-python/archive/refs/tags/v1.52.0.tar.gz"
    sha256 "cf21ec7ab8b751f960b9ccfc65272698ef2908c0170459064fbab6152adf863c"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/07/c8/fdc6686a986feae3541ea23dcaa661bd93972d3940460646c6bb96e21c40/propcache-0.3.1.tar.gz"
    sha256 "40d980c33765359098837527e18eddefc9a24cea5b45e078a7f3bb5b032c6ecf"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "rjsonnet" do
    url "https://files.pythonhosted.org/packages/70/65/4c6b1e4baf48ebbc6ff0c8cf8b50f08c63173d9abd5dd7f3af03b4bcd460/rjsonnet-0.5.6.tar.gz"
    sha256 "47bd8f63b4b1def67f83001c07ff7d43d6a90dbf89cb6fb680c941db809a60ce"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/8c/a6/60184b7fc00dd3ca80ac635dd5b8577d444c57e8e8742cecabfacb829921/rpds_py-0.25.1.tar.gz"
    sha256 "8960b6dac09b62dac26e75d7e2c4a22efb835d827a7278c34f72b2b84fa160e3"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/44/cd/a040c4b3119bbe532e5b0732286f805445375489fceaec1f48306068ee3b/smmap-5.0.2.tar.gz"
    sha256 "26ea65a03958fa0c8a1c7e8c7a58fdc77221b8910f6be2131affade476898ad5"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "url-normalize" do
    url "https://files.pythonhosted.org/packages/80/31/febb777441e5fcdaacb4522316bf2a527c44551430a4873b052d545e3279/url_normalize-2.2.1.tar.gz"
    sha256 "74a540a3b6eba1d95bdc610c24f2c0141639f3ba903501e61a52a8730247ff37"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/62/51/c0edba5219027f6eab262e139f73e2417b0f4efffa23bf562f6e18f76ca5/yarl-1.20.0.tar.gz"
    sha256 "686d51e51ee5dfe62dec86e4866ee0e9ed66df700d55c828a615640adc885307"
  end

  def install
    # The source doesn't have a valid SOURCE_DATE_EPOCH, so here we set default.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION_FOR_PLAYWRIGHT"] = resource("playwright").version
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"otterdog", shell_parameter_format: :click, shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/otterdog --version")

    assert_match "File 'otterdog.json' does not exist", shell_output("#{bin}/otterdog validate 2>&1", 2)
  end
end
