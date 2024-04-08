class Mentat < Formula
  include Language::Python::Virtualenv

  desc "Coding assistant that leverages GPT-4 to write code"
  homepage "https://www.mentat.ai"
  url "https://files.pythonhosted.org/packages/50/d8/73a5ab6b12366d168bd444347a87a4f37f538920bff8f351686291162101/mentat-1.0.14.tar.gz"
  sha256 "bc9a19118059d85282420196b771f97875845aed824e11dc6ffb2efb0b68e6e6"
  license "Apache-2.0"
  head "https://github.com/AbanteAI/mentat.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "fc00b77988a9a8a4340982902a5cd8dad7aa306d025e11f515c402d60687e1db"
    sha256 cellar: :any,                 arm64_ventura:  "053695aacf4cbd4dad4b255612eb6c142272a7281341aa250a1755dd9ac3b2f5"
    sha256 cellar: :any,                 arm64_monterey: "faef7869c991b8ddc9ec9e364a2389574ec263c3f8e9809b3f6d3d13674ca425"
    sha256 cellar: :any,                 sonoma:         "0f373181a8bedc295a215cc60b2e23afcdbfa24f117bbdc6a197ac8afa2b0c85"
    sha256 cellar: :any,                 ventura:        "bcbab6c80533d02e1ac815d02524bd79141d1e4bc55f981c4cbbf7cde105121f"
    sha256 cellar: :any,                 monterey:       "0fde82abf9d1aa37e6ce1bbce3f189bdff5acd81c2a0a6cf3baeed32d53997d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "197480a5581431a063dbeafc0474641e86b64801ec0752f684d2111bfdb4de2d"
  end

  depends_on "autoconf" => :build # for chroma-hnswlib
  depends_on "automake" => :build # for chroma-hnswlib
  depends_on "cmake" => :build # for chroma-hnswlib
  depends_on "libtool" => :build # for chroma-hnswlib
  depends_on "ninja" => :build # for chroma-hnswlib
  depends_on "rust" => :build # for tiktoken
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "onnxruntime"
  depends_on "pillow"
  depends_on "python@3.12"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/67/fe/8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4/annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "anthropic" do
    url "https://files.pythonhosted.org/packages/1b/2d/7be8f53faba0ca14ea20d31ebc53a2a27a8ab76672d993c12198b69dda39/anthropic-0.23.1.tar.gz"
    sha256 "9325103702cbc96bb09d1b58c36bde75c726f6a01029fb4d85f41ebba07e9066"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/28/99/2dfd53fd55ce9838e6ff2d4dac20ce58263798bd1a0dbe18b3a9af3fcfce/anyio-3.7.1.tar.gz"
    sha256 "44a3c9aba0f5defa43261a8b3efb97891f2bd7d804e0e1f56419befa1adfc780"
  end

  resource "asgiref" do
    url "https://files.pythonhosted.org/packages/29/38/b3395cc9ad1b56d2ddac9970bc8f4141312dbaec28bc7c218b0dfafd0f42/asgiref-3.8.1.tar.gz"
    sha256 "c343bd80a0bec947a9860adb4c432ffa7db769836c64238fc34bdc3fec84d590"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/72/07/6a6f2047a9dc9d012b7b977e4041d37d078b76b44b7ee4daf331c1e6fb35/bcrypt-4.1.2.tar.gz"
    sha256 "33313a1200a3ae90b75587ceac502b048b840fc69e7f7a0905b5f87fac7a1258"
  end

  resource "build" do
    url "https://files.pythonhosted.org/packages/ce/9e/2d725d2f7729c6e79ca62aeb926492abbc06e25910dd30139d60a68bcb19/build-1.2.1.tar.gz"
    sha256 "526263f4870c26f26c433545579475377b2b7588b6f1eac76a001e873ae3e19d"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/b3/4d/27a3e6dd09011649ad5210bdf963765bc8fa81a0827a4fc01bafd2705c5b/cachetools-5.3.3.tar.gz"
    sha256 "ba29e2dfa0b8b556606f097407ed1aa62080ee108ab0dc5ec9d6a723a007d105"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/68/ce/95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91d/cffi-1.16.0.tar.gz"
    sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "chroma-hnswlib" do
    url "https://files.pythonhosted.org/packages/c0/59/1224cbae62c7b84c84088cdf6c106b9b2b893783c000d22c442a1672bc75/chroma-hnswlib-0.7.3.tar.gz"
    sha256 "b6137bedde49fffda6af93b0297fe00429fc61e5a072b1ed9377f909ed95a932"
  end

  resource "chromadb" do
    url "https://files.pythonhosted.org/packages/4c/7f/a7c236da31cb4305d418865c4cd3a361ebf5bdcf0fd9b0c6ece9db458544/chromadb-0.4.22.tar.gz"
    sha256 "c793149e1c2bbbb52d77602c6c0594c5752f04cd9be12619250ddad2082af27a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/cc/c7/eed8f27100517e8c0e6b923d5f0845d0cb99763da6fdee00478f91db7325/coloredlogs-15.0.1.tar.gz"
    sha256 "7c991aa71a4577af2f82600d8f8f3a89f936baeaf9b50a9c197da014e5bf16b0"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/92/14/1e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232/Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/6d/f7/c6a62efe7f0ff70721392592bde14c69651868dca198d7ace51a1019b479/fastapi-0.110.1.tar.gz"
    sha256 "6feac43ec359dfe4f45b2c18ec8c94edb8dc2dfc461d417d9e626590c071baad"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/db/97/3f028f216da17ab0500550a6bb0f26bf39b07848348f63cce44b89829af9/filelock-3.13.3.tar.gz"
    sha256 "a79895a25bbefdf55d1a2a0a80968f7dbb28edcd6d4234a0afb3f37ecde4b546"
  end

  resource "fire" do
    url "https://files.pythonhosted.org/packages/94/ed/3b9a10605163f48517931083aee8364d4d6d3bb1aa9b75eb0a4a5e9fbfc1/fire-0.5.0.tar.gz"
    sha256 "a6b0d49e98c8963910021f92bba66f65ab440da2982b78eb1bbf95a0a34aacc6"
  end

  resource "flatbuffers" do
    url "https://files.pythonhosted.org/packages/a9/74/2df95ef84b214d2bee0886d572775a6f38793f5ca6d7630c3239c91104ac/flatbuffers-24.3.25.tar.gz"
    sha256 "de2ec5b203f21441716617f38443e0a8ebf3d25bf0d9c0bb0ce68fa00ad546a4"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/8b/b8/e3ba21f03c00c27adc9a8cd1cab8adfb37b6024757133924a9a4eab63a83/fsspec-2024.3.1.tar.gz"
    sha256 "f39780e282d7d117ffb42bb96992f8a90795e4d0fb0f661a70ca39fe9c43ded9"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/19/0d/bbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8ed/gitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/e5/c2/6e3a26945a7ff7cf2854b8825026cf3f22ac8e18285bc11b6b1ceeb8dc3f/GitPython-3.1.41.tar.gz"
    sha256 "ed66e624884f76df22c8e16066d567aaa5a37d5b5fa19db2c6df6f7156db9048"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/18/b2/f14129111cfd61793609643a07ecb03651a71dd65c6974f63b0310ff4b45/google-auth-2.29.0.tar.gz"
    sha256 "672dff332d073227550ffc7457868ac4218d6c500b155fe6cc17d2b13602c360"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/d2/dc/291cebf3c73e108ef8210f19cb83d671691354f4f7dd956445560d778715/googleapis-common-protos-1.63.0.tar.gz"
    sha256 "17ad01b11d5f1d0171c06d3ba5c04c54474e883b66b949722b4938ee2694ef4e"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/c7/bb/d01494037edee2d8e024cac8049b169b2723186b01cebb495ccf677bbba9/grpcio-1.62.1.tar.gz"
    sha256 "6c455e008fa86d9e9a9d85bb76da4277c0d7d9668a3bfa70dbe86e9f3c759947"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/17/b0/5e8b8674f8d203335a62fdfcfa0d11ebe09e23613c3391033cbba35f7926/httpcore-1.0.5.tar.gz"
    sha256 "34a38e2f9291467ee3b44e89dd52615370e152954ba21721378a87b2960f7a61"
  end

  resource "httptools" do
    url "https://files.pythonhosted.org/packages/67/1d/d77686502fced061b3ead1c35a2d70f6b281b5f723c4eff7a2277c04e4a2/httptools-0.6.1.tar.gz"
    sha256 "c6e26c30455600b95d94b1b836085138e82f177351454ee841c148f93a9bad5a"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/1c/fe/c0523094193929a68b288e0ae3eb865725f1ee9faca0f21693a86e96c943/httpx-0.25.1.tar.gz"
    sha256 "ffd96d5cf901e63863d9f1b4b6807861dbea4d301613415d9e6e57ead15fc5d0"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/42/4c/1ee8ca0aebca6ac985b65c65a443015dec969c2ed40e3599f3a801312d48/huggingface_hub-0.22.2.tar.gz"
    sha256 "32e9a9a6843c92f253ff9ca16b9985def4d80a93fb357af5353f770ef74a81be"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/db/5a/392426ddb5edfebfcb232ab7a47e4a827aa1d5b5267a5c20c448615feaa9/importlib_metadata-7.0.0.tar.gz"
    sha256 "7fc841f8b8332803464e5dc1c63a2e59121f46ca186c0e2e182e80bf8c1319f7"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/c8/9d/6ee73859d6be81c6ea7ebac89655e92740296419bd37e5c8abdb5b62fd55/importlib_resources-6.4.0.tar.gz"
    sha256 "cdb2b453b8046ca4e3798eb1d84f3cce1446a0e8e7b5ef4efb600f19fc398145"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/d7/4b/cbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913/iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/4d/c5/3f6165d3df419ea7b0990b3abed4ff348946a826caf0e7c990b65ff7b9be/jsonschema-4.21.1.tar.gz"
    sha256 "85727c00279f5fa6bedbe6238d2aa6403bedd8b4864ab11207d07df3cc1b2ee5"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/f8/b9/cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4b/jsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "kubernetes" do
    url "https://files.pythonhosted.org/packages/de/07/d01320a808abaab3426db63476adcb31f7e23fe8c08aef175d7883ea978a/kubernetes-29.0.0.tar.gz"
    sha256 "c4812e227ae74d07d53c88293e564e54b850452715a59a927e7e1bc6b9a60459"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2a/ae/bb56c6828e4797ba5a4821eec7c43b8bf40f69cda4d4f5f8c8a2810ec96a/linkify-it-py-2.0.3.tar.gz"
    sha256 "68cda27e162e9215c17d786649d1da0021a451bdc436ef9e0fa0ba5234b9b048"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/b4/db/61960d68d5c39ff0dd48cb799a39ae4e297f6e9b96bf2f8da29d897fba0c/mdit_py_plugins-0.4.0.tar.gz"
    sha256 "d8ab27e9aed6c38aa716819fedfde15ca275715955f8a185a8e1cf90fb1d2c1b"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mmh3" do
    url "https://files.pythonhosted.org/packages/63/96/aa247e82878b123468f0079ce2ac77e948315bab91ce45d2934a62e0af95/mmh3-4.1.0.tar.gz"
    sha256 "a1cf25348b9acd229dda464a094d6170f47d2850a1fcb762a3b6172d2ce6ca4a"
  end

  resource "monotonic" do
    url "https://files.pythonhosted.org/packages/ea/ca/8e91948b782ddfbd194f323e7e7d9ba12e5877addf04fb2bf8fca38e86ac/monotonic-1.6.tar.gz"
    sha256 "3a55207bcfed53ddd5c5bae174524062935efed17792e9de2ad0205ce9ad63f7"
  end

  resource "mpmath" do
    url "https://files.pythonhosted.org/packages/e0/47/dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57/mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/55/b3/b13bce39ba82b7398c06d10446f5ffd5c07db39b09bd37370dc720c7951c/numpy-1.26.0.tar.gz"
    sha256 "f93fc78fe8bf15afe2b8d6b6499f1c73953169fad1e9a8dd086cdff3190e7fdf"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/1c/3c/a92cf8844ec4bf3211a42926ed5cab72f18d32bb3a0155a759783b38d6b5/openai-1.3.0.tar.gz"
    sha256 "51d9ccd0611fd8567ff595e8a58685c20a4710763d42f6bd968e1fb630993f25"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/3a/9e/77153a81a6eba4efcc28d8a4a00ae1b619108bf0225a879fb7084cb402db/opentelemetry_api-1.24.0.tar.gz"
    sha256 "42719f10ce7b5a9a73b10a4baf620574fb8ad495a9cbe5c18d76b75d8689c67e"
  end

  resource "opentelemetry-exporter-otlp-proto-common" do
    url "https://files.pythonhosted.org/packages/1f/8e/cd1087d2cf8efc5dfca813c87856ac7ecaeb14078c2bdffc51d6e2a734d9/opentelemetry_exporter_otlp_proto_common-1.24.0.tar.gz"
    sha256 "5d31fa1ff976cacc38be1ec4e3279a3f88435c75b38b1f7a099a1faffc302461"
  end

  resource "opentelemetry-exporter-otlp-proto-grpc" do
    url "https://files.pythonhosted.org/packages/2c/8a/ec5de727903f4e93ad33e2f1472cc9df68d5bb87c2cbb0132ac30777854a/opentelemetry_exporter_otlp_proto_grpc-1.24.0.tar.gz"
    sha256 "217c6e30634f2c9797999ea9da29f7300479a94a610139b9df17433f915e7baa"
  end

  resource "opentelemetry-instrumentation" do
    url "https://files.pythonhosted.org/packages/b2/bd/dcf2c4c1132c580b60b548b17c4d115f1a2224961eac0a0138bf5f84d751/opentelemetry_instrumentation-0.45b0.tar.gz"
    sha256 "6c47120a7970bbeb458e6a73686ee9ba84b106329a79e4a4a66761f933709c7e"
  end

  resource "opentelemetry-instrumentation-asgi" do
    url "https://files.pythonhosted.org/packages/26/a5/dd1ed5e97ee8665413b329a890872422d07c83e15358c07356722bf85a7c/opentelemetry_instrumentation_asgi-0.45b0.tar.gz"
    sha256 "97f55620f163fd3d20323e9fd8dc3aacc826c03397213ff36b877e0f4b6b08a6"
  end

  resource "opentelemetry-instrumentation-fastapi" do
    url "https://files.pythonhosted.org/packages/b7/22/8796f545772847ee22b982a508cef3fe66ae71c6c1c8fa7aad475f388b18/opentelemetry_instrumentation_fastapi-0.45b0.tar.gz"
    sha256 "5a6b91e1c08a01601845fcfcfdefd0a2aecdb3c356d4a436a3210cb58c21487e"
  end

  resource "opentelemetry-proto" do
    url "https://files.pythonhosted.org/packages/69/7a/6630ab9b937603137fa91b74053fb78cdc446db9f83ce1c86d6a71c48768/opentelemetry_proto-1.24.0.tar.gz"
    sha256 "ff551b8ad63c6cabb1845ce217a6709358dfaba0f75ea1fa21a61ceddc78cab8"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/a2/e3/38a0ee0aa9dc5886e3235f4c83bf374a351109332191394147f79a484c31/opentelemetry_sdk-1.24.0.tar.gz"
    sha256 "75bc0563affffa827700e0f4f4a68e1e257db0df13372344aebc6f8a64cde2e5"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/8d/f8/c8de6e148aedf56adf16981ed590d05e7bbe5594f6dfdd4eb780c5da0358/opentelemetry_semantic_conventions-0.45b0.tar.gz"
    sha256 "7c84215a44ac846bc4b8e32d5e78935c5c43482e491812a0bb8aaf87e4d92118"
  end

  resource "opentelemetry-util-http" do
    url "https://files.pythonhosted.org/packages/03/99/6784a4f7fea0d2ef818a9ccbd8ea43abc163ab6f95a13b1e27edce66dafe/opentelemetry_util_http-0.45b0.tar.gz"
    sha256 "4ce08b6a7d52dd7c96b7705b5b4f06fdb6aa3eac1233b3b0bfef8a0cab9a92cd"
  end

  resource "outcome" do
    url "https://files.pythonhosted.org/packages/98/df/77698abfac98571e65ffeb0c1fba8ffd692ab8458d617a0eed7d9a8d38f2/outcome-1.3.0.post0.tar.gz"
    sha256 "9dcf02e65f2971b80047b377468e72a268e15c0af3cf1238e6ff14f7f91143b8"
  end

  resource "overrides" do
    url "https://files.pythonhosted.org/packages/36/86/b585f53236dec60aba864e050778b25045f857e17f6e5ea0ae95fe80edd2/overrides-7.7.0.tar.gz"
    sha256 "55158fa3d93b98cc75299b1e67078ad9003ca27945c76162c1c0766d6f91820a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/54/c6/43f9d44d92aed815e781ca25ba8c174257e27253a94630d21be8725a2b59/pluggy-1.4.0.tar.gz"
    sha256 "8c85c2876142a764e5b7548e7d9a0e0ddb46f5185161049a79b7e974454223be"
  end

  resource "posthog" do
    url "https://files.pythonhosted.org/packages/d8/c8/8a7308d5355fedfc400098a75fd191cf615b55aa22ef2a937995326e6f5e/posthog-3.5.0.tar.gz"
    sha256 "8f7e3b2c6e8714d0c0c542a2109b83a7549f63b7113a133ab2763a89245ef2ef"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/9a/02/76cadde6135986dc1e82e2928f35ebeb5a1af805e2527fe466285593a2ba/prompt_toolkit-3.0.39.tar.gz"
    sha256 "04505ade687dc26dc4284b1ad19a83be2f2afe83e7a828ace0c72f3a1df72aac"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/5e/d8/65adb47d921ce828ba319d6587aa8758da022de509c3862a70177a958844/protobuf-4.25.3.tar.gz"
    sha256 "25b5d0b42fd000320bd7830b349e3b696435f3b329810427a6bcce6a5492cc5c"
  end

  resource "pulsar-client" do
    url "https://github.com/apache/pulsar-client-python/archive/refs/tags/v3.4.0.tar.gz"
    sha256 "285136ff55612a7b0e8003373b6ef252a22f5e3be6629bbad6cff0d41ef7ee77"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/4a/a3/d2157f333900747f20984553aca98008b6dc843eb62f3a36030140ccec0d/pyasn1-0.6.0.tar.gz"
    sha256 "3a35ab2c4b5ef98e17dfdec8ab074046fbda76e281c5a706ccd82328cfc8f64c"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/f7/00/e7bd1dec10667e3f2be602686537969a7ac92b0a7c5165be2e5875dc3971/pyasn1_modules-0.4.0.tar.gz"
    sha256 "831dbcea1b177b28c9baddf4c6d1013c24c3accd14a1873fffaa6a2e905f17b6"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1d/b2/31537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52c/pycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/4b/de/38b517edac45dd022e5d139aef06f9be4762ec2e16e2b14e1634ba28886b/pydantic-2.6.4.tar.gz"
    sha256 "b1704e0847db01817624a6b86766967f552dd9dbf3afba4004409f908dcc84e6"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/77/3f/65dbe5231946fe02b4e6ea92bc303d2462f45d299890fd5e8bfe4d1c3d66/pydantic_core-2.16.3.tar.gz"
    sha256 "1cac689f80a3abab2d3c0048b29eea5751114054f032a941a32de4c852c59cad"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/89/6b/2114e54b290824197006e41be3f9bbe1a26e9c39d1f5fa20a6d62945a0b3/Pygments-2.15.1.tar.gz"
    sha256 "8ace4d3c1dd481894b2005f560ead0f9f19ee64fe983366be1a21e171d12775c"
  end

  resource "pypika" do
    url "https://files.pythonhosted.org/packages/c7/2c/94ed7b91db81d61d7096ac8f2d325ec562fc75e35f3baea8749c85b28784/PyPika-0.48.9.tar.gz"
    sha256 "838836a61747e7c8380cd1b7ff638694b7a7335345d0f559b04b2cd832ad5378"
  end

  resource "pyproject-hooks" do
    url "https://files.pythonhosted.org/packages/25/c1/374304b8407d3818f7025457b7366c8e07768377ce12edfe2aa58aa0f64c/pyproject_hooks-1.0.0.tar.gz"
    sha256 "f271b298b97f5955d53fb12b72c1fb1948c22c1a6b70b315c54cedaca0264ef5"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/a7/f3/dadfbdbf6b6c8b5bd02adb1e08bc9fbb45ba51c68b0893fa536378cdf485/pytest-7.4.0.tar.gz"
    sha256 "b4bf8c45bd59934ed84001ad51e11b4ee40d40a1229d2c79f9c592b0a3f6bd8a"
  end

  resource "pytest-asyncio" do
    url "https://files.pythonhosted.org/packages/5a/85/d39ef5f69d5597a206f213ce387bcdfa47922423875829f7a98a87d33281/pytest-asyncio-0.21.1.tar.gz"
    sha256 "40a7eae6dded22c7b604986855ea48400ab15b069ae38116e8c01238e9eeb64d"
  end

  resource "pytest-mock" do
    url "https://files.pythonhosted.org/packages/d8/2d/b3a811ec4fa24190a9ec5013e23c89421a7916167c6240c31fdc445f850c/pytest-mock-3.11.1.tar.gz"
    sha256 "7f6b125602ac6d743e523ae0bfa71e1a697a2f5534064528c6ff84c2f7c2fc7f"
  end

  resource "pytest-reportlog" do
    url "https://files.pythonhosted.org/packages/da/a0/d1372b23d415a0766389480633a676fb1530e94ae8f6ea84619cae0ac215/pytest-reportlog-0.4.0.tar.gz"
    sha256 "c9f2079504ee51f776d3118dcf5e4730f163d3dcf26ebc8f600c1fa307bf638c"
  end

  resource "pytest-timeout" do
    url "https://files.pythonhosted.org/packages/2a/b0/8e3182e9ed65ad5b247f9d13769f214fc52b0d3522c3e1c8dbfa2f879e5a/pytest-timeout-2.2.0.tar.gz"
    sha256 "3b0b95dabf3cb50bac9ef5ca912fa0cfc286526af17afc806824df20c2f72c90"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/31/06/1ef763af20d0572c032fa22882cfbfb005fba6e7300715a37840858c919e/python-dotenv-1.0.0.tar.gz"
    sha256 "a8df96034aae6d2d50a4ebe8216326c61c3eb64836776504fcca410e5937a3ba"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/59/d7/48b862b8133da2e0ed091195028f0d45c4d0be0f7f23dbe046a767282f37/referencing-0.34.0.tar.gz"
    sha256 "5773bd84ef41799a5a8ca72dc34590c041eb01bf9aa02632b4a973fb0181a844"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/b5/39/31626e7e75b187fae7f121af3c538a991e725c744ac893cc2cfd70ce2853/regex-2023.12.25.tar.gz"
    sha256 "29171aa128da69afdf4bde412d5bedc335f2ca8fcfe4489038577d05f16181e5"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/01/c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aa/rich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/55/ba/ce7b9f0fc5323f20ffdf85f682e51bee8dc03e9b54503939ebb63d1d0d5e/rpds_py-0.18.0.tar.gz"
    sha256 "42821446ee7a76f5d9f71f9e33a4fb2ffd724bb3e7f93386150b61a43115788d"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "selenium" do
    url "https://files.pythonhosted.org/packages/04/44/e86a333a57dd81739126f78c73f2243af2bfb728787a7c66046eb923c02e/selenium-4.15.2.tar.gz"
    sha256 "22eab5a1724c73d51b240a69ca702997b717eee4ba1f6065bf5d6b44dba01d48"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/00/e5/cf944fd98a68dcde5567949061322577200222d4a897a471e8eaafdbaed4/sentry-sdk-1.34.0.tar.gz"
    sha256 "e5d0d2b25931d88fa10986da59d941ac6037f742ab6ff2fce4143a27981d60c3"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/88/04/b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baa/smmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "sounddevice" do
    url "https://files.pythonhosted.org/packages/d8/3b/c989bde59a1eb333eb2a692f508a09408df562a3f99047a2d030e160cb11/sounddevice-0.4.6.tar.gz"
    sha256 "3236b78f15f0415bdf006a620cef073d0c0522851d66f4a961ed6d8eb1482fe9"
  end

  resource "soundfile" do
    url "https://files.pythonhosted.org/packages/6f/96/5ff33900998bad58d5381fd1acfcdac11cbea4f08fc72ac1dc25ffb13f6a/soundfile-0.12.1.tar.gz"
    sha256 "e8e1017b2cf1dda767aef19d2fd9ee5ebe07e050d430f77a0a7c66ba08b8cdae"
  end

  resource "spiceai" do
    url "https://files.pythonhosted.org/packages/cf/ae/996ad1fdea23c403b933ef9802bede2fbc0751fdfecde9fd05dc975086de/spiceai-0.1.8.tar.gz"
    sha256 "54299be0f90bb915afcb3532250fdac6401fa75e25db00668533d5c22b7c3d6a"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/61/b5/6bceb93ff20bd7ca36e6f7c540581abb18f53130fabb30ba526e26fd819b/starlette-0.37.2.tar.gz"
    sha256 "9af890290133b79fc3db55474ade20f6220a364a0402e0b556e7cd5e1e093823"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/e5/57/3485a1a3dff51bfd691962768b14310dae452431754bfc091250be50dd29/sympy-1.12.tar.gz"
    sha256 "ebf595c8dac3e0fdc4152c51878b498396ec7f30e7a914d6071e674d49420fb8"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/89/3c/253e1627262373784bf9355db9d6f20d2d8831d79f91e9cca48050cddcc2/tenacity-8.2.3.tar.gz"
    sha256 "5398ef0d78e63f40007c1fb4c0bff96e1911394d2fa8d194f77619c05ff6cc8a"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/b8/85/147a0529b4e80b6b9d021ca8db3a820fcac53ec7374b87073d004aaf444c/termcolor-2.3.0.tar.gz"
    sha256 "b5b08f68937f138fe92f6c089b99f1e2da0ae56c52b78bf7075fd95420fd9a5a"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/24/51/57eb835afc9569d32b5979ecbf3bf73f8ece8700ebffab3bac7ff29f92e4/textual-0.47.1.tar.gz"
    sha256 "4b82e317884bb1092f693f474c319ceb068b5a0b128b121f1aa53a2d48b4b80c"
  end

  resource "textual-autocomplete" do
    url "https://files.pythonhosted.org/packages/c3/4f/6c5917fdf9bfa0c18dfd3828ac70df6b5ddee9dd3b403d774447e1c0fec5/textual_autocomplete-2.1.0b0.tar.gz"
    sha256 "ba31da6e9b77e4c35323c267f958f0b90e1c2ddeca9c825c7d6c29d4d33893ce"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/9f/88/77a86f915a81449156375b7538c94105a34bebf00838462c9d3fced490e9/tiktoken-0.4.0.tar.gz"
    sha256 "59b20a819969735b48161ced9b92f05dc4519c17be4015cfb73b65270a243620"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/c0/44/625db94e91c6196b6574359fa70bfe28e8eabf57a1b894f8f0ec69727fd1/tokenizers-0.15.2.tar.gz"
    sha256 "e6e9c6e019dd5484be5beafc775ae6c925f4c69a3487040ed09b45e13df2cb91"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "trio" do
    url "https://files.pythonhosted.org/packages/8a/f3/07c152213222c615fe2391b8e1fea0f5af83599219050a549c20fcbd9ba2/trio-0.24.0.tar.gz"
    sha256 "ffa09a74a6bf81b84f8613909fb0beaee84757450183a7a2e0b47b455c0cac5d"
  end

  resource "trio-websocket" do
    url "https://files.pythonhosted.org/packages/dd/36/abad2385853077424a11b818d9fd8350d249d9e31d583cb9c11cd4c85eda/trio-websocket-0.11.1.tar.gz"
    sha256 "18c11793647703c158b1f6e62de638acada927344d534e3c7628eedcb746839f"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/35/fe/f9e38794565b83343f3c67b4b596e0186f748e536bcaf87cf6bc27cd1da7/typer-0.12.1.tar.gz"
    sha256 "72d218ef3c686aed9c6ff3ca25b238aee0474a1628b29c559b18b634cfdeca88"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/1f/7a/8b94bb016069caa12fc9f587b28080ac33b4fbb8ca369b98bc0a4828543e/typing_extensions-4.8.0.tar.gz"
    sha256 "df8e4339e9cb77357558cbdbceca33c303714cf861d1eef15e1070055ae8b7ef"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/91/7a/146a99696aee0609e3712f2b44c6274566bc368dfe8375191278045186b8/uc-micro-py-1.0.3.tar.gz"
    sha256 "d321b92cff673ec58027c04015fcaa8bb1e005478643ff4a500882eaab88c48a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/49/8d/5005d39cd79c9ae87baf7d7aafdcdfe0b13aa69d9a1e3b7f1c984a2ac6d2/uvicorn-0.29.0.tar.gz"
    sha256 "6a69214c0b6a087462412670b3ef21224fa48cae0e452b5883e8e8bdfdd11dd0"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/9c/16/728cc5dde368e6eddb299c5aec4d10eaf25335a5af04e8c0abd68e2e9d32/uvloop-0.19.0.tar.gz"
    sha256 "0246f4fd1bf2bf702e06b0d45ee91677ee5c31242f39aab4ea6fe0c51aedd0fd"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/66/79/0ee412e1228aaf6f9568aa180b43cb482472de52560fbd7c283c786534af/watchfiles-0.21.0.tar.gz"
    sha256 "c76c635fabf542bb78524905718c39f736a98e5ab25b23ec6d4abede1a85a6a3"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "webdriver-manager" do
    url "https://files.pythonhosted.org/packages/e5/50/2958aa25647e86334b30b4f8c819cc4fd5f15d3d0115042a4c924ec6e94d/webdriver_manager-4.0.1.tar.gz"
    sha256 "25ec177c6a2ce9c02fb8046f1b2732701a9418d6a977967bb065d840a3175d87"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/20/07/2a94288afc0f6c9434d6709c5320ee21eaedb2f463ede25ed9cf6feff330/websocket-client-1.7.0.tar.gz"
    sha256 "10e511ea3a8c744631d3bd77e61eb17ed09304c413ad42cf6ddfa4c7787e8fe6"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/2e/62/7a7874b7285413c954a4cca3c11fd851f11b2fe5b4ae2d9bee4f6d9bdb10/websockets-12.0.tar.gz"
    sha256 "81df9cbcbb6c260de1e007e58c011bfebe2dafc8435107b0537f393dd38c8b1b"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/c9/4a/44d3c295350d776427904d73c189e10aeae66d7f555bb2feee16d1e4ba5a/wsproto-1.2.0.tar.gz"
    sha256 "ad565f26ecb92588a3e43bc3d96164de84cd9902482b130d0ddbaa9664a85065"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/3e/ef/65da662da6f9991e87f058bc90b91a935ae655a16ae5514660d6460d1298/zipp-3.18.1.tar.gz"
    sha256 "2884ed22e7d8961de1c9a05142eb69a247f120291bc0206a00a7642f09b5b715"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/mentat 2>&1")
    assert_match "No OpenAI api key detected", output
  end
end
