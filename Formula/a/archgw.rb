class Archgw < Formula
  include Language::Python::Virtualenv

  desc "CLI for Arch Gateway"
  homepage "https://github.com/katanemo/archgw/tree/main/arch/tools"
  url "https://files.pythonhosted.org/packages/d6/96/90e4129b14fe6fdc03692818ee2831d51eb6759d6e17ce880c9cc70c74b8/archgw-0.3.18.tar.gz"
  sha256 "68bdebbf5854a3662d3e88b8ac55db6cfa916ff5ff8875ec3a200593bd75d4f3"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e144b097b025c7511e7ba787371ca70b5e93de7af342b8492f50af0abeb98ba7"
    sha256 cellar: :any,                 arm64_sequoia: "1710227a7e2f5c1ecf80f871e0ea3a6e4de2dd997c06674f003884d354ca4e73"
    sha256 cellar: :any,                 arm64_sonoma:  "079b92693c075dd2bbc1944b1886c582918dcd55cdfdd29f9301ff0192b0e25d"
    sha256 cellar: :any,                 sonoma:        "9d7fc45f61b602fec88459462181ce6032187a0013d30185712c6f41b2286ca9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0885b1a90e237b8ddf16fb79e0c09980d230b0cc07c89760e07e560ac1cc8f4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12c6824629413393c7f329f95d71e79a6bf25915967fc00e5adf00a3aee6602a"
  end

  depends_on "rust" => :build # for hf-xet, jitter and safetensors
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "pytorch"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: %w[certifi numpy pydantic rpds-py torch]

  resource "accelerate" do
    url "https://files.pythonhosted.org/packages/23/60/2757c4f03a8705dbf80b1268b03881927878dca5ed07d74f733fb6c219e0/accelerate-1.11.0.tar.gz"
    sha256 "bb1caf2597b4cd632b917b5000c591d10730bb024a79746f1ee205bba80bd229"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/c6/78/7d432127c41b50bccba979505f272c16cbcadcc33645d5fa3a738110ae75/anyio-4.11.0.tar.gz"
    sha256 "82a8d0b81e318cc5ce71a5f1f8b5c4e63619620b63141ef8c995fa0db95a57c4"
  end

  resource "archgw-modelserver" do
    url "https://files.pythonhosted.org/packages/60/87/bbb11cf400ca2b01e0de55a0e4c1b14280b08f3d1452714ec87beefa997f/archgw_modelserver-0.3.18.tar.gz"
    sha256 "9c32f48e0c7e0b886e803218c4289c0fb27362b567a02fba25e1bd8dd5a9fb65"
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
    url "https://files.pythonhosted.org/packages/5e/6e/0f11bacf08a67f7fb5ee09740f2ca54163863b07b70d579356e9222ce5d8/hf_xet-1.2.0.tar.gz"
    sha256 "a8c27070ca547293b6890c4bf389f713f80e8c478631432962bb7f4bc0bd7d7f"
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
    url "https://files.pythonhosted.org/packages/76/66/650a33bd90f786193e4de4b3ad86ea60b53c89b669a5c7be931fac31cdb0/importlib_metadata-8.7.0.tar.gz"
    sha256 "d13b81ad223b890aa16c5471f2ac3056cf76c5f10f82d6f9292f0b415f389000"
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
    url "https://files.pythonhosted.org/packages/08/d8/0f354c375628e048bd0570645b310797299754730079853095bf000fba69/opentelemetry_api-1.38.0.tar.gz"
    sha256 "f4c193b5e8acb0912b06ac5b16321908dd0843d75049c091487322284a3eea12"
  end

  resource "opentelemetry-exporter-otlp" do
    url "https://files.pythonhosted.org/packages/c2/2d/16e3487ddde2dee702bd746dd41950a8789b846d22a1c7e64824aac5ebea/opentelemetry_exporter_otlp-1.38.0.tar.gz"
    sha256 "2f55acdd475e4136117eff20fbf1b9488b1b0b665ab64407516e1ac06f9c3f9d"
  end

  resource "opentelemetry-exporter-otlp-proto-common" do
    url "https://files.pythonhosted.org/packages/19/83/dd4660f2956ff88ed071e9e0e36e830df14b8c5dc06722dbde1841accbe8/opentelemetry_exporter_otlp_proto_common-1.38.0.tar.gz"
    sha256 "e333278afab4695aa8114eeb7bf4e44e65c6607d54968271a249c180b2cb605c"
  end

  resource "opentelemetry-exporter-otlp-proto-grpc" do
    url "https://files.pythonhosted.org/packages/a2/c0/43222f5b97dc10812bc4f0abc5dc7cd0a2525a91b5151d26c9e2e958f52e/opentelemetry_exporter_otlp_proto_grpc-1.38.0.tar.gz"
    sha256 "2473935e9eac71f401de6101d37d6f3f0f1831db92b953c7dcc912536158ebd6"
  end

  resource "opentelemetry-exporter-otlp-proto-http" do
    url "https://files.pythonhosted.org/packages/81/0a/debcdfb029fbd1ccd1563f7c287b89a6f7bef3b2902ade56797bfd020854/opentelemetry_exporter_otlp_proto_http-1.38.0.tar.gz"
    sha256 "f16bd44baf15cbe07633c5112ffc68229d0edbeac7b37610be0b2def4e21e90b"
  end

  resource "opentelemetry-instrumentation" do
    url "https://files.pythonhosted.org/packages/04/ed/9c65cd209407fd807fa05be03ee30f159bdac8d59e7ea16a8fe5a1601222/opentelemetry_instrumentation-0.59b0.tar.gz"
    sha256 "6010f0faaacdaf7c4dff8aac84e226d23437b331dcda7e70367f6d73a7db1adc"
  end

  resource "opentelemetry-instrumentation-asgi" do
    url "https://files.pythonhosted.org/packages/b7/a4/cfbb6fc1ec0aa9bf5a93f548e6a11ab3ac1956272f17e0d399aa2c1f85bc/opentelemetry_instrumentation_asgi-0.59b0.tar.gz"
    sha256 "2509d6fe9fd829399ce3536e3a00426c7e3aa359fc1ed9ceee1628b56da40e7a"
  end

  resource "opentelemetry-instrumentation-fastapi" do
    url "https://files.pythonhosted.org/packages/ab/a7/7a6ce5009584ce97dbfd5ce77d4f9d9570147507363349d2cb705c402bcf/opentelemetry_instrumentation_fastapi-0.59b0.tar.gz"
    sha256 "e8fe620cfcca96a7d634003df1bc36a42369dedcdd6893e13fb5903aeeb89b2b"
  end

  resource "opentelemetry-proto" do
    url "https://files.pythonhosted.org/packages/51/14/f0c4f0f6371b9cb7f9fa9ee8918bfd59ac7040c7791f1e6da32a1839780d/opentelemetry_proto-1.38.0.tar.gz"
    sha256 "88b161e89d9d372ce723da289b7da74c3a8354a8e5359992be813942969ed468"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/85/cb/f0eee1445161faf4c9af3ba7b848cc22a50a3d3e2515051ad8628c35ff80/opentelemetry_sdk-1.38.0.tar.gz"
    sha256 "93df5d4d871ed09cb4272305be4d996236eedb232253e3ab864c8620f051cebe"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/40/bc/8b9ad3802cd8ac6583a4eb7de7e5d7db004e89cb7efe7008f9c8a537ee75/opentelemetry_semantic_conventions-0.59b0.tar.gz"
    sha256 "7a6db3f30d70202d5bf9fa4b69bc866ca6a30437287de6c510fb594878aed6b0"
  end

  resource "opentelemetry-util-http" do
    url "https://files.pythonhosted.org/packages/34/f7/13cd081e7851c42520ab0e96efb17ffbd901111a50b8252ec1e240664020/opentelemetry_util_http-0.59b0.tar.gz"
    sha256 "ae66ee91be31938d832f3b4bc4eb8a911f6eddd38969c4a871b1230db2a0a560"
  end

  resource "overrides" do
    url "https://files.pythonhosted.org/packages/36/86/b585f53236dec60aba864e050778b25045f857e17f6e5ea0ae95fe80edd2/overrides-7.7.0.tar.gz"
    sha256 "55158fa3d93b98cc75299b1e67078ad9003ca27945c76162c1c0766d6f91820a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/19/ff/64a6c8f420818bb873713988ca5492cba3a7946be57e027ac63495157d97/protobuf-6.33.0.tar.gz"
    sha256 "140303d5c8d2037730c548f8c7b93b20bb1dc301be280c378b82b8894589c954"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/88/bdd0a41e5857d5d703287598cbf08dad90aed56774ea52ae071bae9071b6/psutil-7.1.3.tar.gz"
    sha256 "6c86281738d77335af7aec228328e944b30930899ea760ecf33a4dba66be5e74"
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
    url "https://files.pythonhosted.org/packages/cc/a9/546676f25e573a4cf00fe8e119b78a37b6a8fe2dc95cda877b30889c9c45/regex-2025.11.3.tar.gz"
    sha256 "1fedc720f9bb2494ce31a58a1631f9c82df6a09b49c19517ea5cc280b4541e01"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
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

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/8f/aeb76c5b46e273670962298c23e7ddde79916cb74db802131d49a85e4b7d/wrapt-1.17.3.tar.gz"
    sha256 "f66eb08feaa410fe4eebd17f2a2c8e2e46d3476e9f8c783daa8e09e0faa666d0"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e3/02/0f2892c661036d50ede074e376733dca2ae7c6eb617489437771209d4180/zipp-3.23.0.tar.gz"
    sha256 "a07157588a12518c9d4034df3fbbee09c814741a33ff63c05fa29d26a2404166"
  end

  def install
    # hatch does not support a SOURCE_DATE_EPOCH before 1980.
    # Remove after https://github.com/pypa/hatch/pull/1999 is released.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    venv = virtualenv_install_with_resources(without: "hf-xet")

    resource("hf-xet").stage do
      if ENV.effective_arch == :armv8
        # Disable sha2-asm which requires a minimum of -march=armv8-a+crypto
        inreplace "data/Cargo.toml",
                  'sha2 = { workspace = true, features = ["asm"] }',
                  "sha2 = { workspace = true }"
      end
      venv.pip_install Pathname.pwd
    end

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
