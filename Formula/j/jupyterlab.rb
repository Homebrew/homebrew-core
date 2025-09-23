class Jupyterlab < Formula
  include Language::Python::Virtualenv

  desc "Interactive environments for writing and running code"
  homepage "https://jupyter.org/"
  url "https://files.pythonhosted.org/packages/d0/07/b3beaeb5722d4a55e345a38884c67baebd9cec2269c5309ce494485a5858/jupyterlab-4.4.7.tar.gz"
  sha256 "8c8e225492f4513ebde9bbbc00a05b651ab9a1f5b0013015d96fabf671c37188"
  license all_of: [
    "BSD-3-Clause",
    "MIT", # semver.py
  ]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d9c7742c58784dd89e469bf5f987c1984bba9cb9408cfe7f58710b910cab446d"
    sha256 cellar: :any,                 arm64_sequoia: "0ac11a447d57d7fbcc355e29b95ee20a3681f6d6b81ef0247ba65b4b085ef477"
    sha256 cellar: :any,                 arm64_sonoma:  "425baffc27be9e00d30708e6e883f0d193e57b8e50015e1c8c442a28e0325836"
    sha256 cellar: :any,                 arm64_ventura: "95887a5c714f12ed948c070c065db9ac45fd702e54fce0686d87cbd995b18574"
    sha256 cellar: :any,                 sonoma:        "d63663d7cc00bdeec6c6cd3d13f1768b05d88c7ddcfac078e29a78cd9e72c446"
    sha256 cellar: :any,                 ventura:       "b0833b556d1aced4322ee3cf186d31da58ef39d1fd8fc7d13d779791db62a913"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ed510a5c445d3de3d1336a180d736ffff40ce408b5f48686c827cbd48d4efb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b801b9c168fe0220f378d24cd2a84110b24bb4fe89a1ca1ac42a55384f2c2954"
  end

  depends_on "cmake" => :build # for ipykernel
  depends_on "ninja" => :build # for ipykernel
  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "node"
  depends_on "pandoc"
  depends_on "python@3.13"
  depends_on "zeromq"

  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/f1/b4/636b3b65173d3ce9a38ef5f0522789614e590dab6a8d505340a4efe4c567/anyio-4.10.0.tar.gz"
    sha256 "3f3fae35c96039744587aa5b8371e7e8e603c0702999535961dd336026973ba6"
  end

  resource "appnope" do
    url "https://files.pythonhosted.org/packages/35/5d/752690df9ef5b76e169e68d6a129fa6d08a7100ca7f754c89495db3c6019/appnope-0.1.4.tar.gz"
    sha256 "1de3860566df9caf38f01f86f65e0e13e379af54f9e4bee1e66b48f2efffd1ee"
  end

  resource "argon2-cffi" do
    url "https://files.pythonhosted.org/packages/0e/89/ce5af8a7d472a67cc819d5d998aa8c82c5d860608c4db9f46f1162d7dab9/argon2_cffi-25.1.0.tar.gz"
    sha256 "694ae5cc8a42f4c4e2bf2ca0e64e51e23a040c6a517a85074683d3959e1346c1"
  end

  resource "argon2-cffi-bindings" do
    url "https://files.pythonhosted.org/packages/5c/2d/db8af0df73c1cf454f71b2bbe5e356b8c1f8041c979f505b3d3186e520a9/argon2_cffi_bindings-25.1.0.tar.gz"
    sha256 "b957f3e6ea4d55d820e40ff76f450952807013d361a65d7f28acc0acbf29229d"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/2e/00/0f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173/arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "asttokens" do
    url "https://files.pythonhosted.org/packages/4a/e7/82da0a03e7ba5141f05cce0d302e6eed121ae055e0456ca228bf693984bc/asttokens-3.0.0.tar.gz"
    sha256 "0dcd8baa8d62b0c1d118b399b2ddba3c4aff271d0d7a9e0d4c1681c79035bbc7"
  end

  resource "async-lru" do
    url "https://files.pythonhosted.org/packages/b2/4d/71ec4d3939dc755264f680f6c2b4906423a304c3d18e96853f0a595dfe97/async_lru-2.0.5.tar.gz"
    sha256 "481d52ccdd27275f42c43a928b4a50c3bfb2d67af4e78b170e3e0bb39c66e5bb"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "babel" do
    url "https://files.pythonhosted.org/packages/7d/6b/d52e42361e1aa00709585ecc30b3f9684b3ab62530771402248b1b1d6240/babel-2.17.0.tar.gz"
    sha256 "0c54cffb19f690cdcc52a3b50bcbf71e07a808d1c80d549f2459b9d2cf0afb9d"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/85/2e/3e5079847e653b1f6dc647aa24549d68c6addb4c595cc0d902d1b19308ad/beautifulsoup4-4.13.5.tar.gz"
    sha256 "5e70131382930e7c3de33450a2f54a63d5e4b19386eab43a5b34d594268f3695"
  end

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/76/9a/0e33f5054c54d349ea62c277191c020c2d6ef1d65ab2cb1993f91ec846d1/bleach-6.2.0.tar.gz"
    sha256 "123e894118b8a599fd80d3ec1a6d4cc7ce4e5882b1317a7e1ba69b56e95f991f"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/fc/97/c783634659c2920c3fc70419e3af40972dbaf758daa229a7d6ea6135c90d/cffi-1.17.1.tar.gz"
    sha256 "1c39c6016c32bc48dd54561950ebd6836e1670f2ae46128f67cf49e789c52824"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "comm" do
    url "https://files.pythonhosted.org/packages/4c/13/7d740c5849255756bc17888787313b61fd38a0a8304fc4f073dfc46122aa/comm-0.2.3.tar.gz"
    sha256 "2dc8048c10962d55d7ad693be1e7045d891b7ce8d999c97963a5e3e99c055971"
  end

  resource "debugpy" do
    url "https://files.pythonhosted.org/packages/ca/d4/722d0bcc7986172ac2ef3c979ad56a1030e3afd44ced136d45f8142b1f4a/debugpy-1.8.16.tar.gz"
    sha256 "31e69a1feb1cf6b51efbed3f6c9b0ef03bc46ff050679c4be7ea6d2e23540870"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/43/fa/6d96a0978d19e17b68d634497769987b16c8f4cd0a7a05048bec693caa6b/decorator-5.2.1.tar.gz"
    sha256 "65f266143752f734b0a7cc83c46f4618af75b8c5911b00ccb61d0ac9b6da0360"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "executing" do
    url "https://files.pythonhosted.org/packages/cc/28/c14e053b6762b1044f34a13aab6859bbf40456d37d23aa286ac24cfd9a5d/executing-2.2.1.tar.gz"
    sha256 "3632cc370565f6648cc328b32435bd120a1e4ebb20c77e3fdde9a13cd1e533c4"
  end

  resource "fastjsonschema" do
    url "https://files.pythonhosted.org/packages/20/b5/23b216d9d985a956623b6bd12d4086b60f0059b27799f23016af04a74ea1/fastjsonschema-2.21.2.tar.gz"
    sha256 "b1eb43748041c880796cd077f1a07c3d94e93ae84bba5ed36800a33554ae05de"
  end

  resource "fqdn" do
    url "https://files.pythonhosted.org/packages/30/3e/a80a8c077fd798951169626cde3e239adeba7dab75deb3555716415bd9b0/fqdn-1.5.1.tar.gz"
    sha256 "105ed3677e767fb5ca086a0c1f4bb66ebc3c100be518f0e0d755d9eae164d89f"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hatch-jupyter-builder" do
    url "https://files.pythonhosted.org/packages/5b/f6/8c8b353e7c6476ca28caea0408b0a3778d8849cda16f3e8e8f3145162dae/hatch_jupyter_builder-0.9.1.tar.gz"
    sha256 "79278198d124c646b799c5e8dca8504aed9dcaaa88d071a09eb0b5c2009a58ad"
  end

  resource "hatch-nodejs-version" do
    url "https://files.pythonhosted.org/packages/19/c9/1823a9e45eadd487bece8f2b3b29311edd79ba900d874885b1e9f7973a50/hatch_nodejs_version-0.4.0.tar.gz"
    sha256 "2428ea398dd053f019d2b7ac949dd6b690ca8e826b6d433ad13c5b6c475ae91b"
  end

  resource "hatchling" do
    url "https://files.pythonhosted.org/packages/8f/8a/cc1debe3514da292094f1c3a700e4ca25442489731ef7c0814358816bb03/hatchling-1.27.0.tar.gz"
    sha256 "971c296d9819abb3811112fc52c7a9751c8d381898f36533bb16f9791e941fd6"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "ipykernel" do
    url "https://files.pythonhosted.org/packages/bb/76/11082e338e0daadc89c8ff866185de11daf67d181901038f9e139d109761/ipykernel-6.30.1.tar.gz"
    sha256 "6abb270161896402e76b91394fcdce5d1be5d45f456671e5080572f8505be39b"
  end

  resource "ipython" do
    url "https://files.pythonhosted.org/packages/6e/71/a86262bf5a68bf211bcc71fe302af7e05f18a2852fdc610a854d20d085e6/ipython-9.5.0.tar.gz"
    sha256 "129c44b941fe6d9b82d36fc7a7c18127ddb1d6f02f78f867f402e2e3adde3113"
  end

  resource "ipython-pygments-lexers" do
    url "https://files.pythonhosted.org/packages/ef/4c/5dd1d8af08107f88c7f741ead7a40854b8ac24ddf9ae850afbcf698aa552/ipython_pygments_lexers-1.1.1.tar.gz"
    sha256 "09c0138009e56b6854f9535736f4171d855c8c08a563a0dcd8022f78355c7e81"
  end

  resource "isoduration" do
    url "https://files.pythonhosted.org/packages/7c/1a/3c8edc664e06e6bd06cce40c6b22da5f1429aa4224d0c590f3be21c91ead/isoduration-20.11.0.tar.gz"
    sha256 "ac2f9015137935279eac671f94f89eb00584f940f5dc49462a0c4ee692ba1bd9"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/72/3a/79a912fbd4d8dd6fbb02bf69afd3bb72cf0c729bb3063c6f4498603db17a/jedi-0.19.2.tar.gz"
    sha256 "4770dc3de41bde3966b02eb84fbcf557fb33cce26ad23da12c742fb50ecb11f0"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "json5" do
    url "https://files.pythonhosted.org/packages/12/ae/929aee9619e9eba9015207a9d2c1c54db18311da7eb4dcf6d41ad6f0eb67/json5-0.12.1.tar.gz"
    sha256 "b2743e77b3242f8d03c143dd975a6ec7c52e2f2afe76ed934e53503dd4ad4990"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/6a/0a/eebeb1fa92507ea94016a2a790b93c2ae41a7e18778f85471dc54475ed25/jsonpointer-3.0.0.tar.gz"
    sha256 "2b2d729f2091522d61c3b31f82e11870f60b68f43fbc705cb76bf4b832af59ef"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/bf/ce/46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914/jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "jupyter-client" do
    url "https://files.pythonhosted.org/packages/71/22/bf9f12fdaeae18019a468b68952a60fe6dbab5d67cd2a103cac7659b41ca/jupyter_client-8.6.3.tar.gz"
    sha256 "35b3a0947c4a6e9d589eb97d7d4cd5e90f910ee73101611f01283732bd6d9419"
  end

  resource "jupyter-console" do
    url "https://files.pythonhosted.org/packages/bd/2d/e2fd31e2fc41c14e2bcb6c976ab732597e907523f6b2420305f9fc7fdbdb/jupyter_console-6.6.3.tar.gz"
    sha256 "566a4bf31c87adbfadf22cdf846e3069b59a71ed5da71d6ba4d8aaad14a53539"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/99/1b/72906d554acfeb588332eaaa6f61577705e9ec752ddb486f302dafa292d9/jupyter_core-5.8.1.tar.gz"
    sha256 "0a5f9706f70e64786b75acba995988915ebd4601c8a52e534a40b51c95f59941"
  end

  resource "jupyter-events" do
    url "https://files.pythonhosted.org/packages/9d/c3/306d090461e4cf3cd91eceaff84bede12a8e52cd821c2d20c9a4fd728385/jupyter_events-0.12.0.tar.gz"
    sha256 "fc3fce98865f6784c9cd0a56a20644fc6098f21c8c33834a8d9fe383c17e554b"
  end

  resource "jupyter-lsp" do
    url "https://files.pythonhosted.org/packages/eb/5a/9066c9f8e94ee517133cd98dba393459a16cd48bba71a82f16a65415206c/jupyter_lsp-2.3.0.tar.gz"
    sha256 "458aa59339dc868fb784d73364f17dbce8836e906cd75fd471a325cba02e0245"
  end

  resource "jupyter-server" do
    url "https://files.pythonhosted.org/packages/5b/ac/e040ec363d7b6b1f11304cc9f209dac4517ece5d5e01821366b924a64a50/jupyter_server-2.17.0.tar.gz"
    sha256 "c38ea898566964c888b4772ae1ed58eca84592e88251d2cfc4d171f81f7e99d5"
  end

  resource "jupyter-server-terminals" do
    url "https://files.pythonhosted.org/packages/fc/d5/562469734f476159e99a55426d697cbf8e7eb5efe89fb0e0b4f83a3d3459/jupyter_server_terminals-0.5.3.tar.gz"
    sha256 "5ae0295167220e9ace0edcfdb212afd2b01ee8d179fe6f23c899590e9b8a5269"
  end

  resource "jupyterlab-pygments" do
    url "https://files.pythonhosted.org/packages/90/51/9187be60d989df97f5f0aba133fa54e7300f17616e065d1ada7d7646b6d6/jupyterlab_pygments-0.3.0.tar.gz"
    sha256 "721aca4d9029252b11cfa9d185e5b5af4d54772bb8072f9b7036f4170054d35d"
  end

  resource "jupyterlab-server" do
    url "https://files.pythonhosted.org/packages/0a/c9/a883ce65eb27905ce77ace410d83587c82ea64dc85a48d1f7ed52bcfa68d/jupyterlab_server-2.27.3.tar.gz"
    sha256 "eb36caca59e74471988f0ae25c77945610b887f777255aa21f8065def9e51ed4"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/af/60/bc7622aefb2aee1c0b4ba23c1446d3e30225c8770b38d7aedbfb65ca9d5a/lark-1.2.2.tar.gz"
    sha256 "ca807d0162cd16cef15a8feecb862d7319e7a09bdb13aef927968e45040fed80"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "matplotlib-inline" do
    url "https://files.pythonhosted.org/packages/99/5b/a36a337438a14116b16480db471ad061c36c3694df7c2084a0da7ba538b7/matplotlib_inline-0.1.7.tar.gz"
    sha256 "8423b23ec666be3d16e16b60bdd8ac4e86e840ebd1dd11a30b9f117f2fa0ab90"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/d7/02/a7fb8b21d4d55ac93cdcde9d3638da5dd0ebdd3a4fed76c7725e10b81cbe/mistune-3.1.4.tar.gz"
    sha256 "b5a7f801d389f724ec702840c11d8fc48f2b33519102fc7ee739e8177b672164"
  end

  resource "nbclient" do
    url "https://files.pythonhosted.org/packages/87/66/7ffd18d58eae90d5721f9f39212327695b749e23ad44b3881744eaf4d9e8/nbclient-0.10.2.tar.gz"
    sha256 "90b7fc6b810630db87a6d0c2250b1f0ab4cf4d3c27a299b0cde78a4ed3fd9193"
  end

  resource "nbconvert" do
    url "https://files.pythonhosted.org/packages/a3/59/f28e15fc47ffb73af68a8d9b47367a8630d76e97ae85ad18271b9db96fdf/nbconvert-7.16.6.tar.gz"
    sha256 "576a7e37c6480da7b8465eefa66c17844243816ce1ccc372633c6b71c3c0f582"
  end

  resource "nbformat" do
    url "https://files.pythonhosted.org/packages/6d/fd/91545e604bc3dad7dca9ed03284086039b294c6b3d75c0d2fa45f9e9caf3/nbformat-5.10.4.tar.gz"
    sha256 "322168b14f937a5d11362988ecac2a4952d3d8e3a2cbeb2319584631226d5b3a"
  end

  resource "nest-asyncio" do
    url "https://files.pythonhosted.org/packages/83/f8/51569ac65d696c8ecbee95938f89d4abf00f47d58d48f6fbabfe8f0baefe/nest_asyncio-1.6.0.tar.gz"
    sha256 "6f172d5449aca15afd6c646851f4e31e02c598d553a667e38cafa997cfec55fe"
  end

  resource "notebook" do
    url "https://files.pythonhosted.org/packages/9f/21/9669982f9569e7478763837e0d35b9fd9f43de0eb5ab5d6ca620b8019cfc/notebook-7.4.5.tar.gz"
    sha256 "7c2c4ea245913c3ad8ab3e5d36b34a842c06e524556f5c2e1f5d7d08c986615e"
  end

  resource "notebook-shim" do
    url "https://files.pythonhosted.org/packages/54/d2/92fa3243712b9a3e8bafaf60aac366da1cada3639ca767ff4b5b3654ec28/notebook_shim-0.2.4.tar.gz"
    sha256 "b4b2cfa1b65d98307ca24361f5b30fe785b53c3fd07b7a47e89acb5e6ac638cb"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pandocfilters" do
    url "https://files.pythonhosted.org/packages/70/6f/3dd4940bbe001c06a65f88e36bad298bc7a0de5036115639926b0c5c0458/pandocfilters-1.5.1.tar.gz"
    sha256 "002b4a555ee4ebc03f8b66307e287fa492e4a77b4ea14d3f934328297bb4939e"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/d4/de/53e0bcf53d13e005bd8c92e7855142494f41171b34c2536b86187474184d/parso-0.8.5.tar.gz"
    sha256 "034d7354a9a018bdce352f48b2a8a450f05e9d6ee85db84764e9b6bd96dafe5a"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/42/92/cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149d/pexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/23/e8/21db9c9987b0e728855bd57bff6984f67952bea55d6f75e055c46b5383e8/platformdirs-4.4.0.tar.gz"
    sha256 "ca753cf4d81dc309bc67b0ea38fd15dc97bc30ce419a7f58d13eb3bf14c4febf"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/5e/cf/40dde0a2be27cc1eb41e333d1a674a74ce8b8b0457269cc640fd42b07cf7/prometheus_client-0.22.1.tar.gz"
    sha256 "190f1331e783cf21eb60bca559354e0a4d4378facecf78f5428c39b675d20d28"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pure-eval" do
    url "https://files.pythonhosted.org/packages/cd/05/0a34433a064256a578f1783a10da6df098ceaa4a57bbeaa96a6c0352786b/pure_eval-0.2.3.tar.gz"
    sha256 "5f4e983f40564c576c7c8635ae88db5956bb2229d7e9237d03b3c0b0190eaf42"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1d/b2/31537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52c/pycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-json-logger" do
    url "https://files.pythonhosted.org/packages/9e/de/d3144a0bceede957f961e975f3752760fbe390d57fbe194baf709d8f1f7b/python_json_logger-3.3.0.tar.gz"
    sha256 "12b7e74b17775e7d565129296105bbe3910842d9d0eb083fc83a6a617aa8df84"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/f8/66/159f38d184f08b5f971b467f87b1ab142ab1320d5200825c824b32b84b66/pyzmq-27.0.2.tar.gz"
    sha256 "b398dd713b18de89730447347e96a0240225e154db56e35b6bb8447ffdb07798"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rfc3339-validator" do
    url "https://files.pythonhosted.org/packages/28/ea/a9387748e2d111c3c2b275ba970b735e04e15cdb1eb30693b6b5708c4dbd/rfc3339_validator-0.1.4.tar.gz"
    sha256 "138a2abdf93304ad60530167e51d2dfb9549521a836871b88d7f4695d0022f6b"
  end

  resource "rfc3986-validator" do
    url "https://files.pythonhosted.org/packages/da/88/f270de456dd7d11dcc808abfa291ecdd3f45ff44e3b549ffa01b126464d0/rfc3986_validator-0.1.1.tar.gz"
    sha256 "3d44bde7921b3b9ec3ae4e3adca370438eccebc676456449b145d533b240d055"
  end

  resource "rfc3987-syntax" do
    url "https://files.pythonhosted.org/packages/2c/06/37c1a5557acf449e8e406a830a05bf885ac47d33270aec454ef78675008d/rfc3987_syntax-1.1.0.tar.gz"
    sha256 "717a62cbf33cffdd16dfa3a497d81ce48a660ea691b1ddd7be710c22f00b4a0d"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/e9/dd/2c0cbe774744272b0ae725f44032c77bdcab6e8bcf544bffa3b6e70c8dba/rpds_py-0.27.1.tar.gz"
    sha256 "26a1c73171d10b7acccbded82bf6a586ab8203601e565badc74bbbf8bc5a10f8"
  end

  resource "send2trash" do
    url "https://files.pythonhosted.org/packages/fd/3a/aec9b02217bb79b87bbc1a21bc6abc51e3d5dcf65c30487ac96c0908c722/Send2Trash-1.8.3.tar.gz"
    sha256 "b18e7a3966d99871aefeb00cfbcfdced55ce4871194810fc71f4aa484b953abf"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/6d/e6/21ccce3262dd4889aa3332e5a119a3491a95e8f60939870a3a035aabac0d/soupsieve-2.8.tar.gz"
    sha256 "e2dd4a40a628cb5f28f6d4b0db8800b8f581b65bb380b97de22ba5ca8d72572f"
  end

  resource "stack-data" do
    url "https://files.pythonhosted.org/packages/28/e3/55dcc2cfbc3ca9c29519eb6884dd1415ecb53b0e934862d3559ddcb7e20b/stack_data-0.6.3.tar.gz"
    sha256 "836a778de4fec4dcd1dcd89ed8abff8a221f58308462e1c4aa2a3cf30148f0b9"
  end

  resource "terminado" do
    url "https://files.pythonhosted.org/packages/8a/11/965c6fd8e5cc254f1fe142d547387da17a8ebfd75a3455f637c663fb38a0/terminado-0.18.1.tar.gz"
    sha256 "de09f2c4b85de4765f7714688fff57d3e75bad1f909b589fde880460c753fd2e"
  end

  resource "tinycss2" do
    url "https://files.pythonhosted.org/packages/7a/fd/7a5ee21fd08ff70d3d33a5781c255cbe779659bd03278feb98b19ee550f4/tinycss2-1.4.0.tar.gz"
    sha256 "10c0972f6fc0fbee87c3edb76549357415e94548c1ae10ebccdea16fb404a9b7"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/09/ce/1eb500eae19f4648281bb2186927bb062d2438c2e5093d1360391afd2f90/tornado-6.5.2.tar.gz"
    sha256 "ab53c8f9a0fa351e2c0741284e06c7a45da86afb544133201c5cc8578eb076a0"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/eb/79/72064e6a701c2183016abbbfedaba506d81e30e232a68c9f0d6f6fcd1574/traitlets-5.14.3.tar.gz"
    sha256 "9ed0579d3502c94b4b3732ac120375cda96f923114522847de4b3bb98b96b6b7"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/f7/7c/78ea329adc8be4353f9ef8ee5b7498450fcbd1a02fed6cd444344eb0bf63/trove_classifiers-2025.8.26.11.tar.gz"
    sha256 "e73efff317c492a7990092f9c12676c705bf6cfe40a258a93f63f4b4c9941432"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/0c/0a/775f8551665992204c756be326f3575abba58c4a3a52eef9909ef4536428/types_python_dateutil-2.9.0.20250822.tar.gz"
    sha256 "84c92c34bd8e68b117bff742bc00b692a1e8531262d4507b33afcc9f7716cd53"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "uri-template" do
    url "https://files.pythonhosted.org/packages/31/c7/0336f2bd0bcbada6ccef7aaa25e443c118a704f828a0620c6fa0207c1b64/uri-template-1.3.0.tar.gz"
    sha256 "0e00f8eb65e18c7de20d595a14336e9f337ead580c70934141624b6d1ffdacc7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "webcolors" do
    url "https://files.pythonhosted.org/packages/7b/29/061ec845fb58521848f3739e466efd8250b4b7b98c1b6c5bf4d40b419b7e/webcolors-24.11.1.tar.gz"
    sha256 "ecb3d768f32202af770477b8b65f318fa4f566c22948673a977b00d589dd80f6"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/e6/30/fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5/websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
  end

  def python3
    "python3.13"
  end

  def install
    ENV["JUPYTER_PATH"] = etc/"jupyter"

    # install packages into virtualenv and link all jupyter extensions
    skipped = %w[hatch-jupyter-builder hatch-nodejs-version jupyterlab-pygments notebook]
    venv = virtualenv_install_with_resources without: skipped
    bin.install_symlink (libexec/"bin").glob("jupyter*")

    # These resources require `jupyterlab` to build, causing a build loop
    # with pip's --no-binary. They need `jlpm` in PATH, so we need to add it.
    # https://github.com/jupyterlab/jupyterlab_pygments/issues/23
    ENV.prepend_path "PATH", bin
    skipped.each do |r|
      venv.pip_install(resource(r), build_isolation: false)
    end

    # remove bundled kernel
    rm_r(libexec/"share/jupyter/kernels")

    # install completion
    resource("jupyter-core").stage do
      bash_completion.install "examples/jupyter-completion.bash" => "jupyter"
      zsh_completion.install "examples/completions-zsh" => "_jupyter"
    end
  end

  def caveats
    <<~EOS
      Additional kernels can be installed into the shared jupyter directory
        #{etc}/jupyter
    EOS
  end

  service do
    run [opt_bin/"jupyter-lab"]
    keep_alive true
    log_path var/"log/jupyterlab.log"
    error_log_path var/"log/jupyterlab.log"
  end

  test do
    assert_match "The Jupyter terminal-based Console", shell_output("#{bin}/jupyter-console --help")
    assert_match python3, shell_output("#{bin}/jupyter kernelspec list")
    assert_match(/In \[1\]:.*exit.*Shutting down/m, pipe_output("#{bin}/jupyter-console 2>&1", "exit"))

    require "expect"
    require "open3"
    Open3.popen3(bin/"jupyter", "notebook", "--no-browser") do |_stdin, _stdout, stderr, wait_thread|
      timeout = (OS.mac? && Hardware::CPU.intel?) ? 30 : 15
      refute_nil stderr.expect("Serving notebooks from local directory:", timeout), "Expected running message"
    ensure
      Process.kill "TERM", wait_thread.pid
    end

    (testpath/"nbconvert.ipynb").write <<~JSON
      {
        "cells": []
      }
    JSON
    system bin/"jupyter-nbconvert", "nbconvert.ipynb", "--to", "html"
    assert_path_exists testpath/"nbconvert.html", "Failed to export HTML"

    assert_match "-F _jupyter", shell_output("bash -c 'source #{bash_completion}/jupyter && complete -p jupyter'")

    # Ensure that jupyter can load the jupyter lab package.
    assert_match(/^jupyterlab *: #{version}$/, shell_output("#{bin}/jupyter --version"))

    # Ensure that jupyter-lab binary was installed by pip.
    assert_equal version.to_s, shell_output("#{bin}/jupyter-lab --version").strip

    port = free_port
    spawn bin/"jupyter-lab", "-y", "--port=#{port}", "--no-browser", "--ip=127.0.0.1", "--LabApp.token=''"
    sleep 15
    assert_match "<title>JupyterLab</title>", shell_output("curl --silent --fail http://localhost:#{port}/lab")
  end
end
