class Archgw < Formula
  include Language::Python::Virtualenv

  desc "CLI for Arch Gateway"
  homepage "https://github.com/katanemo/archgw/tree/main/arch/tools"
  url "https://files.pythonhosted.org/packages/26/e9/a05e4b61a71dc0f84f2d84e011f3bbfabfa4ca76887689f6dc8fca98b4e2/archgw-0.3.16.tar.gz"
  sha256 "00eeffb5e6c2300621160a6bb9233a75dc0b9baebe5b1f24831869cc93a3b7ca"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "268fe6e59d6dcd3141d817f98327cc638745cf6d054feb5ee05927640319dc06"
    sha256 cellar: :any,                 arm64_sequoia: "58ed34f0fc315c71e0ae110e22e2fc3a759f5c7aa31efedc8f70155a1213e349"
    sha256 cellar: :any,                 arm64_sonoma:  "833eafb593f7c831e5ff1bdc225c3589fa1a9dc7897e13ab3a05478549ad96d4"
    sha256 cellar: :any,                 sonoma:        "56cea7a390a5d0fd1344a833fb4626b2ff503ae7011c3f908ae9449461ae305d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb58037040a41d683a74838298ee30f39d54e28ac60a88a767a80805a4799862"
  end

  depends_on "rust" => :build # for pydantic
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "python@3.14"
  depends_on "pytorch"

  resource "accelerate" do
    url "https://files.pythonhosted.org/packages/23/60/2757c4f03a8705dbf80b1268b03881927878dca5ed07d74f733fb6c219e0/accelerate-1.11.0.tar.gz"
    sha256 "bb1caf2597b4cd632b917b5000c591d10730bb024a79746f1ee205bba80bd229"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/c6/78/7d432127c41b50bccba979505f272c16cbcadcc33645d5fa3a738110ae75/anyio-4.11.0.tar.gz"
    sha256 "82a8d0b81e318cc5ce71a5f1f8b5c4e63619620b63141ef8c995fa0db95a57c4"
  end

  resource "archgw-modelserver" do
    url "https://files.pythonhosted.org/packages/7e/de/f82a3125dc0280fbe1128d69cdc1d77c56999417ec765e718d387482f581/archgw_modelserver-0.3.16.tar.gz"
    sha256 "6ceded5a305d3987212565fb943ae7a822aebdf622886bfdc9d18c3c8a400e38"
  end

  resource "asgiref" do
    url "https://files.pythonhosted.org/packages/46/08/4dfec9b90758a59acc6be32ac82e98d1fbfc321cb5cfa410436dbacf821c/asgiref-3.10.0.tar.gz"
    sha256 "d89f2d8cd8b56dada7d52fa7dc8075baa08fb836560710d38c292a7a3f78c04e"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/a9/30/064144f0df1749e7bb5faaa7f52b007d7c2d08ec08fed8411aba87207f68/dateparser-1.2.2.tar.gz"
    sha256 "986316f17cb8cdc23ea8ce563027c5ef12fc725b6fb1d137c14ca08777c5ecf7"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/98/97/06afe62762c9a8a86af0cfb7bfdab22a43ad17138b07af5b1a58442690a2/deprecated-1.2.18.tar.gz"
    sha256 "422b6f6d859da6f2ef57857761bfb392480502a64c3028ca9bbe86085d72115d"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/7b/5e/bf0471f14bf6ebfbee8208148a3396d1a23298531a6cc10776c59f4c0f87/fastapi-0.115.0.tar.gz"
    sha256 "f93b4ca3529a8ebc6fc3fcf710e5efa8de3df9b41570958abf1d97d843138004"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/30/43/b25abe02db2911397819003029bef768f68a974f2ece483e6084d1a5f754/googleapis_common_protos-1.71.0.tar.gz"
    sha256 "1aec01e574e29da63c80ba9f7bbf1ccfaacf1da877f23609fe236ca7c72a2e2e"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/b6/e0/318c1ce3ae5a17894d5791e87aea147587c9e702f24122cc7a5c8bbaeeb1/grpcio-1.76.0.tar.gz"
    sha256 "7be78388d6da1a25c0d5ec506523db58b18be22d9c37d8d3a32c08be4987bd73"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/74/31/feeddfce1748c4a233ec1aa5b7396161c07ae1aa9b7bdbc9a72c3c7dd768/hf_xet-1.1.10.tar.gz"
    sha256 "408aef343800a2102374a883f283ff29068055c111f003ff840733d3b715bb97"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/78/82/08f8c936781f67d9e6b9eeb8a0c8b4e406136ea4c3d1f89a5db71d42e0e6/httpx-0.27.2.tar.gz"
    sha256 "f7c2be1d2f3c3c3160d441802406b206c2b76f5947b11115e6df10c6c65e66c2"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/98/63/4910c5fa9128fdadf6a9c5ac138e8b1b6cee4ca44bf7915bbfbce4e355ee/huggingface_hub-0.36.0.tar.gz"
    sha256 "47b3f0e2539c39bf5cde015d63b72ec49baff67b6931c3d97f3f84532e2b8d25"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/cd/12/33e59336dca5be0c398a7482335911a33aa0e20776128f038019f1a95f1b/importlib_metadata-8.5.0.tar.gz"
    sha256 "71522656f0abace1d072b9e5481a48f07c138e00f079c38c8f883823f9c26bd7"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/72/34/14ca021ce8e5dfedc35312d08ba8bf51fdd999c576889fc2c24cb97f4f10/iniconfig-2.3.0.tar.gz"
    sha256 "c76315c77db068650d49c5b56314774a7804df16fee4402c1f19d6d15d8c4730"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/a3/68/0357982493a7b20925aece061f7fb7a2678e3b232f8d73a6edb7e5304443/jiter-0.11.1.tar.gz"
    sha256 "849dcfc76481c0ea0099391235b7ca97d7279e0fa4c86005457ac7c88e8b76dc"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/c6/a1/a303104dc55fc546a3f6914c842d3da471c64eec92043aef8f652eb6c524/openai-1.109.1.tar.gz"
    sha256 "d173ed8dbca665892a6db099b4a2dfac624f94d20a93f46eb0b56aae940ed869"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/51/34/e4e9245c868c6490a46ffedf6bd5b0f512bbc0a848b19e3a51f6bbad648c/opentelemetry_api-1.28.2.tar.gz"
    sha256 "ecdc70c7139f17f9b0cf3742d57d7020e3e8315d6cffcdf1a12a905d45b19cc0"
  end

  resource "opentelemetry-exporter-otlp" do
    url "https://files.pythonhosted.org/packages/8a/eb/ad88c61b4e51cdd294ad4ae7c45b35120fb381eb019675954c4fc15b6c4c/opentelemetry_exporter_otlp-1.28.2.tar.gz"
    sha256 "45f8d7fe4cdd41526464b542ce91b1fd1ae661be92d2c6cba71a3d948b2bdf70"
  end

  resource "opentelemetry-exporter-otlp-proto-common" do
    url "https://files.pythonhosted.org/packages/60/cd/cd990f891b64e7698b8a6b6ab90dfac7f957db5a3d06788acd52f73ad4c0/opentelemetry_exporter_otlp_proto_common-1.28.2.tar.gz"
    sha256 "7aebaa5fc9ff6029374546df1f3a62616fda07fccd9c6a8b7892ec130dd8baca"
  end

  resource "opentelemetry-exporter-otlp-proto-grpc" do
    url "https://files.pythonhosted.org/packages/f7/4c/b5374467e97f2b290611de746d0e6cab3a07aec865d6b99d11535cd60059/opentelemetry_exporter_otlp_proto_grpc-1.28.2.tar.gz"
    sha256 "07c10378380bbb01a7f621a5ce833fc1fab816e971140cd3ea1cd587840bc0e6"
  end

  resource "opentelemetry-exporter-otlp-proto-http" do
    url "https://files.pythonhosted.org/packages/b1/91/4e32e52d13dbdf9560bc095dfe66a2c09e0034a886f7725fcda8fe10a052/opentelemetry_exporter_otlp_proto_http-1.28.2.tar.gz"
    sha256 "d9b353d67217f091aaf4cfe8693c170973bb3e90a558992570d97020618fda79"
  end

  resource "opentelemetry-instrumentation" do
    url "https://files.pythonhosted.org/packages/6f/1f/9fa51f6f64f4d179f4e3370eb042176ff7717682428552f5e1f4c5efcc09/opentelemetry_instrumentation-0.49b2.tar.gz"
    sha256 "8cf00cc8d9d479e4b72adb9bd267ec544308c602b7188598db5a687e77b298e2"
  end

  resource "opentelemetry-instrumentation-asgi" do
    url "https://files.pythonhosted.org/packages/84/42/079079bd7c0423bfab987a6457e34468b6ddccf501d3c91d2795c200d65d/opentelemetry_instrumentation_asgi-0.49b2.tar.gz"
    sha256 "2af5faf062878330714efe700127b837038c4d9d3b70b451ab2424d5076d6c1c"
  end

  resource "opentelemetry-instrumentation-fastapi" do
    url "https://files.pythonhosted.org/packages/87/ed/a1275d5aac63edfad0afb012d2d5917412f09ac5f773c86b465b2b0d2549/opentelemetry_instrumentation_fastapi-0.49b2.tar.gz"
    sha256 "3aa81ed7acf6aa5236d96e90a1218c5e84a9c0dce8fa63bf34ceee6218354b63"
  end

  resource "opentelemetry-proto" do
    url "https://files.pythonhosted.org/packages/d0/45/96c4f34c79fd87dc8a1c0c432f23a5a202729f21e4e63c8b36fc8e57767a/opentelemetry_proto-1.28.2.tar.gz"
    sha256 "7c0d125a6b71af88bfeeda16bfdd0ff63dc2cf0039baf6f49fa133b203e3f566"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/4b/f4/840a5af4efe48d7fb4c456ad60fd624673e871a60d6494f7ff8a934755d4/opentelemetry_sdk-1.28.2.tar.gz"
    sha256 "5fed24c5497e10df30282456fe2910f83377797511de07d14cec0d3e0a1a3110"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/7d/0a/e3b93f94aa3223c6fd8e743502a1fefd4fb3a753d8f501ce2a418f7c0bd4/opentelemetry_semantic_conventions-0.49b2.tar.gz"
    sha256 "44e32ce6a5bb8d7c0c617f84b9dc1c8deda1045a07dc16a688cc7cbeab679997"
  end

  resource "opentelemetry-util-http" do
    url "https://files.pythonhosted.org/packages/96/28/ac5b1a0fd210ecb6c86c5e04256ba09c8308eb41e116097b9e2714d4b8dd/opentelemetry_util_http-0.49b2.tar.gz"
    sha256 "5958c7009f79146bbe98b0fdb23d9d7bf1ea9cd154a1c199029b1a89e0557199"
  end

  resource "overrides" do
    url "https://files.pythonhosted.org/packages/36/86/b585f53236dec60aba864e050778b25045f857e17f6e5ea0ae95fe80edd2/overrides-7.7.0.tar.gz"
    sha256 "55158fa3d93b98cc75299b1e67078ad9003ca27945c76162c1c0766d6f91820a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/43/29/d09e70352e4e88c9c7a198d5645d7277811448d76c23b00345670f7c8a38/protobuf-5.29.5.tar.gz"
    sha256 "bc1463bafd4b0929216c35f437a8e28731a2b7fe3d98bb77a600efced5a15c84"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/89/fc/889242351a932d6183eec5df1fc6539b6f36b6a88444f1e63f18668253aa/psutil-7.1.1.tar.gz"
    sha256 "092b6350145007389c1cfe5716050f02030a05219d90057ea867d18fe8d372fc"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/f3/1e/4f0a3233767010308f2fd6bd0814597e3f63f1dc98304a9112b8759df4ff/pydantic-2.12.3.tar.gz"
    sha256 "1da1c82b0fc140bb0103bc1441ffe062154c8d38491189751ee00fd8ca65ce74"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/df/18/d0944e8eaaa3efd0a91b0f1fc537d3be55ad35091b6a87638211ba691964/pydantic_core-2.41.4.tar.gz"
    sha256 "70e47929a9d4a1905a67e4b687d5946026390568a8e952b92824118063cee4d5"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/a3/5c/00a0e072241553e1a7496d638deababa67c5058571567b92a7eaa258397c/pytest-8.4.2.tar.gz"
    sha256 "86c0d0b93306b961d58d62a4db4879f27fe25513d4b969df351abdddb3c30e01"
  end

  resource "pytest-asyncio" do
    url "https://files.pythonhosted.org/packages/42/86/9e3c5f48f7b7b638b216e4b9e645f54d199d7abbbab7a64a13b4e12ba10f/pytest_asyncio-1.2.0.tar.gz"
    sha256 "c609a64a2a8768462d0c99811ddb8bd2583c33fd33cf7f21af1c142e824ffb57"
  end

  resource "pytest-httpserver" do
    url "https://files.pythonhosted.org/packages/f1/d8/def15ba33bd696dd72dd4562a5287c0cba4d18a591eeb82e0b08ab385afc/pytest_httpserver-1.1.3.tar.gz"
    sha256 "af819d6b533f84b4680b9416a5b3f67f1df3701f1da54924afd4d6e4ba5917ec"
  end

  resource "pytest-retry" do
    url "https://files.pythonhosted.org/packages/c5/5b/607b017994cca28de3a1ad22a3eee8418e5d428dcd8ec25b26b18e995a73/pytest_retry-1.7.0.tar.gz"
    sha256 "f8d52339f01e949df47c11ba9ee8d5b362f5824dff580d3870ec9ae0057df80f"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/f8/c8/1d2160d36b11fbe0a61acb7c3c81ab032d9ec8ad888ac9e0a61b85ab99dd/regex-2025.10.23.tar.gz"
    sha256 "8cbaf8ceb88f96ae2356d01b9adf5e6306fa42fa6f7eab6b97794e37c959ac26"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/48/dc/95f074d43452b3ef5d06276696ece4b3b5d696e7c9ad7173c54b1390cd70/rpds_py-0.28.0.tar.gz"
    sha256 "abd4df20485a0983e2ca334a216249b6186d6e3c1627e106651943dbdb791aea"
  end

  resource "safetensors" do
    url "https://files.pythonhosted.org/packages/ac/cc/738f3011628920e027a11754d9cae9abec1aed00f7ae860abbf843755233/safetensors-0.6.2.tar.gz"
    sha256 "43ff2aa0e6fa2dc3ea5524ac7ad93a9839256b8703761e76e2d0b2a3fa4f15d9"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/42/b4/e25c3b688ef703d85e55017c6edd0cbf38e5770ab748234363d54ff0251a/starlette-0.38.6.tar.gz"
    sha256 "863a1588f5574e70a821dadefb41e4881ea451a47a3cd1b4df359d4ffefe5ead"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/1c/46/fb6854cec3278fbfa4a75b50232c77622bc517ac886156e6afbfa4d8fc6e/tokenizers-0.22.1.tar.gz"
    sha256 "61de6522785310a309b3407bac22d99c4db5dba349935e99e4d15ea2226af2d9"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "transformers" do
    url "https://files.pythonhosted.org/packages/d6/68/a39307bcc4116a30b2106f2e689130a48de8bd8a1e635b5e1030e46fcd9e/transformers-4.57.1.tar.gz"
    sha256 "f06c837959196c75039809636cd964b959f6604b75b8eeec6fdfc0440b89cc55"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/8b/2e/c14812d3d4d9cd1773c6be938f89e5735a1f11a9f184ac3639b93cef35d5/tzlocal-5.3.1.tar.gz"
    sha256 "cceffc7edecefea1f595541dbd6e990cb1ea3d19bf01b2809f362a03dd7921fd"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/0a/96/ee52d900f8e41cc35eaebfda76f3619c2e45b741f3ee957d6fe32be1b2aa/uvicorn-0.31.0.tar.gz"
    sha256 "13bc21373d103859f68fe739608e2eb054a816dea79189bc3ca08ea89a275906"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/9f/69/83029f1f6300c5fb2471d621ab06f6ec6b3324685a2ce0f9777fd4a8b71e/werkzeug-3.1.3.tar.gz"
    sha256 "60723ce945c19328679790e3282cc758aa4a6040e4bb330f53d30fa546d44746"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/8f/aeb76c5b46e273670962298c23e7ddde79916cb74db802131d49a85e4b7d/wrapt-1.17.3.tar.gz"
    sha256 "f66eb08feaa410fe4eebd17f2a2c8e2e46d3476e9f8c783daa8e09e0faa666d0"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e3/02/0f2892c661036d50ede074e376733dca2ae7c6eb617489437771209d4180/zipp-3.23.0.tar.gz"
    sha256 "a07157588a12518c9d4034df3fbbee09c814741a33ff63c05fa29d26a2404166"
  end

  def install
    venv = virtualenv_install_with_resources

    # NOTE: This is an exception to our usual policy as building `pytorch` is complicated
    site_packages = Language::Python.site_packages(venv.root/"bin/python3")
    pth_contents = "import site; site.addsitedir('#{Formula["pytorch"].opt_libexec/site_packages}')\n"
    (venv.site_packages/"homebrew-pytorch.pth").write pth_contents
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/archgw --version")

    output = shell_output("#{bin}/archgw up 2>&1")
    assert_match "INFO - Error: #{testpath}/arch_config.yaml does not exist.", output
  end
end
