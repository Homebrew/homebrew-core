class Archgw < Formula
  include Language::Python::Virtualenv

  desc "CLI for Arch Gateway"
  homepage "https://github.com/katanemo/archgw/tree/main/arch/tools"
  url "https://files.pythonhosted.org/packages/75/22/1fcf44dc8393382fe62ef6c28a108498ed1ee1a964174e39191cb6f5c133/archgw-0.3.7.tar.gz"
  sha256 "b8c69fcb3844beaaafcbc15b151e65d7acf49951402ecd5ec468cc0c509cb943"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5b9aa896aa2cbe5df37164c4dbd68c5644294780d3e1bbd7dfbedfad951d4f16"
    sha256 cellar: :any,                 arm64_sequoia: "69fd2e59bdca6fe89eb8c54a22e4a39b62490f0b87a359912ef4fbe0f8947b89"
    sha256 cellar: :any,                 arm64_sonoma:  "b8edd2ae80d2540e00c839243e4b99713602620835d7b247436f02fea7f02e75"
    sha256 cellar: :any,                 sonoma:        "b24feb6be53c7b88ef90e0b3c05ab3b9d251c733bf0c1350b3cb7c18d9d80bf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3805fecd91e59ff95c638ff1c58b77e8e0221d0fb5a12782486e55a72818c52b"
  end

  depends_on "rust" => :build # for pydantic
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "python@3.14"
  depends_on "pytorch"

  resource "accelerate" do
    url "https://files.pythonhosted.org/packages/b1/72/ff3961c19ee395c3d30ac630ee77bfb0e1b46b87edc504d4f83bb4a89705/accelerate-1.10.1.tar.gz"
    sha256 "3dea89e433420e4bfac0369cae7e36dcd6a56adfcfd38cdda145c6225eab5df8"
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
    url "https://files.pythonhosted.org/packages/b8/2c/6da7d9a28d02218bdecd6ad70e6cd31dd4180ee6b285b96fa574c3fd12e9/archgw_modelserver-0.3.15.tar.gz"
    sha256 "942792e8c776225227783ca9c91927abb74f795938f02f8b8662bfe655649674"
  end

  resource "asgiref" do
    url "https://files.pythonhosted.org/packages/46/08/4dfec9b90758a59acc6be32ac82e98d1fbfc321cb5cfa410436dbacf821c/asgiref-3.10.0.tar.gz"
    sha256 "d89f2d8cd8b56dada7d52fa7dc8075baa08fb836560710d38c292a7a3f78c04e"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
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

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0a/10/c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9a/filelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/39/24/33db22342cf4a2ea27c9955e6713140fedd51e8b141b5ce5260897020f1a/googleapis_common_protos-1.70.0.tar.gz"
    sha256 "0e1b44e0ea153e6594f9f394fef15193a68aaaea2d843f83e2742717ca753257"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/9d/f7/8963848164c7604efb3a3e6ee457fdb3a469653e19002bd24742473254f8/grpcio-1.75.1.tar.gz"
    sha256 "3e81d89ece99b9ace23a6916880baca613c03a799925afb2857887efa8b1b3d2"
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
    url "https://files.pythonhosted.org/packages/10/7e/a0a97de7c73671863ca6b3f61fa12518caf35db37825e43d63a70956738c/huggingface_hub-0.35.3.tar.gz"
    sha256 "350932eaa5cc6a4747efae85126ee220e4ef1b54e29d31c3b45c5612ddf0b32a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/cd/12/33e59336dca5be0c398a7482335911a33aa0e20776128f038019f1a95f1b/importlib_metadata-8.5.0.tar.gz"
    sha256 "71522656f0abace1d072b9e5481a48f07c138e00f079c38c8f883823f9c26bd7"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/9d/c0/a3bb4cc13aced219dd18191ea66e874266bd8aa7b96744e495e1c733aa2d/jiter-0.11.0.tar.gz"
    sha256 "1d9637eaf8c1d6a63d6562f2a6e5ab3af946c66037eb1b894e8fad75422266e4"
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

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/43/29/d09e70352e4e88c9c7a198d5645d7277811448d76c23b00345670f7c8a38/protobuf-5.29.5.tar.gz"
    sha256 "bc1463bafd4b0929216c35f437a8e28731a2b7fe3d98bb77a600efced5a15c84"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/b3/31/4723d756b59344b643542936e37a31d1d3204bcdc42a7daa8ee9eb06fb50/psutil-7.1.0.tar.gz"
    sha256 "655708b3c069387c8b77b072fc429a57d0e214221d01c0a772df7dfedcb3bcd2"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/ae/54/ecab642b3bed45f7d5f59b38443dcb36ef50f85af192e6ece103dbfe9587/pydantic-2.11.10.tar.gz"
    sha256 "dc280f0982fbda6c38fada4e476dc0a4f3aeaf9c6ad4c28df68a666ec3c61423"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/ad/88/5f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4/pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
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
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/49/d3/eaa0d28aba6ad1827ad1e716d9a93e1ba963ada61887498297d3da715133/regex-2025.9.18.tar.gz"
    sha256 "c5ba23274c61c6fef447ba6a39333297d0c247f53059dba0bca415cac511edc4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/e9/dd/2c0cbe774744272b0ae725f44032c77bdcab6e8bcf544bffa3b6e70c8dba/rpds_py-0.27.1.tar.gz"
    sha256 "26a1c73171d10b7acccbded82bf6a586ab8203601e565badc74bbbf8bc5a10f8"
  end

  resource "safetensors" do
    url "https://files.pythonhosted.org/packages/ac/cc/738f3011628920e027a11754d9cae9abec1aed00f7ae860abbf843755233/safetensors-0.6.2.tar.gz"
    sha256 "43ff2aa0e6fa2dc3ea5524ac7ad93a9839256b8703761e76e2d0b2a3fa4f15d9"
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
    url "https://files.pythonhosted.org/packages/f3/5c/a22c39dac2687f3fe2a6b97e2c1ae516e91cd4d3976a7a2b7c24ff2fae48/transformers-4.57.0.tar.gz"
    sha256 "d045753f3d93f9216e693cdb168698dfd2e9d3aad1bb72579a5d60ebf1545a8b"
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

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/8f/aeb76c5b46e273670962298c23e7ddde79916cb74db802131d49a85e4b7d/wrapt-1.17.3.tar.gz"
    sha256 "f66eb08feaa410fe4eebd17f2a2c8e2e46d3476e9f8c783daa8e09e0faa666d0"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e3/02/0f2892c661036d50ede074e376733dca2ae7c6eb617489437771209d4180/zipp-3.23.0.tar.gz"
    sha256 "a07157588a12518c9d4034df3fbbee09c814741a33ff63c05fa29d26a2404166"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/archgw --version")

    output = shell_output("#{bin}/archgw up 2>&1")
    assert_match "INFO - Error: #{testpath}/arch_config.yaml does not exist.", output
  end
end
