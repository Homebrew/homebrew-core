class Jupyterlab < Formula
  include Language::Python::Virtualenv

  desc "Interactive environments for writing and running code"
  homepage "https://jupyter.org/"
  url "https://files.pythonhosted.org/packages/2b/22/8440ec827762146e7cdecf04335bd348795899d29dc6ae82238707353a2c/jupyterlab-4.5.7.tar.gz"
  sha256 "55a9822c4754da305f41e113452c68383e214dcf96de760146af89ce5d5117b0"
  license all_of: [
    "BSD-3-Clause",
    "MIT", # semver.py
  ]
  revision 2
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e0267c5866d93538602f86ea44067663281f82053e92bb52d28ddaa5474443ef"
    sha256 cellar: :any,                 arm64_sequoia: "d34d4701171c494a58a3824db2a7d659ef2eb11e43529e84098323f58d806165"
    sha256 cellar: :any,                 arm64_sonoma:  "d69ab8053b737277718ce05acfc9583d98558d484fa875a202950771700123a9"
    sha256 cellar: :any,                 sonoma:        "7cc712388cf5dfe5405ae576255a2760f8c727bf2c326adbf3846dc09efed041"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae5d5aceca92afc2d112c947a0a194940ac3121ef108c5c2e29cc5f4fd3e99fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b50030744809bb36dfb352e2b1d9ffa2a6186e340f63247ccbda3eb05ae3cdb9"
  end

  depends_on "cmake" => :build # for ipykernel
  depends_on "ninja" => :build # for ipykernel
  depends_on "certifi" => :no_linkage
  depends_on "cffi" => :no_linkage
  depends_on "libyaml"
  depends_on "node"
  depends_on "pandoc"
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage
  depends_on "zeromq"

  uses_from_macos "libffi"

  pypi_packages extra_packages:   %w[appnope hatch-jupyter-builder hatch-nodejs-version jupyter-console notebook],
                exclude_packages: %w[certifi cffi rpds-py]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
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
    url "https://files.pythonhosted.org/packages/b9/33/032cdc44182491aa708d06a68b62434140d8c50820a087fac7af37703357/arrow-1.4.0.tar.gz"
    sha256 "ed0cc050e98001b8779e84d461b0098c4ac597e88704a655582b21d116e526d7"
  end

  resource "asttokens" do
    url "https://files.pythonhosted.org/packages/be/a5/8e3f9b6771b0b408517c82d97aed8f2036509bc247d46114925e32fe33f0/asttokens-3.0.1.tar.gz"
    sha256 "71a4ee5de0bde6a31d64f6b13f2293ac190344478f081c3d1bccfcf5eacb0cb7"
  end

  resource "async-lru" do
    url "https://files.pythonhosted.org/packages/e8/1f/989ecfef8e64109a489fff357450cb73fa73a865a92bd8c272170a6922c2/async_lru-2.3.0.tar.gz"
    sha256 "89bdb258a0140d7313cf8f4031d816a042202faa61d0ab310a0a538baa1c24b6"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "babel" do
    url "https://files.pythonhosted.org/packages/7d/b2/51899539b6ceeeb420d40ed3cd4b7a40519404f9baf3d4ac99dc413a834b/babel-2.18.0.tar.gz"
    sha256 "b80b99a14bd085fcacfa15c9165f651fbb3406e66cc603abf11c5750937c992d"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/c3/b0/1c6a16426d389813b48d95e26898aff79abbde42ad353958ad95cc8c9b21/beautifulsoup4-4.14.3.tar.gz"
    sha256 "6292b1c5186d356bba669ef9f7f051757099565ad9ada5dd630bd9de5fa7fb86"
  end

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/07/18/3c8523962314be6bf4c8989c79ad9531c825210dd13a8669f6b84336e8bd/bleach-6.3.0.tar.gz"
    sha256 "6f3b91b1c0a02bb9a78b5a454c92506aa0fdf197e1d5e114d2e00c6f64306d22"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "comm" do
    url "https://files.pythonhosted.org/packages/4c/13/7d740c5849255756bc17888787313b61fd38a0a8304fc4f073dfc46122aa/comm-0.2.3.tar.gz"
    sha256 "2dc8048c10962d55d7ad693be1e7045d891b7ce8d999c97963a5e3e99c055971"
  end

  resource "debugpy" do
    url "https://files.pythonhosted.org/packages/e0/b7/cd8080344452e4874aae67c40d8940e2b4d47b01601a8fd9f44786c757c7/debugpy-1.8.20.tar.gz"
    sha256 "55bc8701714969f1ab89a6d5f2f3d40c36f91b2cbe2f65d98bf8196f6a6a2c33"
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
    url "https://files.pythonhosted.org/packages/cf/9c/b4cfe330cd4f49cff17fd771154730555fa4123beb7f292cf0098b4e6c20/hatchling-1.29.0.tar.gz"
    sha256 "793c31816d952cee405b83488ce001c719f325d9cda69f1fc4cd750527640ea6"
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
    url "https://files.pythonhosted.org/packages/05/b1/efac073e0c297ecf2fb33c346989a529d4e19164f1759102dee5953ee17e/idna-3.14.tar.gz"
    sha256 "466d810d7a2cc1022bea9b037c39728d51ae7dad40d480fc9b7d7ecf98ba8ee3"
  end

  resource "ipykernel" do
    url "https://files.pythonhosted.org/packages/ca/8d/b68b728e2d06b9e0051019640a40a9eb7a88fcd82c2e1b5ce70bef5ff044/ipykernel-7.2.0.tar.gz"
    sha256 "18ed160b6dee2cbb16e5f3575858bc19d8f1fe6046a9a680c708494ce31d909e"
  end

  resource "ipython" do
    url "https://files.pythonhosted.org/packages/cd/c4/87cda5842cf5c31837c06ddb588e11c3c35d8ece89b7a0108c06b8c9b00a/ipython-9.13.0.tar.gz"
    sha256 "7e834b6afc99f020e3f05966ced34792f40267d64cb1ea9043886dab0dde5967"
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
    url "https://files.pythonhosted.org/packages/46/b7/a3635f6a2d7cf5b5dd98064fc1d5fbbafcb25477bcea204a3a92145d158b/jedi-0.20.0.tar.gz"
    sha256 "c3f4ccbd276696f4b19c54618d4fb18f9fc24b0aef02acf704b23f487daa1011"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "json5" do
    url "https://files.pythonhosted.org/packages/9c/4b/6f8906aaf67d501e259b0adab4d312945bb7211e8b8d4dcc77c92320edaa/json5-0.14.0.tar.gz"
    sha256 "b3f492fad9f6cdbced8b7d40b28b9b1c9701c5f561bef0d33b81c2ff433fefcb"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/18/c7/af399a2e7a67fd18d63c40c5e62d3af4e67b836a2107468b6a5ea24c4304/jsonpointer-3.1.1.tar.gz"
    sha256 "0b801c7db33a904024f6004d526dcc53bbb8a4a0f4e32bfd10beadf60adf1900"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "jupyter-client" do
    url "https://files.pythonhosted.org/packages/05/e4/ba649102a3bc3fbca54e7239fb924fd434c766f855693d86de0b1f2bec81/jupyter_client-8.8.0.tar.gz"
    sha256 "d556811419a4f2d96c869af34e854e3f059b7cc2d6d01a9cd9c85c267691be3e"
  end

  resource "jupyter-console" do
    url "https://files.pythonhosted.org/packages/bd/2d/e2fd31e2fc41c14e2bcb6c976ab732597e907523f6b2420305f9fc7fdbdb/jupyter_console-6.6.3.tar.gz"
    sha256 "566a4bf31c87adbfadf22cdf846e3069b59a71ed5da71d6ba4d8aaad14a53539"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/02/49/9d1284d0dc65e2c757b74c6687b6d319b02f822ad039e5c512df9194d9dd/jupyter_core-5.9.1.tar.gz"
    sha256 "4d09aaff303b9566c3ce657f580bd089ff5c91f5f89cf7d8846c3cdf465b5508"
  end

  resource "jupyter-events" do
    url "https://files.pythonhosted.org/packages/18/f8/475c4241b2b75af0deaae453ed003c6c851766dbc44d332d8baf245dc931/jupyter_events-0.12.1.tar.gz"
    sha256 "faff25f77218335752f35f23c5fe6e4a392a7bd99a5939ccb9b8fbf594636cf3"
  end

  resource "jupyter-lsp" do
    url "https://files.pythonhosted.org/packages/36/ff/1e4a61f5170a9a1d978f3ac3872449de6c01fc71eaf89657824c878b1549/jupyter_lsp-2.3.1.tar.gz"
    sha256 "fdf8a4aa7d85813976d6e29e95e6a2c8f752701f926f2715305249a3829805a6"
  end

  resource "jupyter-server" do
    url "https://files.pythonhosted.org/packages/ca/15/1eacb0fcb79ef86e8a0a79a708e6ad7435f6f223097dd29a4ce861fabc44/jupyter_server-2.18.2.tar.gz"
    sha256 "06b4f40d8a7a00bb39d5216859c81374a0e7cfefe6d8a5a7facc5a5c37c679a7"
  end

  resource "jupyter-server-terminals" do
    url "https://files.pythonhosted.org/packages/f4/a7/bcd0a9b0cbba88986fe944aaaf91bfda603e5a50bda8ed15123f381a3b2f/jupyter_server_terminals-0.5.4.tar.gz"
    sha256 "bbda128ed41d0be9020349f9f1f2a4ab9952a73ed5f5ac9f1419794761fb87f5"
  end

  resource "jupyterlab-pygments" do
    url "https://files.pythonhosted.org/packages/90/51/9187be60d989df97f5f0aba133fa54e7300f17616e065d1ada7d7646b6d6/jupyterlab_pygments-0.3.0.tar.gz"
    sha256 "721aca4d9029252b11cfa9d185e5b5af4d54772bb8072f9b7036f4170054d35d"
  end

  resource "jupyterlab-server" do
    url "https://files.pythonhosted.org/packages/d6/2c/90153f189e421e93c4bb4f9e3f59802a1f01abd2ac5cf40b152d7f735232/jupyterlab_server-2.28.0.tar.gz"
    sha256 "35baa81898b15f93573e2deca50d11ac0ae407ebb688299d3a5213265033712c"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/da/34/28fff3ab31ccff1fd4f6c7c7b0ceb2b6968d8ea4950663eadcb5720591a0/lark-1.3.1.tar.gz"
    sha256 "b426a7a6d6d53189d318f2b6236ab5d6429eaf09259f1ca33eb716eed10d2905"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "matplotlib-inline" do
    url "https://files.pythonhosted.org/packages/bd/c0/9f7c9a46090390368a4d7bcb76bb87a4a36c421e4c0792cdb53486ffac7a/matplotlib_inline-0.2.2.tar.gz"
    sha256 "72f3fe8fce36b70d4a5b612f899090cd0401deddc4ea90e1572b9f4bfb058c79"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/ca/84/620cc3f7e3adf6f5067e10f4dbae71295d8f9e16d5d3f9ef97c40f2f592c/mistune-3.2.1.tar.gz"
    sha256 "7c8e5501d38bac1582e067e46c8343f17d57ea1aaa735823f3aba1fd59c88a28"
  end

  resource "nbclient" do
    url "https://files.pythonhosted.org/packages/56/91/1c1d5a4b9a9ebba2b4e32b8c852c2975c872aec1fe42ab5e516b2cecd193/nbclient-0.10.4.tar.gz"
    sha256 "1e54091b16e6da39e297b0ece3e10f6f29f4ac4e8ee515d29f8a7099bd6553c9"
  end

  resource "nbconvert" do
    url "https://files.pythonhosted.org/packages/01/b1/708e53fe2e429c103c6e6e159106bcf0357ac41aa4c28772bd8402339051/nbconvert-7.17.1.tar.gz"
    sha256 "34d0d0a7e73ce3cbab6c5aae8f4f468797280b01fd8bd2ca746da8569eddd7d2"
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
    url "https://files.pythonhosted.org/packages/2a/c2/cf59bd2e6f2c8b976b52477e3e53bf6f97bc714ed046a51821afb428eaee/notebook-7.5.6.tar.gz"
    sha256 "621174aade80108f0020b0f00738000b215f75fa3cd90771ad7aa0f24536a4e1"
  end

  resource "notebook-shim" do
    url "https://files.pythonhosted.org/packages/54/d2/92fa3243712b9a3e8bafaf60aac366da1cada3639ca767ff4b5b3654ec28/notebook_shim-0.2.4.tar.gz"
    sha256 "b4b2cfa1b65d98307ca24361f5b30fe785b53c3fd07b7a47e89acb5e6ac638cb"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pandocfilters" do
    url "https://files.pythonhosted.org/packages/70/6f/3dd4940bbe001c06a65f88e36bad298bc7a0de5036115639926b0c5c0458/pandocfilters-1.5.1.tar.gz"
    sha256 "002b4a555ee4ebc03f8b66307e287fa492e4a77b4ea14d3f934328297bb4939e"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/30/4b/90c937815137d43ce71ba043cd3566221e9df6b9c805f24b5d138c9d40a7/parso-0.8.7.tar.gz"
    sha256 "eaaac4c9fdd5e9e8852dc778d2d7405897ec510f2a298071453e5e3a07914bb1"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/42/92/cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149d/pexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/9f/4a/0883b8e3802965322523f0b200ecf33d31f10991d0401162f4b23c698b42/platformdirs-4.9.6.tar.gz"
    sha256 "3bfa75b0ad0db84096ae777218481852c0ebc6c727b3168c1b9e0118e458cf0a"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/1b/fb/d9aa83ffe43ce1f19e557c0971d04b90561b0cfd50762aafb01968285553/prometheus_client-0.25.0.tar.gz"
    sha256 "5e373b75c31afb3c86f1a52fa1ad470c9aace18082d39ec0d2f918d11cc9ba28"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pure-eval" do
    url "https://files.pythonhosted.org/packages/cd/05/0a34433a064256a578f1783a10da6df098ceaa4a57bbeaa96a6c0352786b/pure_eval-0.2.3.tar.gz"
    sha256 "5f4e983f40564c576c7c8635ae88db5956bb2229d7e9237d03b3c0b0190eaf42"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-json-logger" do
    url "https://files.pythonhosted.org/packages/f7/ff/3cc9165fd44106973cd7ac9facb674a65ed853494592541d339bdc9a30eb/python_json_logger-4.1.0.tar.gz"
    sha256 "b396b9e3ed782b09ff9d6e4f1683d46c83ad0d35d2e407c09a9ebbf038f88195"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/04/0b/3c9baedbdf613ecaa7aa07027780b8867f57b6293b6ee50de316c9f3222b/pyzmq-27.1.0.tar.gz"
    sha256 "ac0765e3d44455adb6ddbf4417dcce460fc40a05978c08efdf2948072f6db540"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/43/b8/7a707d60fea4c49094e40262cc0e2ca6c768cca21587e34d3f705afec47e/requests-2.34.0.tar.gz"
    sha256 "7d62fe92f50eb82c529b0916bb445afa1531a566fc8f35ffdc64446e771b856a"
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

  resource "send2trash" do
    url "https://files.pythonhosted.org/packages/c5/f0/184b4b5f8d00f2a92cf96eec8967a3d550b52cf94362dad1100df9e48d57/send2trash-2.1.0.tar.gz"
    sha256 "1c72b39f09457db3c05ce1d19158c2cbef4c32b8bedd02c155e49282b7ea7459"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/7b/ae/2d9c981590ed9999a0d91755b47fc74f74de286b0f5cee14c9269041e6c4/soupsieve-2.8.3.tar.gz"
    sha256 "3267f1eeea4251fb42728b6dfb746edc9acaffc4a45b27e19450b676586e8349"
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
    url "https://files.pythonhosted.org/packages/f8/f1/3173dfa4a18db4a9b03e5d55325559dab51ee653763bb8745a75af491286/tornado-6.5.5.tar.gz"
    sha256 "192b8f3ea91bd7f1f50c06955416ed76c6b72f96779b962f07f911b91e8d30e9"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/1b/22/40f55b26baeab80c2d7b3f1db0682f8954e4617fee7d90ce634022ef05c6/traitlets-5.15.0.tar.gz"
    sha256 "4fead733f81cf1c4c938e06f8ca4633896833c9d89eff878159457f4d4392971"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/35/68/175e7c07c5be13200387d5c0995b0da1e198e360047c08eb17d1002fcd92/trove_classifiers-2026.5.7.17.tar.gz"
    sha256 "a04a48f8f0a787cb996514d3969ac7608aa3c60cb15d073c1e02801e60533e80"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/ba/19/1b9b0e29f30c6d35cb345486df41110984ea67ae69dddbc0e8a100999493/tzdata-2026.2.tar.gz"
    sha256 "9173fde7d80d9018e02a662e168e5a2d04f87c41ea174b139fbef642eda62d10"
  end

  resource "uri-template" do
    url "https://files.pythonhosted.org/packages/31/c7/0336f2bd0bcbada6ccef7aaa25e443c118a704f828a0620c6fa0207c1b64/uri-template-1.3.0.tar.gz"
    sha256 "0e00f8eb65e18c7de20d595a14336e9f337ead580c70934141624b6d1ffdacc7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/2c/ee/afaf0f85a9a18fe47a67f1e4422ed6cf1fe642f0ae0a2f81166231303c52/wcwidth-0.7.0.tar.gz"
    sha256 "90e3a7ea092341c44b99562e75d09e4d5160fe7a3974c6fb842a101a95e7eed0"
  end

  resource "webcolors" do
    url "https://files.pythonhosted.org/packages/1d/7a/eb316761ec35664ea5174709a68bbd3389de60d4a1ebab8808bfc264ed67/webcolors-25.10.0.tar.gz"
    sha256 "62abae86504f66d0f6364c2a8520de4a0c47b80c03fc3a5f1815fedbef7c19bf"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/2c/41/aa4bf9664e4cda14c3b39865b12251e8e7d239f4cd0e3cc1b6c2ccde25c1/websocket_client-1.9.0.tar.gz"
    sha256 "9e813624b6eb619999a97dc7958469217c3176312b3a16a4bd1bc7e08a46ec98"
  end

  def python3
    "python3.14"
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
