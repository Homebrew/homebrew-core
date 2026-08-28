class CodexRouter < Formula
  include Language::Python::Virtualenv

  desc "Use external coding models inside the Codex App and CLI"
  homepage "https://github.com/duolahypercho/codex-router"
  url "https://github.com/duolahypercho/codex-router/releases/download/v0.5.1/codex-router-0.5.1.tar.gz"
  sha256 "c0bdfbc2573431cb5847c318ffa539d3d2e745876e63944b4713931c4389df15"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libsndfile"
  # Homebrew's superenv exports SODIUM_INSTALL=system for every build, so PyNaCl
  # skips the libsodium it vendors and expects one to already be present. Without
  # this its _sodium.c cannot find sodium.h. See Homebrew's extend/ENV/super.rb.
  depends_on "libsodium"
  depends_on "libyaml"
  depends_on "node"
  depends_on "numpy"
  depends_on "python@3.14"

  # Optional LiteLLM resources omitted because PyPI publishes no portable source:
  # - hf-xet==1.6.0
  # - pyroscope-io==0.8.16

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/ce/f4/eec0465c2f67b2664688d0240b3212d5196fd89e741df67ddb81f8d35658/aiohappyeyeballs-2.7.1.tar.gz"
    sha256 "065665c041c42a5938ed220bdcd7230f22527fbec085e1853d2402c8a3615d9d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/58/d9/22ce5786ac0c1653ae8b6c23bded02c1686d11f0dbb45b31ce128e0df985/aiohttp-3.14.3.tar.gz"
    sha256 "9491196535a88924a60afd5b5f434b5b203b6cc616250878dbdb223a8f7844bc"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/5f/56/a8120250d128bed162cd73c76d45f6ef9991f3e068f62a8ee060afa3104a/annotated_types-0.8.0.tar.gz"
    sha256 "13b2beaad985e05e2d6407ee4c4f35590b11f8d693a258a561055cac8f64cab7"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/61/cc/a381afa6efea9f496eff839d4a6a1aed3bfafc7b3ab4b0d1b243a12573dd/anyio-4.14.2.tar.gz"
    sha256 "cfa139f3ed1a23ee8f88a145ddb5ac7605b8bbfd8592baacd7ce3d8bb4313c7f"
  end

  resource "apscheduler" do
    url "https://files.pythonhosted.org/packages/8c/6b/eeff360196bb20b312c9e762a820fd1b2c6d809466c755ef57863478e454/apscheduler-3.11.3.tar.gz"
    sha256 "cd2fcc9330039a81a5893472ad49facf23a6d5604cbe1d918c835c6de7834d5a"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/a6/f3/b416179e408990df5db0d516283022dde0f5d0111d98c1a848e41853e81c/azure_core-1.41.0.tar.gz"
    sha256 "f46ff5dfcd230f25cf1c19e8a34b8dc08a337b2503e268bb600a16c00db8ad5a"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/c5/0e/3a63efb48aa4a5ae2cfca61ee152fbcb668092134d3eb8bfda472dd5c617/azure_identity-1.25.3.tar.gz"
    sha256 "ab23c0d63015f50b630ef6c6cf395e7262f439ce06e5d07a64e874c724f8d9e6"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/3b/48/84a820d898267f662b5c06f7cd76fdb8a9e272b44aa9376cef3ec0f6a294/azure_storage_blob-12.30.0.tar.gz"
    sha256 "2cd74d4d5731e5eb6b8d5c5056ee115a5e88f8fdf22517b739836fda685018be"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/ad/bf/ef5de9b55523bc2141d072fbe6614627088e3e6f97b47850216e99de6a1c/boto3-1.43.67.tar.gz"
    sha256 "75fe983b70d39cfdc274dc51f9bb02b8a0a104bdad4fa073c1af85a35e707c91"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/53/1c/3a75deae60e36bd0ee5c27d040384756b2ea1c90bd7c8c9658335a18b4f5/botocore-1.43.67.tar.gz"
    sha256 "6fe5cfa0c8676ba809efe505b618ec00f30d1af2d014bf316a7aa4ee86accb20"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/a3/c2/24167ea9858356b47a87a50d39908bfdb72ceeefe0041586e704e5376b3a/certifi-2026.7.22.tar.gz"
    sha256 "741e2c3b351ddf169a738da9f2c048608ff7f2c5cc02f1ebc6b118bb090d5d55"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/9e/ef/008a1939e372c06329a3fce4279c02f328488f3526744906eeec3da7ad5f/cffi-2.1.1.tar.gz"
    sha256 "dd31f52ea1086513bb9df30f8fcee9b8918323ae067a3d5b78bc826a000712be"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "croniter" do
    url "https://files.pythonhosted.org/packages/37/57/2e2a65aee2a70483cb28e2b7e15a072d00a523207593b44400d4717bb100/croniter-6.2.4.tar.gz"
    sha256 "fc124f751b1b04805c2a04b061898b436b45ab2320b045e1e052ea895de65189"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/de/41/6cbdcf9142d00fe82836fbb51e503e58088575cf7a0fe1dbff6695bf0840/cryptography-50.0.0.tar.gz"
    sha256 "eeac2acb5a20ed25e0ad6d1df9891a520b78b404266b6d11778f25d5d691a6c9"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/f5/22/900cb125c76b7aaa450ce02fd727f452243f2e91a61af068b40adba60ea9/email_validator-2.3.0.tar.gz"
    sha256 "9fc05c37f2f6cf439ff414f8fc46d917929974a82244c20eb10231ba60c54426"
  end

  resource "expression" do
    url "https://files.pythonhosted.org/packages/43/c7/bb061623b5815566bda69f5e9d156e38a97ebb383b8db3d2dedb26415466/expression-5.6.0.tar.gz"
    sha256 "454f6fe138347194a43c7f878d958efe9b84b9cc770e462010c7a52e18058065"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/cd/95/d3f0ae10836324a2eab98a52b61210ac609f08200bf4bb0dc8132d32f78a/fastapi-0.139.2.tar.gz"
    sha256 "333145a6891e9b5b3cfceb69baf817e8240cde4d4588ae5a10bf56ffacb6255e"
  end

  resource "fastapi-sso" do
    url "https://files.pythonhosted.org/packages/41/38/1288b0248f91822bba254ce852466857cb51217b817c3d62bcc21cfd4d9e/fastapi_sso-0.21.1.tar.gz"
    sha256 "c6f730b075caf537efa7c0f531095cf2d963a6fa27d059b3300e5eb19b282adb"
  end

  resource "fastuuid" do
    url "https://files.pythonhosted.org/packages/c3/7d/d9daedf0f2ebcacd20d599928f8913e9d2aea1d56d2d355a93bfa2b611d7/fastuuid-0.14.0.tar.gz"
    sha256 "178947fc2f995b38497a74172adee64fdeb8b7ec18f2a5934d037641ba265d26"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/f6/57/3ba6e6cb097f85b855b00163d169f35365f44277df044dcf96d55b8f62a3/filelock-3.32.2.tar.gz"
    sha256 "c33351e1f49cae33414acbc6d56784e6ecee82514ec90795da1161fc4836b5b8"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/00/78/f34251dadb8f3921264a1d9b8946f5e542014ee2614b285261b4e40e6775/fsspec-2026.7.0.tar.gz"
    sha256 "c803c40f4cf860b49dea58ee3e1c33cb9c790520e233537e1340049f89b82a88"
  end

  resource "granian" do
    url "https://files.pythonhosted.org/packages/d3/a2/8429f7cd27c99ae954be8663ca46067e0d31ee84fb887a25406a9e5bc8f8/granian-2.8.1.tar.gz"
    sha256 "41a7954e10621ca46f9bfe829a42272e4796358cc4bf27a9253f3171f871a397"
  end

  resource "gunicorn" do
    url "https://files.pythonhosted.org/packages/34/72/9614c465dc206155d93eff0ca20d42e1e35afc533971379482de953521a4/gunicorn-23.0.0.tar.gz"
    sha256 "f014447a0101dc57e294f6c18ca6b40227a4c90e9bdb586042628030cba004ec"
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

  resource "httpx-sse" do
    url "https://files.pythonhosted.org/packages/0f/4c/751061ffa58615a32c31b2d82e8482be8dd4a89154f003147acee90f2be9/httpx_sse-0.4.3.tar.gz"
    sha256 "9b1ed0127459a66014aec3c56bebd93da3c1bc8bb6618c8082039a44889a755d"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/3e/9b/ddf3d02a8681f1b9ce52fda03d755dad6b74c4f8172304c4c8d2975450f9/huggingface_hub-1.27.0.tar.gz"
    sha256 "c1fed40ea82a6b41b477f5243546549b792ae0a93abcea608cff66089bf8f8df"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/e7/72/c600ae4f68c28fc19f9c31b9403053e5dbb8cace2e6842c7b7c3e4d42fe9/importlib_metadata-8.9.0.tar.gz"
    sha256 "58850626cef4bd2df100378b0f2aea9724a7b92f10770d547725b047078f99ee"
  end

  resource "inquirerpy" do
    url "https://files.pythonhosted.org/packages/64/73/7570847b9da026e07053da3bbe2ac7ea6cde6bb2cbd3c7a5a950fa0ae40b/InquirerPy-0.3.4.tar.gz"
    sha256 "89d2ada0111f337483cb41ae31073108b2ec1e618a49d7110b0d7ade89fc197e"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/1d/1f/10936e16d8860c70698a1aa939a46aa0224813b782bce4e000e637da0b2d/jiter-0.16.0.tar.gz"
    sha256 "7b24c3492c5f4f84a37946ad9cf504910cf6a782d6a4e0689b6673c5894b4a1c"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "litellm" do
    url "https://files.pythonhosted.org/packages/d0/92/1171e76f2a4204a65adb5c827475e4f1d30e7c6a89d3d3e944d58b6fd8a6/litellm-1.96.0.tar.gz"
    sha256 "340a9b04e1bf8486b0b99f3f6a5556aa59c8f9c16b11b362c95eabea1bcf7a9d"
  end

  resource "litellm-enterprise" do
    url "https://files.pythonhosted.org/packages/d5/3b/0a9c5dae5e87e9ab26dd4f005d33bf9d17e88eb7107c107453fce109f7db/litellm_enterprise-0.1.53.tar.gz"
    sha256 "5608a9154ea12c0d5730b8c0013f074ba2df684a4d88296ab9363ccf2aa4552f"
  end

  resource "litellm-proxy-extras" do
    url "https://files.pythonhosted.org/packages/7f/6b/f9aeb200c2fcd9e74feaa00746fd6dfd4f0f639ad21f566f6e6c49f6d8f3/litellm_proxy_extras-0.4.81.tar.gz"
    sha256 "b25a324751cdb719c99996e026f62393496c64a5b9cf0dfed235c052fb5ea82a"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/30/d3/f9acc21dfc886e4f78e2add1a47db46ce16884346afde53f8a064c02c891/mcp-1.29.0.tar.gz"
    sha256 "52d01f334de1868cc3bb2d6604931126a67631f99a6c5d3b82ba47290315ec36"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/9a/99/d840198ecf6e8057bbc937f129ae940404485d736cda73253bbff9537f01/msal-1.37.0.tar.gz"
    sha256 "1b1672a33ee467c1d70b341bb16cafd51bb3c817147a95b93263794b03971bec"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/01/99/5d239b6156eddf761a636bded1118414d161bd6b7b37a9335549ed159396/msal_extensions-1.3.1.tar.gz"
    sha256 "c5b0fd10f65ef62b5f1d62f4251d51cbcaf003fcedae8c91b040a488614be1a4"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/ef/cf/36e3e7235fdf6d125c052acc0970924611b17a20a4fe580596faf4566a65/openai-2.53.0.tar.gz"
    sha256 "baf5802ad08980e1d9d561e1b996e800c8bcd14af5847c6d0e7a5cc59e4d4116"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/7e/0c/964746fcafbd16f8ff53219ad9f6b412b34f345c75f384ad434ceaadb538/orjson-3.11.9.tar.gz"
    sha256 "4fef17e1f8722c11587a6ef18e35902450221da0028e65dbaaa543619e68e48f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pfzy" do
    url "https://files.pythonhosted.org/packages/d9/5a/32b50c077c86bfccc7bed4881c5a2b823518f5450a30e639db5d3711952e/pfzy-0.3.4.tar.gz"
    sha256 "717ea765dd10b63618e7298b2d98efd819e0b30cd5905c9707223dceeb94b3f1"
  end

  resource "polars" do
    url "https://files.pythonhosted.org/packages/89/13/3873f213304bcbaaf39e63c8b905ceb460a0524448d57f86a829f6d4d0fd/polars-1.43.2.tar.gz"
    sha256 "c699671b99eb71ff53334d237917aaa3db5ad4dda480abcb6c80e0eaee7b677b"
  end

  resource "polars-runtime-32" do
    url "https://files.pythonhosted.org/packages/d4/06/11b578eeef05f867e3ee31b2a2fdd8e7684c2aa47822c49935d1be789c38/polars_runtime_32-1.43.2.tar.gz"
    sha256 "d7b7c486bccee75a6af0158b87077da3d054657e3c60036b28644f4e1c7fdbf7"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/ec/44/c87281c333769159c50594f22610f77398a47ccbfbbf23074e744e86f87c/propcache-0.5.2.tar.gz"
    sha256 "01c4fc7480cd0598bb4b57022df55b9ca296da7fc5a8760bd8451a7e63a7d427"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1b/7d/92392ff7815c21062bea51aa7b87d45576f649f16458d78b7cf94b9ab2e6/pycparser-3.0.tar.gz"
    sha256 "600f49d217304a5902ac3c37e1281c9fe94e4d0489de643a9504c5cdfdfc6b29"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/18/a5/b60d21ac674192f8ab0ba4e9fd860690f9b4a6e51ca5df118733b487d8d6/pydantic-2.13.4.tar.gz"
    sha256 "c40756b57adaa8b1efeeced5c196f3f3b7c435f90e84ea7f443901bec8099ef6"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/9d/56/921726b776ace8d8f5db44c4ef961006580d91dc52b803c489fafd1aa249/pydantic_core-2.46.4.tar.gz"
    sha256 "62f875393d7f270851f20523dd2e29f082bcc82292d66db2b64ea71f64b6e1c1"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/68/ca/31c57507b13119d7d3cfa1576dad2911a4861e3be07b579395f4e9d393f9/pydantic_settings-2.15.0.tar.gz"
    sha256 "694b793e84f766ba76a90ebdefc01d0a9a045dab0382bee70393da93712ad117"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/3b/81/58d0ac84e1ef3a3843791d6954d94c0b33d526c75eeb1efbce9d0a4c4077/pyjwt-2.13.0.tar.gz"
    sha256 "41571c89ca91598c79e8ef18a2d07367d4810fbbd6f637794879baf1b7703423"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/5b/42/55c32bb9b12693c092ad250a0e82edb5b31ddeda6eb772de5f308b3804ad/python_multipart-0.0.32.tar.gz"
    sha256 "be54b7f3fa167bb83e4fcd936b887b708f4e57fe75911c02aebf53efaf8d938e"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "redis" do
    url "https://files.pythonhosted.org/packages/a8/99/604f0b666d4c616d891cf77ebb9db6bb21601344c051aebf1b72b9ff915f/redis-8.1.0.tar.gz"
    sha256 "6e1a19beef9225c83efd689c7e6b7da2d5215b1f42cd13b7fc3714d0a09c7b25"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/20/98/04b13f1ddfb63158025291c02e03eb42fbb7acb51d091d541050eb4e35e8/regex-2026.7.19.tar.gz"
    sha256 "7e77b324909c1617cbb4c668677e2c6ae13f44d7c1de0d4f15f2e3c10f3315b5"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "restrictedpython" do
    url "https://files.pythonhosted.org/packages/48/50/9302f9a3419ba1956d85b5680c26fd90b32b8064b06c17af31a62e87d936/restrictedpython-8.4.tar.gz"
    sha256 "68e463c22396fd94606043795ac7dbee05072725f38d0db7e1748da3f54fb274"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/aa/2a/9618a122aeb2a169a28b03889a2995fe297588964333d4a7d67bdf46e147/rpds_py-2026.6.3.tar.gz"
    sha256 "1cebd1337c242e4ec2293e541f712b2da849b29f48f0c293684b71c0632625d4"
  end

  resource "rq" do
    url "https://files.pythonhosted.org/packages/cc/a8/7bf65cda593feb5888214a4d1e64aae6fc5eb0bbbb74df922c916099a3e5/rq-2.10.0.tar.gz"
    sha256 "2d8c533dd27500fedabec06295f18db595966e4f22744e6988fe31155b8f7a21"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/76/43/35e4d8aa320bffe8287fe8f65f578fa2d2db0a64212f0e710dce58267854/s3transfer-0.19.2.tar.gz"
    sha256 "ba0309fd86be3c27dbf78cdd813c13c5e1df16e5874b99d2535ebbdfb9892993"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "soundfile" do
    url "https://files.pythonhosted.org/packages/d2/db/949331952a6fb1c5b12e9de80fd08747966c2039d1a61db4764fbd3981c2/soundfile-0.14.0.tar.gz"
    sha256 "ba1c1a2d618bca5c406647c83b89f07cc8810fa506a50622a6993ba130c1de11"
  end

  resource "sse-starlette" do
    url "https://files.pythonhosted.org/packages/f8/00/b42a44342a054d58cb1115d7c8aa9cb4290dd9442f9c1b91a4b8173dba22/sse_starlette-3.4.8.tar.gz"
    sha256 "ed89ffbb75cbf78a5fe2f2109cd584792ee7f9dfac96f791db546df8f15f3f9c"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/b5/b4/205b0d5241d934e8add0c38aa924c4f9fb7330834ff11e5444db964ec3f9/starlette-1.6.0.tar.gz"
    sha256 "d4e3ac5e546444960c710297a3c9fc3f7ebae1b7e963f3d36173b49da535be9b"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/e4/e5/5f3cb2159769d0f4324c0e9e87f9de3c4b1cd45848a96b2eb3566ad5ca77/tiktoken-0.13.0.tar.gz"
    sha256 "c9435714c3a84c2319499de9a300c0e604449dd0799ff246458b3bb6a7f433c1"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/c1/60/21f715d9faba5f5407ff759472ade058ec4a507ad62bcea47cb847239a73/tokenizers-0.23.1.tar.gz"
    sha256 "1feeeadf865a7915adc25445dea30e9933e593c31bb96c277cee36de227c8bfa"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/21/3b/6c24bec5be5e743ffd99576daa5cc077722fc7d5bbc00bd133fa0c698dc6/tqdm-4.70.0.tar.gz"
    sha256 "55b0b0dbd97462d06ebee91e4dac24ed4d4702be82b24f07e6c1d27e08cea220"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/81/5b/879b2f932adfa7a053c360d50bc896c977fa6426109185f7c12ebdd0cb9d/tzlocal-5.4.4.tar.gz"
    sha256 "8dbb8660838688a7b6ba4fed31d18dedf842afb4d47ca050d6d891c2c15f3be4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/03/18/ccce41535dee1be77735592bd19965f3972c82e07ee703d324709496b716/uvicorn-0.52.1.tar.gz"
    sha256 "112ec661814189acbccd3f7b86460147cc065fc92c0821afa78918780e4354dd"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/06/f0/18d39dbd1971d6d62c4629cc7fa67f74821b0dc1f5a77af43719de7936a7/uvloop-0.22.1.tar.gz"
    sha256 "6c84bae345b9147082b17371e3dd5d42775bddce91f885499017f4607fdaf39f"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/34/74/c6428f875774288bec1396f5bfcbc2d925700a4dad61727fd5f2b12f249d/wcwidth-0.8.2.tar.gz"
    sha256 "91fbef97204b96a3d4d421609b80340b760cf33e26da123ff243d76b1fda8dda"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/e6/26d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1/websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/31/33/ebe9e3d1f86c7a0b51094c0a146392045ca1631d2664889539dec8088a33/yarl-1.24.5.tar.gz"
    sha256 "e81b83143bee16329c23db3c1b2d82b29892fcbcb849186d2f6e98a5abe9a57f"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/b9/d8/eab98a517c14134c0b2eb4e2387bc5f457334293ec5d2dd3857ec2966802/zipp-4.1.0.tar.gz"
    sha256 "4cb57381f544315db7688e976e922a2b18cdb513d21cc194eb42232ba2a3e602"
  end

  def install
    libexec.install Dir["*"]
    cd libexec do
      system "npm", "install", *std_npm_args(prefix: false), "--omit=dev"
      venv = virtualenv_create(libexec/".venv", "python3.14")
      # Only the resources that carry their own Rust workspace need the relaxed
      # toolchain below. Everything else must keep Homebrew's standard superenv:
      # PyNaCl configures a bundled libsodium and silently skips it without the
      # flags superenv injects, leaving _sodium.c unable to find sodium.h.
      # pip_install passes --no-deps, so splitting the set is safe -- every
      # version here is already pinned by the lock.
      relaxed, standard = resources.partition do |resource|
        ["litellm", "polars", "polars-runtime-32"].include?(resource.name)
      end
      # A PyO3 extension module leaves the Python C API symbols it calls to be
      # resolved by the interpreter at load time, so linking one on macOS needs
      # -undefined dynamic_lookup. maturin supplies that itself for some projects
      # and not others -- polars gets it, tokenizers does not, and tokenizers
      # fails with hundreds of undefined _Py* symbols. Non-Rust resources ignore
      # the flag, and Linux must not receive this macOS linker option.
      ENV.append_to_rustflags "-C link-arg=-Wl,-undefined,dynamic_lookup" if OS.mac?
      venv.pip_install standard
      # Homebrew's superenv shim strips every -O flag the caller passes and
      # substitutes HOMEBREW_OPTIMIZATION_LEVEL. That breaks a Rust resource
      # built through cc-rs whose vendored C insists on its own level:
      # litellm's python-bridge pulls aws-lc-sys, whose jitterentropy refuses
      # to compile unless optimization is off, and its deliberate -O0 never
      # survives. Dropping "O" from HOMEBREW_CCCFG turns that rewriting off;
      # cargo already picks correct release flags on its own.
      #
      # polars-runtime-32 turns on foldhash's "nightly" cargo feature, whose
      # #![feature(hasher_prefixfree_extras)] stable rustc rejects outright
      # (E0554). Polars publishes wheels built on a nightly toolchain and
      # Homebrew ships only stable, so the escape hatch upstream relies on is
      # the only way through. polars is not optional here: litellm declares it
      # under the "proxy" extra, and the proxy is what this router runs.
      #
      # polars also asks for thin LTO plus debug line tables, and linking it
      # that way needs far more scratch space than the crate itself: a machine
      # without tens of spare gigabytes fails as an LLVM write error,
      # surfacing only as a rustc SIGSEGV. Neither setting changes what the
      # router does with polars, so drop both rather than require headroom.
      with_env(
        HOMEBREW_CCCFG:                        ENV.fetch("HOMEBREW_CCCFG", "").delete("O"),
        RUSTC_BOOTSTRAP:                       "1",
        CARGO_PROFILE_RELEASE_LTO:             "false",
        CARGO_PROFILE_RELEASE_DEBUG:           "false",
        CARGO_PROFILE_RELEASE_SPLIT_DEBUGINFO: "off",
      ) do
        venv.pip_install relaxed
      end
      # Older release archives predate the dependency fingerprint helper. The
      # dependencies are already installed at this point, so those archives
      # remain usable; newer releases record fingerprints for faster updates.
      install_plan = libexec/"src/install-plan.mjs"
      if install_plan.exist?
        system formula_opt_bin("node")/"node", install_plan, "record", "node-deps"
        system formula_opt_bin("node")/"node", install_plan, "record", "python-deps"
      end
    end

    # bin/codex-router is the dispatcher written for exactly this case: a
    # package manager puts one name on PATH, not a directory of them. Routing
    # through "bin/model-router codex" instead stranded every command outside
    # that script's fixed whitelist -- curate-models, discover-models,
    # refresh-catalog, test-model, support-bundle, control -- and made a bare
    # "codex-router" or "codex-router --help" print model-router's usage.
    (bin/"codex-router").write <<~SH
      #!/bin/sh
      source_root=$(CDPATH= cd -- "#{opt_libexec}" && pwd -P)
      export PATH="#{formula_opt_bin("node")}:$PATH"
      export CODEX_ROUTER_SOURCE_ROOT="$source_root"
      export CODEX_ROUTER_NODE_BIN="#{formula_opt_bin("node")}/node"
      export CODEX_ROUTER_PACKAGE_MANAGER=homebrew
      exec "$source_root/bin/codex-router" "$@"
    SH

    # bin/codex-router deliberately refuses "install": a packaged install has
    # no writable checkout to rewrite, so it must never be a user-facing verb.
    # post_install still legitimately needs the installer after brew upgrade,
    # so it gets its own private entry point rather than a hole in the
    # dispatcher.
    (libexec/"packaged-install").write <<~SH
      #!/bin/sh
      source_root=$(CDPATH= cd -- "#{opt_libexec}" && pwd -P)
      export PATH="#{formula_opt_bin("node")}:$PATH"
      export CODEX_ROUTER_SOURCE_ROOT="$source_root"
      export CODEX_ROUTER_NODE_BIN="#{formula_opt_bin("node")}/node"
      export CODEX_ROUTER_PACKAGE_MANAGER=homebrew
      exec "$source_root/bin/install" "$@"
    SH
    chmod 0755, libexec/"packaged-install"
  end

  def post_install
    state_root = ENV["MODEL_ROUTER_STATE_DIR"] || ENV["CODEX_ROUTER_STATE_DIR"] ||
                 ENV["KIMI_CODEX_STATE_DIR"] || (Pathname(Dir.home)/".codex/codex-router")
    manifest_path = Pathname(state_root)/"install-manifest.json"
    return unless manifest_path.exist?

    manifest = JSON.parse(manifest_path.read)
    return if manifest.dig("current", "packageManager") != "homebrew"

    system libexec/"packaged-install"
  rescue JSON::ParserError
    opoo "Existing Codex Router install manifest is invalid; run `codex-router setup`."
  end

  def caveats
    <<~EOS
      Finish the one-time Codex integration with:
        codex-router setup --guided

      This formula installs the router and CLI only. It does not build or
      download the Electron Control Center, tray/menu-bar app, or macOS desktop
      widget. Use the recommended installer on the project homepage for the
      complete desktop experience.

      List every available command, including `codex-router curate-models`
      for adding a custom provider's models, with:
        codex-router help

      Before `brew uninstall codex-router`, remove the per-user service and
      managed Codex config with:
        codex-router uninstall
    EOS
  end

  test do
    output = shell_output("#{bin}/codex-router providers list --json")
    assert_match '"providers":', output
    assert_match '"anthropic-api"', output
    system formula_opt_bin("node")/"node", "--input-type=module", "--eval",
           "import('#{libexec}/node_modules/proper-lockfile/index.js')"
    system libexec/".venv/bin/python", "-c", "import fastapi, litellm"
  end
end
