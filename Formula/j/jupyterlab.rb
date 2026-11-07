class Jupyterlab < Formula
  include Language::Python::Virtualenv

  desc "Interactive environments for writing and running code"
  homepage "https://jupyter.org/"
  url "https://files.pythonhosted.org/packages/51/43/490a500e421a46900c8afb0c912c1bf3c9977c85831a3815e2c2139309a9/jupyterlab-4.6.6.tar.gz"
  sha256 "5f6fbb409158167aeefb5781d6f0b228e24b493cb6e6f1320fb5bc8897acc223"
  license all_of: [
    "BSD-3-Clause",
    "MIT", # semver.py
  ]
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "16cb3c71bd8dda3ec7af3de36dccf4da9777764afced76ea3708db4697cb3372"
    sha256 cellar: :any, arm64_tahoe:       "aa48635a824a1c7f5f64ca960443fc8a75a6b7c7a1addcc9e592b8d87c17cde5"
    sha256 cellar: :any, arm64_sequoia:     "6e423795046282cf74956ae70f00633a49d30e42e26bad998a6f05ffe91f7cfb"
    sha256 cellar: :any, arm64_linux:       "12b2a910d4ce686ffed95f54d785b2f1cf88229a0e0c19919e738931b2b06488"
    sha256 cellar: :any, x86_64_linux:      "16a34b87c4d4dc595fc2d468bdb6728f58ec523de7affdb5a1b415476b474caa"
  end

  depends_on "cmake" => :build # for ipykernel
  depends_on "ninja" => :build # for ipykernel
  depends_on "certifi" => :no_linkage
  depends_on "cffi" => :no_linkage
  depends_on "libyaml"
  depends_on "node"
  depends_on "pandoc"
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage
  depends_on "zeromq"

  uses_from_macos "libffi"

  pypi_packages extra_packages:   %w[appnope hatch-jupyter-builder hatch-nodejs-version jupyter-console notebook],
                exclude_packages: %w[certifi cffi rpds-py]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
  end

  resource "appnope" do
    url "https://files.pythonhosted.org/packages/11/f7/a82489c2b6ebe32d3e2831895ae19c77861f0eadf3bb16034484d965dbb2/appnope-1.0.0.tar.gz"
    sha256 "685db59cb6043c3c2e528adc0b3bce3a5f8d09bcf7492c6ea650d1b7421f3c49"
  end

  resource "argon2-cffi" do
    url "https://files.pythonhosted.org/packages/0e/89/ce5af8a7d472a67cc819d5d998aa8c82c5d860608c4db9f46f1162d7dab9/argon2_cffi-25.1.0.tar.gz"
    sha256 "694ae5cc8a42f4c4e2bf2ca0e64e51e23a040c6a517a85074683d3959e1346c1"
  end

  resource "argon2-cffi-bindings" do
    url "https://files.pythonhosted.org/packages/0b/43/bb8b6e8708d49a5ab36781333af092d9f483b198a2710d01281204640055/argon2_cffi_bindings-26.1.0.tar.gz"
    sha256 "63505c71542a44b68b1e38060450fb006404170da375feb31af153e7f9c6205d"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/b9/33/032cdc44182491aa708d06a68b62434140d8c50820a087fac7af37703357/arrow-1.4.0.tar.gz"
    sha256 "ed0cc050e98001b8779e84d461b0098c4ac597e88704a655582b21d116e526d7"
  end

  resource "asttokens" do
    url "https://files.pythonhosted.org/packages/25/1e/faf0f247f6f881b98fc4d6d07e14085cb89d13665084e6d6ac1dc2c03d0b/asttokens-3.0.2.tar.gz"
    sha256 "3ecdbd8f2cc195f53ccada3a613538bb5f9ef6f6869129f13e03c30a677b8fe2"
  end

  resource "async-lru" do
    url "https://files.pythonhosted.org/packages/8f/43/9d22679e8dd0ed965182cca990d32c68b150730cce8046ad61b3179b5b7a/async_lru-2.4.0.tar.gz"
    sha256 "b0b0077d9b7596615b3c12d0aad4f6aeccaaa0ac75ceae472608ede89e764c08"
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
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/48/3c/e12ac860709702bd5ebeb9b56a4fe334f1001246ee1b8f2b7ee28912df7d/bleach-6.4.0.tar.gz"
    sha256 "4202482733d85cedd04e59fcb2f89f4e4c7c385a78d3c3c23c30446843a37452"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "comm" do
    url "https://files.pythonhosted.org/packages/4c/13/7d740c5849255756bc17888787313b61fd38a0a8304fc4f073dfc46122aa/comm-0.2.3.tar.gz"
    sha256 "2dc8048c10962d55d7ad693be1e7045d891b7ce8d999c97963a5e3e99c055971"
  end

  resource "debugpy" do
    url "https://files.pythonhosted.org/packages/44/9d/3cb6693342acf96802dba89934a5b8da43c201d764ebd1f2c0514a3d42bd/debugpy-1.8.22.tar.gz"
    sha256 "e489c7268e1c7b41e13b438d9c533d2a7af73fb59bf8cd30fead8286c1c39c4e"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "executing" do
    url "https://files.pythonhosted.org/packages/52/92/8a611141e42930c0f194f7504063ab87dfe970cf1a5af28e7703df448734/executing-2.3.0.tar.gz"
    sha256 "15919cb5d667e5cb4e099511971d00d659573fff2dd5c4e6cd8b71636c7858d2"
  end

  resource "fastjsonschema" do
    url "https://files.pythonhosted.org/packages/1c/80/cc3c531dd70c8ffa1045aecf33c97c5581cc8fd0e824b3ecb2c1881550c1/fastjsonschema-2.22.3.tar.gz"
    sha256 "8330c91b027dcf941efcb7b1f0998515ff95d177ea15bbabdfe8671965620901"
  end

  resource "fqdn" do
    url "https://files.pythonhosted.org/packages/02/01/248d44fbda9e78fa1a7b5a475194bef4c4a3e285db286419f3bb42f2efdf/fqdn-1.6.0.tar.gz"
    sha256 "e39bf62e2a9481aa2cb780554fdfd944dd8ee5f230eb831684d539cbafed8de2"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hatch-jupyter-builder" do
    url "https://files.pythonhosted.org/packages/fa/71/8fde9a971de1bfdb52c9cc10be561909241ddb4a4e34d580353a76c82f35/hatch_jupyter_builder-0.10.0.tar.gz"
    sha256 "144f6a7afd7f837071eca81141313d736643be4f6734b45f30661bcb922bd80a"
  end

  resource "hatch-nodejs-version" do
    url "https://files.pythonhosted.org/packages/19/c9/1823a9e45eadd487bece8f2b3b29311edd79ba900d874885b1e9f7973a50/hatch_nodejs_version-0.4.0.tar.gz"
    sha256 "2428ea398dd053f019d2b7ac949dd6b690ca8e826b6d433ad13c5b6c475ae91b"
  end

  resource "hatchling" do
    url "https://files.pythonhosted.org/packages/7a/f1/e47b937226ae3b093bbd0132eb0b7ee5bfad12c2b5324afd10ae49946b05/hatchling-1.33.0.tar.gz"
    sha256 "4c422bd4d554fcff5de5b73e9596f85e41e9f97f7e553d8f7595ecb31a627bef"
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
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "ipykernel" do
    url "https://files.pythonhosted.org/packages/7a/05/e5499c8b762387d83926bf0389e8fff888c9bf6e7af30566a8527bc12f4a/ipykernel-7.4.0.tar.gz"
    sha256 "4330114d22b9b33575b2c7c68753fc8faabbbcfbc60b0cdff9f14dd4ce63742f"
  end

  resource "ipython" do
    url "https://files.pythonhosted.org/packages/38/04/0d945c72d5b77527273ecb4c66aa2436de7a3b3bbe3da345bf053232b886/ipython-9.18.1.tar.gz"
    sha256 "6319c0f5372c196397899479e6db1783dd7937abae06815d1317e8d5d51aaaaf"
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
    url "https://files.pythonhosted.org/packages/a3/a4/4692ecd7fa700ac1066b1c1f6cadef60aa2e01e5e364710235137d823e0a/jedi-0.20.1.tar.gz"
    sha256 "2f71208c3f9c1bca057c0e90d3f272aba44ace88fc4067d7587e9e069331b7e5"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "json5" do
    url "https://files.pythonhosted.org/packages/16/1f/58a4d7ee466f81bc3c7337036380fc6d49de3afb7855d74f8121b1e89b32/json5-0.17.3.tar.gz"
    sha256 "8d0278ad34ebaa9c3af76d9519274811830224a2d1cd5af156dbd067f461b8a4"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/93/f6/d1109cbb2c7cb692b432071802028052ba8d275c613c1a1cce427bc62c97/jsonpointer-3.10.tar.gz"
    sha256 "69349c0e738c93e9efa501397091f49ad302ae686293effd05d7755c06f88ef0"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "jupyter-builder" do
    url "https://files.pythonhosted.org/packages/69/4d/5681a9a083becca3e52d53c21bc16ee7ccdea485a4b15f4ad5c97b57e4a6/jupyter_builder-1.2.4.tar.gz"
    sha256 "da5b46fc49faac39e977259e489519ee1a92917c31d90d1d258832d8f4d288a3"
  end

  resource "jupyter-client" do
    url "https://files.pythonhosted.org/packages/c5/2a/906772148a06e48885039e0250c340b770a55bbf37b08d6ee0449df369c3/jupyter_client-8.10.0.tar.gz"
    sha256 "9f7116294dca55f1785be880057d44544db9b1567718d92cb33c58886afb9497"
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
    url "https://files.pythonhosted.org/packages/65/3d/3c9f8bce5d5448107bd285cd80185e76c9c871d076b580dfd90997e52904/jupyter_server-2.21.1.tar.gz"
    sha256 "a8960aa29263f6041283e97d4756b099fb49b767baab6371891ecb1bd40a63df"
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
    url "https://files.pythonhosted.org/packages/16/c5/08946a10b81bd64408d8b78cb352e17fe52d3ee11c2aef00a0f06e506938/jupyterlab_server-2.28.1.tar.gz"
    sha256 "0c3c2418d51021ce280916e63dfe4cba8386b4e2787be5c25433c98f560ddb31"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/da/34/28fff3ab31ccff1fd4f6c7c7b0ceb2b6968d8ea4950663eadcb5720591a0/lark-1.3.1.tar.gz"
    sha256 "b426a7a6d6d53189d318f2b6236ab5d6429eaf09259f1ca33eb716eed10d2905"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "matplotlib-inline" do
    url "https://files.pythonhosted.org/packages/bd/c0/9f7c9a46090390368a4d7bcb76bb87a4a36c421e4c0792cdb53486ffac7a/matplotlib_inline-0.2.2.tar.gz"
    sha256 "72f3fe8fce36b70d4a5b612f899090cd0401deddc4ea90e1572b9f4bfb058c79"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/96/eb/749a4e69bf7396e751ae37444abe997eff2254e695a8095b84d1c89c1181/mistune-3.4.0.tar.gz"
    sha256 "2eaf7952af928ca8d33b779762effc1da517b62c6ad85ec8ca957e3b07b9782a"
  end

  resource "nbclient" do
    url "https://files.pythonhosted.org/packages/28/a5/b3bae4b590c0cbcada2c63a34f7580024e834a8ba213e949a2f906705787/nbclient-0.11.0.tar.gz"
    sha256 "04a134a5b087f2c5887f228aca155db50169b8cd9334dee6942c8e927e56081a"
  end

  resource "nbconvert" do
    url "https://files.pythonhosted.org/packages/53/6a/252c7620305a9661205aed7a2a4b3592f5207bfca56ad11b7dea2c5ec2f6/nbconvert-7.17.2.tar.gz"
    sha256 "344a218e8595117ce37396ed025d994f146d076226ebac59255a2fa085ab24d8"
  end

  resource "nbformat" do
    url "https://files.pythonhosted.org/packages/31/72/b3446efab8756e7df4b8ec587f8e611cb5a7249e4323db480802f1d3be04/nbformat-5.11.1.tar.gz"
    sha256 "32d4521c68c6e7d5b29c76defaeed9f42ea733142b9b19f88277ce10390b9c4d"
  end

  resource "nest-asyncio2" do
    url "https://files.pythonhosted.org/packages/32/2c/70e3b6bb2189cfd260280b7e1042bd622949a258663f95e887fada4ac1e6/nest_asyncio2-1.7.4.tar.gz"
    sha256 "995b1409d926ec55e0876ea39a69bffdd8852cf1db3652c177e8c8ffdbcaf3cc"
  end

  resource "notebook" do
    url "https://files.pythonhosted.org/packages/2c/0c/17a9c9029b0b79153969231d534a6820192b59508f7d8cbab451478e6c71/notebook-7.6.4.tar.gz"
    sha256 "8aec433e08811af5c8d0e8cff23bf5079d85fd2912cee162894933f26f443d9e"
  end

  resource "notebook-shim" do
    url "https://files.pythonhosted.org/packages/54/d2/92fa3243712b9a3e8bafaf60aac366da1cada3639ca767ff4b5b3654ec28/notebook_shim-0.2.4.tar.gz"
    sha256 "b4b2cfa1b65d98307ca24361f5b30fe785b53c3fd07b7a47e89acb5e6ac638cb"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
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
    url "https://files.pythonhosted.org/packages/d7/9a/8475be631fb33ca1466915e70fd594c42a4e84b512db650eaa14f90fe75d/platformdirs-4.14.5.tar.gz"
    sha256 "32e9921db7385aa8169bee4fe9501923e5715ba9fb7ea3b9c69b0d8e0639f7a1"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/bf/db/7fc19e6f2dc92a966727031389fc2e08b558f0f25eb7403c1119ad4713cd/pluggy-1.7.0.tar.gz"
    sha256 "d1eaa46ebb595891b860ab086b4d09c8588af65ebd4361b8e8f4bb8920b90ba8"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/52/73/f1334c29c2af4cd9dba6c7817e61b611bd0215e2eb5565c6064a4de18802/prometheus_client-0.26.0.tar.gz"
    sha256 "04a91bcf94e2cf74a44a1a874d651a2e853ed354b6e822f3b7487751465d5c2b"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
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
    url "https://files.pythonhosted.org/packages/da/9f/abfd2959e9261dd5217ca8551d4de211ca6ab26fe9b72cf44731ff6c4442/pure_eval-0.2.4.tar.gz"
    sha256 "260c2774686e651b79f8b8e7fc9d80b3599ea6a66334b47d5f4abb69fc2c0ea1"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/18/39/b3927f3616f6223832f9b760e4208e8a7c7e1dea2b4d9ad7d32a5d214c3a/python_dateutil-4.0.0.tar.gz"
    sha256 "d7295ff14fdc0f92f662100bfb6c551d160ca090f2939f1ec5b9794265c03f06"
  end

  resource "python-json-logger" do
    url "https://files.pythonhosted.org/packages/21/25/5473e46b179f8e8b4ad3aeeb36773d1701b7770eaf5e5bc2025c7303b598/python_json_logger-4.2.0.tar.gz"
    sha256 "e371ebe22ec01e289850102091a2b1f6fc9e655c7f1f5f29073936756c290afa"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/e2/e1/ea46ab0d707219c098065a37d2add5b53d3b124241aa19429bcd0863e5b4/pyzmq-27.3.0.tar.gz"
    sha256 "bbedb3d1d99babc625f1dd9d7438acefd442b36b75073fd6bc1ef7c0a4b96d56"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
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

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/01/7c/a64eedae0b7776cb9602d2da9cb8f8caae8e1b4c1da5e8e87bf1e68121ec/soupsieve-4.0.1.tar.gz"
    sha256 "7621e3c5f6b371ed2c5eabaac5de300ac3d66d05e6d7f34783e31b63c4f90c75"
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
    url "https://files.pythonhosted.org/packages/a3/ae/2ca4913e5c0f09781d75482874c3a95db9105462a92ddd303c7d285d3df2/tinycss2-1.5.1.tar.gz"
    sha256 "d339d2b616ba90ccce58da8495a78f46e55d4d25f9fd71dfd526f07e7d53f957"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/08/72/fc01563df95c189a9f65850096bdc205bc2fe37da6c740cd64afaf18d07e/tomlkit-0.15.2.tar.gz"
    sha256 "83e32755ba1d20d9340bd069ee97e9f6232ba2346b63ffcba425de01f7e327a6"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/d0/02/5f549b1ad5da6267ed1e1fac2eef69257b1979cc812497002499b7895ff9/tornado-6.6.tar.gz"
    sha256 "34c4aa916d7f2b2d5cadee2c6850f5a4a7f3d688cbf58399ea9bd3057af4abd5"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/2c/2e/a7fbfe268c8a3b32546930c0297c101d65a4a14c304ad5790a9f478f0e4e/traitlets-5.16.1.tar.gz"
    sha256 "ed900c2b631aa3a112811139fa97b8d2c3bad5e989656bba4b7e52c7852c18c1"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/bf/93/af436dfaa845cab5d96f0adbc1e4f3730532d37fa249e4eb796fb1d7fc82/trove_classifiers-2026.9.21.13.tar.gz"
    sha256 "0a9ebc8d4e2f3e8a22848c5258033035bec17a3012ac3fea16dbaa764489eb71"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/7a/29/6a1391d31cd00ff9e927215a224a880e1e84e826b64ba80a499e51c074d8/tzdata-2026.6.tar.gz"
    sha256 "85d2cd9c09f81f0bb29db27759fc83af4f1e620efb814f8c5bf8b4cc4feece6d"
  end

  resource "uri-template" do
    url "https://files.pythonhosted.org/packages/31/c7/0336f2bd0bcbada6ccef7aaa25e443c118a704f828a0620c6fa0207c1b64/uri-template-1.3.0.tar.gz"
    sha256 "0e00f8eb65e18c7de20d595a14336e9f337ead580c70934141624b6d1ffdacc7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/ea/01/e5ac23733628a6bbb91913a765fcf55ee8070d8d991bc88fdaaf805052c7/wcwidth-0.9.4.tar.gz"
    sha256 "fd8d57d3cdfe570e3265c8fab1885c24e34ef40889c0759c0c304a19e9835954"
  end

  resource "webcolors" do
    url "https://files.pythonhosted.org/packages/1d/7a/eb316761ec35664ea5174709a68bbd3389de60d4a1ebab8808bfc264ed67/webcolors-25.10.0.tar.gz"
    sha256 "62abae86504f66d0f6364c2a8520de4a0c47b80c03fc3a5f1815fedbef7c19bf"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/d5/a0/8fd707bcb776a7be556bad06a2ea5fb9bd519df78ef8e26f70ccf0f38bff/webencodings-0.6.1.tar.gz"
    sha256 "565f9ad031c702dae404e27a099e3e09186a3ab1b9520f06d215502b651fd910"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/d8/cb/a5abcc2891249f393827c650c6296660ce40374ac22d99ab9aea41f9d2a2/websocket_client-1.9.2.tar.gz"
    sha256 "0fcb57545848be86992e128218fd96dd87a6769ffdb1a968dff79632b85604d0"
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
    ENV.prepend_path "PATH", libexec/"bin"
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
    assert_match python3.basename.to_s, shell_output("#{bin}/jupyter kernelspec list")
    assert_match(/In \[1\]:.*exit.*Shutting down/m, pipe_output("#{bin}/jupyter-console 2>&1", "exit"))

    require "expect"
    require "open3"
    Open3.popen3(bin/"jupyter", "notebook", "--no-browser") do |_stdin, _stdout, stderr, wait_thread|
      # Startup runs `node`, whose first launch on macOS CI VMs can spend 20+ seconds in dyld
      refute_nil stderr.expect("Serving notebooks from local directory:", 90), "Expected running message"
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
