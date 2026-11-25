class Ggshield < Formula
  include Language::Python::Virtualenv

  desc "Scanner for secrets and sensitive data in code"
  homepage "https://www.gitguardian.com"
  url "https://files.pythonhosted.org/packages/b5/59/22f4c0326f9d82b6d6149dc76d08768a2f3d03b5335e43017f6a6b267cc3/ggshield-1.57.0.tar.gz"
  sha256 "dec40be023a1c763c4df3da274b482e2280a243e10206a7f3f068e421e6c188c"
  license "MIT"
  head "https://github.com/GitGuardian/ggshield.git", branch: "main"

  bottle do
    manifest_sha256 "524716afc0c82304664a14d1f37a5c9b2fc073bce6478a80b1791483b68e2418"
    sha256 cellar: :any, arm64_golden_gate: "b802f40daf9d2eb1d034e0e59ed7ba7b6c97305be8bfa5bf6092efa4524a22ae"
    sha256 cellar: :any, arm64_tahoe:       "8236029dc2e5adc291cf32bf63dde87aec7e8d32377a1fa41d3ab90ab920f7d3"
    sha256 cellar: :any, arm64_sequoia:     "da41a9cabde800a88a8f30d3286759945738104812905471e86414712f2018d6"
    sha256 cellar: :any, arm64_linux:       "4956777fcf9c3f78a10a6091f94947bfbce08676948bdbb78a8483142811898f"
    sha256 cellar: :any, x86_64_linux:      "31c7072f2d102134624c1bc8233ce15566ddea59eec746b8f3dcf3e0cb3ac53e"
  end

  depends_on "pkgconf" => :build # for `rfc3161_client`
  depends_on "rust" => :build # for `rfc3161_client`
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "openssl@4"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"

  pypi_packages exclude_packages: %w[certifi cryptography pydantic],
                extra_packages:   %w[jeepney secretstorage]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "configupdater" do
    url "https://files.pythonhosted.org/packages/2b/f4/603bd8a65e040b23d25b5843836297b0f4e430f509d8ed2ef8f072fb4127/ConfigUpdater-3.2.tar.gz"
    sha256 "9fdac53831c1b062929bf398b649b87ca30e7f1a735f3fbf482072804106306b"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/76/49/900383b471c645a3c397f47b3211d1fcecb3a540c98f683494cdf86b33de/dnspython-2.9.2.tar.gz"
    sha256 "8d4d39a513e649d634004ce4d39ade2352efcea472a0247535a5c2d18a9d7ba9"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/c0/4d/f5e9d9de19f4b8f9e33d802fe3efb0ef96e88d4d6d45d604f335bef2f1ef/email_validator-2.4.0.tar.gz"
    sha256 "be487bc50bc3bd832a98515a55a15649d9bec06d954fa178663190714b6c4ee1"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/e6/86/a5b9ec254b90efb180e390e31a4fa50a93b714d6e4174fa9a4ee25607159/filelock-4.3.1.tar.gz"
    sha256 "4c5ee627c401f1863ac6a0de9a14a28d3bb5f8c730b45e2fd6e5dbc79cf34b9e"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/92/9d/df40b41f7db0370f82019820709244e7b660c52aa3da3c9e5c4e8141f6e6/httpcore2-2.16.2.tar.gz"
    sha256 "6c519d0f7b44f7269fa9bbb4d2763db395a4a2370f046d8e8e0a4b38227815d2"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/1c/77/6515121dc5ac3c743ad1bff5afe635bcd1a3f23cc40db3c5c89f7d02917d/httpx2-2.16.2.tar.gz"
    sha256 "748b615678f07d8e3b183efe81ad13b655ca88bfc56ce4589219b2d442860574"
  end

  resource "id" do
    url "https://files.pythonhosted.org/packages/6d/04/c2156091427636080787aac190019dc64096e56a23b7364d3c1764ee3a06/id-1.6.1.tar.gz"
    sha256 "d0732d624fb46fd4e7bc4e5152f00214450953b9e772c182c1c22964def1a069"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/af/50/4763cd07e722bb6285316d390a164bc7e479db9d90daa769f22578f698b4/jaraco_context-6.1.2.tar.gz"
    sha256 "f1a6c9d391e661cc5b8d39861ff077a7dc24dc23833ccee564b234b81c82dfe3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/6c/1f/c23395957d41ccf27c4e535c3d334c4051e5395b3752057ba4cbaec35c56/jaraco_functools-4.6.0.tar.gz"
    sha256 "880c577ec9720b3a052d5bc611fb9f2269b3d87902ef42440df443b88e443280"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "loguru" do
    url "https://files.pythonhosted.org/packages/75/1f/d3818863e4be96bd641c4643c535a98f0fa2a12efa7c8ba35f763fa778ee/loguru-0.6.0.tar.gz"
    sha256 "066bd06758d0a513e9836fd9c6b5a75bfb3fd36841f4b996bc60b547a309d41c"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/16/fc/cee2c45553c9a9bf77d8b0c391560c556d7ed756b1f0bb35eb5d48db09ea/markdown_it_py-4.3.0.tar.gz"
    sha256 "91a58fa5b72c71a40cf7177250fd767480d7a2bb3ac426ccfb76fb90305fdaaa"
  end

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/0d/3e/2b75ae631789fc13191ab82bc08957af381c00fffc5fefc6248b719bc9d2/marshmallow-4.4.0.tar.gz"
    sha256 "9e6ffa8511012ca89732324c1c253efd7b4d35632dcbdf80aa793fe01804af3e"
  end

  resource "marshmallow-dataclass" do
    url "https://files.pythonhosted.org/packages/01/23/a863a5d569f03454d733f884a72415ac3f1e1b1b3215de3a9f4f621a83a6/marshmallow_dataclass-8.7.1.tar.gz"
    sha256 "4fb80e1bf7b31ce1b192aa87ffadee2cedb3f6f37bb0042f8500b07e6fad59c4"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/52/b8/c63995bebbb9ac9c059350e0fb8c82c2420c85aeca7d34e40aecf3df9281/more_itertools-11.2.1.tar.gz"
    sha256 "cbf08fd0af284dc69718b9b76a8e6203df624d70209ea511e4219d350c856f63"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/d0/6f/43edf3be2748d0e40974a5ee046a8bb4c9961a4bdd3e7d5c6dcbf32d1af6/mypy_extensions-1.2.0.tar.gz"
    sha256 "c6e275a07f1c2fc096b62940452d0eaa3f3af7de45d704787866240a7c6d5a51"
  end

  resource "notify-py" do
    url "https://files.pythonhosted.org/packages/06/2b/fc68aeed5108185922c5469484e15c192dff01d61eddfab0c1c256e4f54c/notify_py-0.3.43.tar.gz"
    sha256 "16ee146d48f16bae5dad233db66014a387efd2c6ed2c4caf1e08aef432070513"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/33/17/2bb072de0b990303c985f26869fd47bb179024a051f47e7f9d208eb92f8e/oauthlib-4.0.1.tar.gz"
    sha256 "3d73febdb6faa00f277c81fb04be7b7586fb96fc3b7f0b9c772dada69a25ede7"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c3/75/ffb1dc0ed12352139fb4ca0e3fde4325a23e3d0f3f40efe89717bc4f557b/packaging-26.4.tar.gz"
    sha256 "c4b671c41ddb9bf26e543c37723610d28fb6bf7affc4da17cf048d419d2c062a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/71/18/0b0d99f5bf164f04a7a9534c3dbdbe4d5fd2b382667685ad40c192c4d3d1/platformdirs-4.14.8.tar.gz"
    sha256 "96893d686e84e9e6f358a9ea41a8de544df66dbf2ba6cda250e7dc73acf85b9b"
  end

  resource "pygitguardian" do
    url "https://files.pythonhosted.org/packages/02/44/34009805f24d266618eec3a02ef8e21127f2918ccf7ac56e93c6698f9ffc/pygitguardian-1.36.0.tar.gz"
    sha256 "081aa7ed2c2c33be24be052e0fea5b55a7098d34aefe45c1fdbfa6ad6c0d5a49"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/43/ea/5194e52748b0da83d71e082d75496eaec6e58f419f5e184786ded517e6a9/pyjwt-2.15.1.tar.gz"
    sha256 "4f259e80cdfb6b3fc18a7de51fd1ef9ec79652f25019bae68975ca2468a34df8"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/74/26/2fbeedb218a787a5eea551c7532cac4e009f83d689dd2faa0d0353473f86/python_dotenv-1.2.4.tar.gz"
    sha256 "f0d53e69935a851c0dcc78f3ab7aaccd8cabef0b92382b576b824212902873c0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/76/b8/c0b780928e2fb1c87e9e375818c6f121da2398b071012d1747be300b83f4/pyyaml-6.0.4.tar.gz"
    sha256 "e24bf71af8a432d7808fabff134d38dfe16d3cbb41f2873bb4b1e42422de0a1a"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rfc3161-client" do
    url "https://files.pythonhosted.org/packages/56/53/e2f526fb6957023180c928448e2dd71b03b35038c315aed2d12d9a77c3af/rfc3161_client-1.0.9.tar.gz"
    sha256 "66997415086d2c6e5d57a2d315157b32a9c3f4f1312877ca8eb55e2e0ddf8ce4"
  end

  resource "rfc8785" do
    url "https://files.pythonhosted.org/packages/ef/2f/fa1d2e740c490191b572d33dbca5daa180cb423c24396b856f5886371d8b/rfc8785-0.1.4.tar.gz"
    sha256 "e545841329fe0eee4f6a3b44e7034343100c12b4ec566dc06ca9735681deb4da"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "securesystemslib" do
    url "https://files.pythonhosted.org/packages/6c/b7/68ce74b4c3ab753c2de907d035a4102b4510729393184af3c7bdfee04d18/securesystemslib-1.6.0.tar.gz"
    sha256 "b16e07c32bb41174c2ee2fb18f478ebe0d52e0e7c1fb085ce89c990452a35977"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
  end

  resource "sigstore" do
    url "https://files.pythonhosted.org/packages/11/10/349d460d275dccade8d5aa29e15290a7febb0c0bdeab8f2cd9d0ee61d9db/sigstore-4.6.0.tar.gz"
    sha256 "dc9a7bd0e35ee381a6f70281f520f858d12b34a997c023f7dec835c0095a5067"
  end

  resource "sigstore-models" do
    url "https://files.pythonhosted.org/packages/c6/ed/5c0ff809f90b19f4e971e17c1ed11f4df60082c6010b32a82054087e91e0/sigstore_models-0.0.6.tar.gz"
    sha256 "c766c09470c2a7e8a4a333c893f07e2001c56a3ff1757b1a246119f53169a849"
  end

  resource "sigstore-rekor-types" do
    url "https://files.pythonhosted.org/packages/b4/54/102e772445c5e849b826fbdcd44eb9ad7b3d10fda17b08964658ec7027dc/sigstore_rekor_types-0.0.18.tar.gz"
    sha256 "19aef25433218ebf9975a1e8b523cc84aaf3cd395ad39a30523b083ea7917ec5"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/c9/85/4a7c68111c057a6498f5bc721ef93b388b420bb31d7020759f18a5f0c2ec/tomlkit-0.15.3.tar.gz"
    sha256 "b3c3020ec1a4bd469d12e31fb4da938e7f6ba758cdbec3fd9047db63120eaf81"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/ee/9f/c5201d42a484c061e528825fc8e2d565f5abd50a4ced6fb7d29c4ec99b2b/truststore-0.10.5.tar.gz"
    sha256 "30d36967ccaded5cbb38d602c433f53600036c79d502f4533a49b60a03bbefcd"
  end

  resource "tuf" do
    url "https://files.pythonhosted.org/packages/9c/dd/52e7390cbac308e6b1cfe6be9bc3a96fe26326d5893cc297a52bb72792a9/tuf-7.0.1.tar.gz"
    sha256 "5ada1db78da3518fa851e28588f4b2249b8662a28ae528f54afa2a1de541fb31"
  end

  resource "typeguard" do
    url "https://files.pythonhosted.org/packages/67/2e/ff27b371f3262048aa7b2a391f655a333e75a7774a920d5fc9e257a47991/typeguard-4.6.1.tar.gz"
    sha256 "d94fd3552c5feb6bada6e8bb1167d9916c08d7442141aeb041b847ba9bd1afb1"
  end

  resource "typing-inspect" do
    url "https://files.pythonhosted.org/packages/dc/74/1789779d91f1961fa9438e9a8710cdae6bd138c80d7303996933d117264a/typing_inspect-0.9.0.tar.gz"
    sha256 "b23fc42ff6f6ef6954e4852c1fb512cdd18dbea03134f91f856a95ccc9461f78"
  end

  resource "unearth" do
    url "https://files.pythonhosted.org/packages/37/84/fb5929b8ce02c57b266abf4fbba6fb561649b024e3268a3625820de872dd/unearth-0.19.0.tar.gz"
    sha256 "d85a7b164833c1dc8532a590043cbd7159f6ad2b91fc3e74f2a16ff25ed098c8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    without = %w[jeepney secretstorage] unless OS.linux?
    venv = virtualenv_install_with_resources(without:)

    generate_completions_from_executable(bin/"ggshield", shell_parameter_format: :click)

    # FIXME: try building app from source. Currently removing as it is pre-built app. Also lacks arm64 support
    rm_r venv.site_packages/"notifypy/os_notifiers/binaries" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggshield --version")

    ENV["GITGUARDIAN_API_KEY"] = "test"
    output = shell_output("#{bin}/ggshield api-status")
    assert_match "unhealthy (Invalid API key.)", output
  end
end
