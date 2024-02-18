class Prowler < Formula
  include Language::Python::Virtualenv

  desc "Open Source Security tool to perform Cloud Security best practices"
  homepage "https://prowler.pro/"
  url "https://files.pythonhosted.org/packages/78/b5/5c8eb9f3a4a8a25ef2c0dc9916269239b038e8cf5d875dde6abaa7b0bd80/prowler-3.13.0.tar.gz"
  sha256 "3c2afb16a5c67e972dfe480782968a8ac4fc850636c98f633e9be7ef4590d3dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0d451904d35911ec2c8e197fcab67db4804932d1b29110f1d8ef885bf6ad9309"
    sha256 cellar: :any,                 arm64_ventura:  "798dec7dc772bda419250d4f510ed860ffcfd8ac52d7940a59816258e4d6ba8a"
    sha256 cellar: :any,                 arm64_monterey: "53097f7a1f431be216f79e7dcd336da6d77b5b9b595a8e0c78eac38bc9438fc6"
    sha256 cellar: :any,                 sonoma:         "e7f580524a6b3c88383cc079ed970426b0bf80ee07b67615ff9f188603ed3840"
    sha256 cellar: :any,                 ventura:        "1d1815ebbbb8dae46868e0c9508a78ec0e6a919091bfe95d257dd25a7ebe641e"
    sha256 cellar: :any,                 monterey:       "32e381735532d069c4625350861f991434f42600d77f2b529f481a94a3909098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bc395cf87649b206af73ec97ef9b50a876ba0e96138763f3ae3124a45070b4b"
  end

  depends_on "rust" => :build # for microsoft_kiota_http
  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-cryptography"
  depends_on "python-pyparsing"
  depends_on "python-tabulate"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "about-time" do
    url "https://files.pythonhosted.org/packages/1c/3f/ccb16bdc53ebb81c1bf837c1ee4b5b0b69584fd2e4a802a2a79936691c0a/about-time-4.2.1.tar.gz"
    sha256 "6a538862d33ce67d997429d14998310e1dbfda6cb7d9bbfbf799c4709847fece"
  end

  resource "adal" do
    url "https://files.pythonhosted.org/packages/90/d7/a829bc5e8ff28f82f9e2dc9b363f3b7b9c1194766d5a75105e3885bfa9a8/adal-1.2.7.tar.gz"
    sha256 "d74f45b81317454d96e982fd1c50e6fb5c99ac2223728aea8764433a39f566f1"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/18/93/1f005bbe044471a0444a82cdd7356f5120b9cf94fe2c50c0cdbf28f1258b/aiohttp-3.9.3.tar.gz"
    sha256 "90842933e5d1ff760fae6caca4b2b3edba53ba8f4b71e95dacf2818a2aca06f7"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "alive-progress" do
    url "https://files.pythonhosted.org/packages/6a/cf/de25c4f6123c3b3eb5acc87144d3e017df25b32c16806b14572a259939ac/alive-progress-3.1.5.tar.gz"
    sha256 "42e399a66c8150dc507602dff7b7953f105ef11faf97ddaa6d27b1cbf45c4c98"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/2d/b8/7333d87d5f03247215d86a86362fd3e324111788c6cdd8d2e6196a6ba833/anyio-4.2.0.tar.gz"
    sha256 "e1875bb4b4e2de1669f4bc7869b6d3f54231cdced71605e6e64c9be77e3be50f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "awsipranges" do
    url "https://files.pythonhosted.org/packages/19/2e/6efa95f995369da828715f41705686cd214b9259ed758266942553d40441/awsipranges-0.3.3.tar.gz"
    sha256 "4f0b3f22a9dc1163c85b513bed812b6c92bdacd674e6a7b68252a3c25b99e2c0"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/3e/71/f6f71a276e2e69264a97ad39ef850dca0a04fce67b12570730cb38d0ccac/azure-common-1.1.28.zip"
    sha256 "4ac0cd3214e36b6a1b6a442686722a5d8cc449603aa833f3f0f40bda836704a3"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/b1/38/ecb085532b46ca3893732d2dafa8b75a1754164b1c0e757e7c53c4250714/azure-core-1.30.0.tar.gz"
    sha256 "6f3a7883ef184722f6bd997262eddaf80cfe7e5b3e0caaaf8db1695695893d35"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/74/02/a0545eaa3fb83a6b6c413de4a65e06a02ce887f874a2e74a1240b2169140/azure-identity-1.15.0.tar.gz"
    sha256 "4c28fc246b7f9265610eb5261d65931183d019a23d4b0e99357facb2e6c227c8"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/9e/ab/e79874f166eed24f4456ce4d532b29a926fb4c798c2c609eefd916a3f73d/azure-mgmt-authorization-4.0.0.zip"
    sha256 "69b85abc09ae64fc72975bd43431170d8c7eb5d166754b98aac5f3845de57dc4"
  end

  resource "azure-mgmt-core" do
    url "https://files.pythonhosted.org/packages/14/95/2b2085e40f4b9de88ad256428a669583066d8ab348fc19110c7d04c3189b/azure-mgmt-core-1.4.0.zip"
    sha256 "d195208340094f98e5a6661b781cde6f6a051e79ce317caabd8ff97030a9b3ae"
  end

  resource "azure-mgmt-security" do
    url "https://files.pythonhosted.org/packages/25/b2/bbe822bca8dc617ac5fab0eb40e5786a2ed933b484a3238af5b7a19e6deb/azure-mgmt-security-6.0.0.tar.gz"
    sha256 "ceafc1869899067110bd830c5cc98bc9b8f32d8ea840ca1f693b1a5f52a5f8b0"
  end

  resource "azure-mgmt-sql" do
    url "https://files.pythonhosted.org/packages/3f/af/398c57d15064ea23475076cd087b1a143b66d33a029e6e47c4688ca32310/azure-mgmt-sql-3.0.1.zip"
    sha256 "129042cc011225e27aee6ef2697d585fa5722e5d1aeb0038af6ad2451a285457"
  end

  resource "azure-mgmt-storage" do
    url "https://files.pythonhosted.org/packages/49/5c/9fc3418570dcb5de5f883f909b894f9cdd77829c84afb08b7370c796334e/azure-mgmt-storage-21.1.0.tar.gz"
    sha256 "d6d3c0e917c988bc9ed0472477d3ef3f90886009eb1d97a711944f8375630162"
  end

  resource "azure-mgmt-subscription" do
    url "https://files.pythonhosted.org/packages/84/67/14b19a006e13d86f05ee59faf78c39dc443d4fd6967344e9c94f688949c1/azure-mgmt-subscription-3.1.1.zip"
    sha256 "4e255b4ce9b924357bb8c5009b3c88a2014d3203b2495e2256fa027bf84e800e"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/fd/f8/59c209132b3b2993402df6b7e79728726927b53168624e917cd9daaffea8/azure-storage-blob-12.19.0.tar.gz"
    sha256 "26c0a4320a34a3c2a1b74528ba6812ebcb632a04cd67b1c7377232c4b01a5897"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/0f/3c/8a0b46a53326236006a4c4d1a0d49c4ff3a83368492c8308031fbaf61583/boto3-1.26.165.tar.gz"
    sha256 "9e7242b9059d937f34264125fecd844cb5e01acce6be093f6c44869fdf7c6e30"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/3d/f6/d35a27c73dc1053abdfe8524d1e488073fccb51e43c88da61b8fe29522e3/botocore-1.29.165.tar.gz"
    sha256 "988b948be685006b43c4bbd8f5c0cb93e77c66deb70561994e0c5b31b5a67210"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/10/21/1b6880557742c49d5b0c4dcf0cf544b441509246cdd71182e0847ac859d5/cachetools-5.3.2.tar.gz"
    sha256 "086ee420196f7b2ab9ca2db2520aca326318b68fe5ba8bc4d49cca91add450f2"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "contextlib2" do
    url "https://files.pythonhosted.org/packages/c7/13/37ea7805ae3057992e96ecb1cffa2fa35c2ef4498543b846f90dd2348d8f/contextlib2-21.6.0.tar.gz"
    sha256 "ab1e2bfe1d01d968e1b7e8d9023bc51ef3509bba217bb730cee3827e1ee82869"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/92/14/1e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232/Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "detect-secrets" do
    url "https://files.pythonhosted.org/packages/f1/55/292f9ce52bba7f3df0a9cde65dabf458d3aeec6a63bf737e5a5fa9fe6d31/detect_secrets-1.4.0.tar.gz"
    sha256 "d56787e339758cef48c9ccd6692f7a094b9963c979c9813580b0169e41132833"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/70/70/41905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263/filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/cf/3d/2102257e7acad73efc4a0c306ad3953f68c504c16982bbdfee3ad75d8085/frozenlist-1.4.1.tar.gz"
    sha256 "c037a86e8513059a2613aaba4d817bb90b9d9b6b69aace3ce9c877e8c8ed402b"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/34/8b/33c66d89cdd061b070804018820a1fa5a179ecae43155ae1b62eea0cd11d/google-api-core-2.17.0.tar.gz"
    sha256 "de7ef0450faec7c75e0aea313f29ac870fdc44cfaec9d6499a9a17305980ef66"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/84/7f/cc87798090179a13c1c0c65521e9d9477f16b64a2510c128d63604543be0/google-api-python-client-2.116.0.tar.gz"
    sha256 "f9f32361e16114d62929638fe07f77be30216b079ad316dc2ced859d9f72e5ad"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/71/10/8a86f8c81350bff52399b9e1125bc72963812c179567e5e6e93dd74c0bbb/google-auth-2.27.0.tar.gz"
    sha256 "e863a56ccc2d8efa83df7a80272601e43487fa9a728a376205c86c26aaefa821"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/56/be/217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacef/google-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/4a/5f/eb12d721b45d20a977289d674e179995a0ddab1684d2c61b29a63d43a5f1/googleapis-common-protos-1.62.0.tar.gz"
    sha256 "83f0ece9f94e5672cced82f592d2a5edf527a96ed1794f0bab36d5735c996277"
  end

  resource "grapheme" do
    url "https://files.pythonhosted.org/packages/ce/e7/bbaab0d2a33e07c8278910c1d0d8d4f3781293dfbc70b5c38197159046bf/grapheme-0.6.0.tar.gz"
    sha256 "44c2b9f21bbe77cfb05835fec230bd435954275267fea1858013b102f8603cca"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/2a/32/fec683ddd10629ea4ea46d206752a95a2d8a48c22521edd70b142488efe1/h2-4.1.0.tar.gz"
    sha256 "a83aca08fbe7aacb79fec788c9c0bac936343560ed9ec18b82a13a12c28d2abb"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/3e/9b/fda93fb4d957db19b0f6b370e79d586b3e8528b20252c729c476a2c02954/hpack-4.0.0.tar.gz"
    sha256 "fc41de0c63e687ebffde81187a948221294896f6bdc0ae2312708df339430095"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/18/56/78a38490b834fa0942cbe6d39bd8a7fd76316e8940319305a98d2b320366/httpcore-1.0.2.tar.gz"
    sha256 "9fc092e4799b26174648e54b74ed5f683132a464e95643b226e00c2ed2fa6535"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/bd/26/2dc654950920f499bd062a211071925533f821ccdca04fa0c2fd914d5d06/httpx-0.26.0.tar.gz"
    sha256 "451b55c30d5185ea6b23c2c793abf9bb237d2a7dfb901ced6ff69ad37ec1dfaf"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/5a/2a/4747bff0a17f7281abe73e955d60d80aae537a5d203f417fa1c2e7578ebb/hyperframe-6.0.1.tar.gz"
    sha256 "ae510046231dc8e9ecb1a6586f63d2347bf4c8905914aa84ba585ae85f28a914"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/ee/eb/58c2ab27ee628ad801f56d4017fe62afab0293116f6d0b08f1d5bd46e06f/importlib_metadata-6.11.0.tar.gz"
    sha256 "1231cf92d825c9e03cfc4da076a16de6422c863558229ea0b22b675657463443"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/4d/c5/3f6165d3df419ea7b0990b3abed4ff348946a826caf0e7c990b65ff7b9be/jsonschema-4.21.1.tar.gz"
    sha256 "85727c00279f5fa6bedbe6238d2aa6403bedd8b4864ab11207d07df3cc1b2ee5"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/f8/b9/cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4b/jsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "microsoft-kiota-abstractions" do
    url "https://files.pythonhosted.org/packages/30/a3/fe063726cebb6edc796753d2008b0bebecae4759afd5e93681a655d90517/microsoft_kiota_abstractions-1.2.0.tar.gz"
    sha256 "2b38241402995952c5598923391dcbb84bd97e48c0d76f93e2817c69ba19e3f6"
  end

  resource "microsoft-kiota-authentication-azure" do
    url "https://files.pythonhosted.org/packages/5c/3a/21929600c477eb5b1deab21db52fdd06d691950b839dd3a01a3085c480ba/microsoft_kiota_authentication_azure-1.0.0.tar.gz"
    sha256 "752304f8d94b884cfec12583dd763ec0478805c7f80b29344e78c6d55a97bd01"
  end

  resource "microsoft-kiota-http" do
    url "https://files.pythonhosted.org/packages/a9/2e/7c252a53c4fee4cff912bac3dc1be37efe93401016119ea2dfe685eca9d1/microsoft_kiota_http-1.3.0.tar.gz"
    sha256 "ae97bbfe4544c94e43591b44c8a60791689f31f7d16a9154df7738e829a28481"
  end

  resource "microsoft-kiota-serialization-json" do
    url "https://files.pythonhosted.org/packages/7b/6d/702e100cd8b2594a3416bb413ebbc1f7314611f6a483df8cd6673ccf4083/microsoft_kiota_serialization_json-1.0.1.tar.gz"
    sha256 "1d93ecee5d31941e3bdfa3c0b319cfe629d4f59a95fb0fbe0b054f7dbdc0ff60"
  end

  resource "microsoft-kiota-serialization-text" do
    url "https://files.pythonhosted.org/packages/a1/c9/f9c91025559d4c63237b9f232ecd106e0d8ec9a6c8953e5a7a3c4763d808/microsoft_kiota_serialization_text-1.0.0.tar.gz"
    sha256 "c3dd3f409b1c4f4963bd1e41d51b65f7e53e852130bb441d79b77dad88ee76ed"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/bb/45/c4dfbe24dd546d141287fa26476ce3206d461d8e4a24be77c84b835e647d/msal-1.26.0.tar.gz"
    sha256 "224756079fe338be838737682b49f8ebc20a87c1c5eeaf590daae4532b83de15"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/cb/ba/618771542cdc4bc5314c395076c397d67e2bdcd88564c6ca712a2497d1c6/msal-extensions-1.1.0.tar.gz"
    sha256 "6ab357867062db7b253d0bd2df6d411c7891a0ee7308d54d1e4317c1d1c54252"
  end

  resource "msgraph-core" do
    url "https://files.pythonhosted.org/packages/49/8b/431e1f1a377163118288f77ecc38a775b70224a6f8e99946c5be3521d19a/msgraph-core-1.0.0.tar.gz"
    sha256 "f26bcbbb3cd149dd7f1613159e0c2ed862888d61bfd20ef0b08b9408eb670c9d"
  end

  resource "msgraph-sdk" do
    url "https://files.pythonhosted.org/packages/88/13/c1e6487013b33e9287f56372354a6c614ade56ef1e0e7f8a43bbeaf8ab65/msgraph-sdk-1.1.0.tar.gz"
    sha256 "c81bbd7c82b1237a25baee46d2a40ea3eabd15e06c5e50621ad4a9045012da5d"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/68/77/8397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42/msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "msrestazure" do
    url "https://files.pythonhosted.org/packages/48/fc/5c2940301a83f18884a8e3aead2b2ff177a1a373f75c7b17e2e404199b2a/msrestazure-0.6.4.tar.gz"
    sha256 "a06f0dabc9a6f5efe3b6add4bd8fb623aeadacf816b7a35b0f89107e0544d189"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/f9/79/722ca999a3a09a63b35aac12ec27dfa8e5bb3a38b0f857f7a1a209a88836/multidict-6.0.5.tar.gz"
    sha256 "f7e301075edaf50500f0b341543c41194d8df3ae5caf4702f2095f3ca73dd8da"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/e8/56/b485bf0f42ae83a8ff97e861a3869f57415205ab8d1a22dd755319a97701/opentelemetry_api-1.22.0.tar.gz"
    sha256 "15ae4ca925ecf9cfdfb7a709250846fbb08072260fca08ade78056c502b86bed"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/2c/e5/8428cffb8905160be1fb9680da4be72394bd313437a559c0954cca68d983/opentelemetry_sdk-1.22.0.tar.gz"
    sha256 "45267ac1f38a431fc2eb5d6e0c0d83afc0b78de57ac345488aa58c28c17991d0"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/6c/1a/c73989de59d71c30922fce91edccda75942156e753d25976640dde0ac051/opentelemetry_semantic_conventions-0.43b0.tar.gz"
    sha256 "b9576fb890df479626fa624e88dde42d3d60b8b6c8ae1152ad157a8b97358635"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pendulum" do
    url "https://files.pythonhosted.org/packages/b8/fe/27c7438c6ac8b8f8bef3c6e571855602ee784b85d072efddfff0ceb1cd77/pendulum-3.0.0.tar.gz"
    sha256 "5d034998dea404ec31fae27af6b22cff1708f830a1ed7353be4d1019bb9f584e"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/35/00/0f230921ba852226275762ea3974b87eeca36e941a13cd691ed296d279e5/portalocker-2.8.2.tar.gz"
    sha256 "2b035aa7828e46c58e9b31390ee1f169b98e1066ab10b9a6a861fe7e25ee4f33"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/db/a5/05ea470f4e793c9408bc975ce1c6957447e3134ce7f7a58c13be8b2c216f/protobuf-4.25.2.tar.gz"
    sha256 "fe599e175cb347efc8ee524bcd4b902d11f7262c0e569ececcb89995c15f0a5e"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ce/dc/996e5446a94627fe8192735c20300ca51535397e31e7097a3cc80ccf78b7/pyasn1-0.5.1.tar.gz"
    sha256 "6d391a96e59b23130a5cfa74d6fd7f388dbbe26cc8f1edf39fdddf08d9d6676c"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/3b/e4/7dec823b1b5603c5b3c51e942d5d9e65efd6ff946e713a325ed4146d070f/pyasn1_modules-0.3.0.tar.gz"
    sha256 "5bd01446b736eb9d31512a30d46c1ac3395d676c6f3cafa4c03eb54b9925631c"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/df/ab/67eda485b025e9253cce0eaede9b6158a08f62af7013a883b2c8775917b2/pydantic-1.10.14.tar.gz"
    sha256 "46f17b832fe27de7850896f3afee50ea682220dd218f7e9c88d436788419dca6"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/30/72/8259b2bccfe4673330cea843ab23f86858a419d8f1493f66d413a76c7e3b/PyJWT-2.8.0.tar.gz"
    sha256 "57e28d156e3d5c10088e0c68abb90bfac3df82b40a71bd0daa20c65ccd5c23de"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/21/c5/b99dd501aa72b30a5a87d488d7aa76ec05bdf0e2c7439bc82deb9448dd9a/referencing-0.33.0.tar.gz"
    sha256 "c775fedf74bc0f9189c2a3be1c12fd03e8c23f4d371dce795df44e06c5b412f7"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/2b/69/ba1b5f52f96cde4f2d8eca74a0aa2c11a66b2fe58d0fb63b2e46edce6ed3/requests-file-2.0.0.tar.gz"
    sha256 "20c5931629c558fda566cacc10cfe2cd502433e628f568c34c80d96a0cc95972"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/52/531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49f/requests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/b7/0a/e3bdcc977e6db3bf32a3f42172f583adfa7c3604091a03d512333e0161fe/rpds_py-0.17.1.tar.gz"
    sha256 "0210b2668f24c078307260bf88bdac9d6f1093635df5123789bfee4d8d7fc8e7"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/5a/47/d676353674e651910085e3537866f093d2b9e9699e95e89d960e78df9ecf/s3transfer-0.6.2.tar.gz"
    sha256 "cab66d3380cca3e70939ef2255d01cd8aece6a4907a9528740f668c4b0611861"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/4e/e8/01e1b46d9e04cdaee91c9c736d9117304df53361a191144c8eccda7f0ee9/schema-0.7.5.tar.gz"
    sha256 "f06717112c61895cabc4707752b88716e8420a8819d71404501e114f91043197"
  end

  resource "shodan" do
    url "https://files.pythonhosted.org/packages/c5/06/c6dcc975a1e7d89bc764fd271da8138b318e18080b48e7f1acd2ab63df28/shodan-1.31.0.tar.gz"
    sha256 "c73275386ea02390e196c35c660706a28dd4d537c5a21eb387ab6236fac251f6"
  end

  resource "slack-sdk" do
    url "https://files.pythonhosted.org/packages/ee/0f/f9ec7337003e39cdbeba9421f195e0b85d81810ddb6279bfa79a33bcb5a4/slack_sdk-3.26.2.tar.gz"
    sha256 "bcdac5e688fa50e9357ecd00b803b6a8bad766aa614d35d8dc0636f40adc48bf"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "std-uritemplate" do
    url "https://files.pythonhosted.org/packages/f2/57/9dc7bd987c74ff6e7d02993e2e08cc7d826b234a2992f0ec5aacf552b03b/std_uritemplate-0.0.52.tar.gz"
    sha256 "45b75ea1f7754f630a99590480d7c5473605a186cc0cef8d0f750d336a264f60"
  end

  resource "time-machine" do
    url "https://files.pythonhosted.org/packages/48/50/d0c443bc1287dc20a22597346864175774d39f40239223f95fb03d70a044/time_machine-2.13.0.tar.gz"
    sha256 "c23b2408e3adcedec84ea1131e238f0124a5bc0e491f60d1137ad7239b37c01a"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/02/21/4f2d7d6023650770112dd8144dbc47afabbfaf568a0d39abc0a4f37e8e9e/tldextract-5.1.1.tar.gz"
    sha256 "9b6dbf803cb5636397f0203d48541c0da8ba53babaf0e8a6feda2d88746813d4"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/74/5b/e025d02cb3b66b7b76093404392d4b44343c69101cc85f4d180dd5784717/tzdata-2024.1.tar.gz"
    sha256 "2674120f8d891909751c38abcdfd386ac0a5a1127954fbc332af6b5ceae07efd"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/0c/39/64487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08/urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "xlsxwriter" do
    url "https://files.pythonhosted.org/packages/2b/a3/dd02e3559b2c785d2357c3752cc191d750a280ff3cb02fa7c2a8f87523c3/XlsxWriter-3.1.9.tar.gz"
    sha256 "de810bf328c6a4550f4ffd6b0b34972aeb7ffcf40f3d285a0413734f9b63a929"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/e0/ad/bedcdccbcbf91363fd425a948994f3340924145c2bc8ccb296f4a1e52c28/yarl-1.9.4.tar.gz"
    sha256 "566db86717cf8080b99b58b083b773a908ae40f06681e87e589a976faf8246bf"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/58/03/dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6/zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "ens_rd2022_aws", shell_output("#{bin}/prowler aws --list-compliance")
    assert_match "rds", shell_output("#{bin}/prowler aws --list-services")

    assert_match "NoCredentialsError[33]: Unable to locate credentials",
      shell_output("#{bin}/prowler aws --quick-inventory 2>&1", 1)

    assert_match "Prowler #{version}", shell_output("#{bin}/prowler -v")
  end
end
