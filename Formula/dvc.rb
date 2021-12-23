class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://files.pythonhosted.org/packages/d2/f7/88b9578181fc14a812a95e9fc92cfa2da8e4e857a4b247af36bf85e0a3d8/dvc-2.9.3.tar.gz"
  sha256 "513d0d9ee3c3123e616f760eb8556ee569121286c3e400a1fe4b3bf66e6dea29"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "321e31495139b55eee2cbc345394f8a47b74fa754fceeedd93f49fb7f833a60a"
    sha256 cellar: :any,                 arm64_big_sur:  "f0fd94616ecce20d41182d9e5b458f1bc9d2b79ee8784b3d6293e82fbe8988bf"
    sha256 cellar: :any,                 monterey:       "f54e55fe0bcf47c269bf3fc53e06594b03d863880dc63c1c93c3c51b447ff03d"
    sha256 cellar: :any,                 big_sur:        "cec1c14da69f36978e25c0c8a02c7b63a5cf069f13a22f3c78745b52fa202edc"
    sha256 cellar: :any,                 catalina:       "2e99ffb024f9ad118ae9a4c4a77763117d54d4b9e46403cf4819a1dfa00c6811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "945be83616e467ca47de90af27651c75cf72319a6efee264cee3ba843d14daa0"
  end

  depends_on "pkg-config" => :build
  # for cryptograpy (required by azure deps)
  depends_on "rust" => :build
  depends_on "apache-arrow"
  depends_on "libgit2"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "python-tabulate"
  depends_on "python@3.9"
  depends_on "six"

  # When updating, check that the extra packages in pypi_formula_mappings.json
  # correctly reflects the following extra packages in setup.py:
  # gs, s3, azure, oss, ssh, gdrive, webdav (hdfs is provided by apache-arrow)
  resource "adal" do
    url "https://files.pythonhosted.org/packages/90/d7/a829bc5e8ff28f82f9e2dc9b363f3b7b9c1194766d5a75105e3885bfa9a8/adal-1.2.7.tar.gz"
    sha256 "d74f45b81317454d96e982fd1c50e6fb5c99ac2223728aea8764433a39f566f1"
  end

  resource "adlfs" do
    url "https://files.pythonhosted.org/packages/ea/d8/1338cbb4af518d7048777a09d2e9f1bd8af469f676f718d3ce4773a67dfa/adlfs-2021.10.0.tar.gz"
    sha256 "f2f30a5fd0a447b1a41dbb2f944898248d31015a72c18674a53462cf9ff724a2"
  end

  resource "aiobotocore" do
    url "https://files.pythonhosted.org/packages/11/16/4226e59bb72e096d9809ccedf349a1385b7ce55e7520181ba885cddbd60f/aiobotocore-2.0.1.tar.gz"
    sha256 "73b697da549d7f280c640ba3118cadcfc77312ce3ea493b55384bd3624ee5588"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/5a/86/5f63de7a202550269a617a5d57859a2961f3396ecd1739a70b92224766bc/aiohttp-3.8.1.tar.gz"
    sha256 "fc5471e1a54de15ef71c1bc6ebe80d4dc681ea600e68bfd1cbce40427f0b7578"
  end

  resource "aiohttp-retry" do
    url "https://files.pythonhosted.org/packages/23/d9/6fcb308129ade81c50a09b3f534880946d46008e9cba727b80a1274dba4b/aiohttp_retry-2.4.6.tar.gz"
    sha256 "288c1a0d93b4b3ad92910c56a0326c6b055c7e1345027b26f173ac18594a97da"
  end

  resource "aioitertools" do
    url "https://files.pythonhosted.org/packages/78/f7/ea3904946e33c6e2799b5303e11ae5f43cf6b08dda58c8db8d759e34c3fb/aioitertools-0.8.0.tar.gz"
    sha256 "8b02facfbc9b0f1867739949a223f3d3267ed8663691cc95abd94e2c1d8c2b46"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/27/6b/a89fbcfae70cf53f066ec22591938296889d3cc58fec1e1c393b10e8d71d/aiosignal-1.2.0.tar.gz"
    sha256 "78ed67db6c7b7ced4f98e495e572106d5c432a93e1ddd1bf475e1dc05f5b7df2"
  end

  resource "aliyun-python-sdk-core" do
    url "https://files.pythonhosted.org/packages/39/f4/9ee9c0d081ba6afdacc4037e2d7c671568cbd93c7398743e3fe42662ede8/aliyun-python-sdk-core-2.13.35.tar.gz"
    sha256 "60129b597efb0040df9e2fe3191fec4387889f2eef9c08dc4d5079f35c43837a"
  end

  resource "aliyun-python-sdk-kms" do
    url "https://files.pythonhosted.org/packages/31/8d/5052612578e9237ff5b2c398fe33fa52541ed53f741143893fb8f5f27120/aliyun-python-sdk-kms-2.15.0.tar.gz"
    sha256 "642a3f4f04dcdba5f8a3a0f1edff04479e76df33017a5b25512490ce5894ab2d"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/dc/e7/7452227e8c091db6838d7f1b50dc4e6323e8463ed8c2d0b651ac9b7f7fce/anyio-3.4.0.tar.gz"
    sha256 "24adc69309fb5779bc1e06158e143e0b6d2c56b302a3ac3de3083c705a6ed39d"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/6a/b4/3b1d48b61be122c95f4a770b2f42fc2552857616feba4d51f34611bd1352/argcomplete-1.12.3.tar.gz"
    sha256 "2c7dbffd8c045ea534921e63b0be6fe65e88599990d8dc408ac8c542b72a5445"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/54/6e/9678f7b2993537452710ffb1750c62d2c26df438aa621ad5fa9d1507a43a/async-timeout-4.0.2.tar.gz"
    sha256 "2163e1640ddb52b7a8c80d0a67a08587e5d245cc9c553a74a847056bc2976b15"
  end

  resource "asyncssh" do
    url "https://files.pythonhosted.org/packages/88/68/8fb70ea88cb1f05e6b2406d4fa7952c911ca6072657572bfe9ed446f490a/asyncssh-2.8.1.tar.gz"
    sha256 "0648eba58d72653755f28e26c9bd83147d9652c1f2f5e87fbf5a87d7f8fbf83a"
  end

  resource "atpublic" do
    url "https://files.pythonhosted.org/packages/ab/3d/3df1468805427fedcf880da42fa26353feea3a31b5a0cc71008adcfdb816/atpublic-2.3.tar.gz"
    sha256 "d6b9167fc3e09a2de2d2adcfc9a1b48d84eab70753c97de3800362e1703e3367"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/89/79/5e937f85e0e2876539a3bff63a6b89e516f4e093e2c46e60aad8216acb31/azure-core-1.21.1.zip"
    sha256 "88d2db5cf9a135a7287dc45fdde6b96f9ca62c9567512a3bb3e20e322ce7deb2"
  end

  resource "azure-datalake-store" do
    url "https://files.pythonhosted.org/packages/13/8b/2c151c9f4c3f5345d9a32889e15a471d98e426851b9fcf13dc9f134f5b93/azure-datalake-store-0.0.52.tar.gz"
    sha256 "4198ddb32614d16d4502b43d5c9739f81432b7e0e4d75d30e05149fe6007fea2"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/5b/93/6d12f814273bb84849dfd037188ac6d2cfd1c8c27bd7bc3e2b9abafbf73a/azure-identity-1.7.1.zip"
    sha256 "7f22cd0c7a9b92ed297dd67ae79d9bb9a866e404061c02cec709ad10c4c88e19"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/c3/27/53976afdd9d66aa02b736b47dc991fe55ae5dd2be686b2ecb8dcf9f58930/azure-storage-blob-12.9.0.zip"
    sha256 "cff66a115c73c90e496c8c8b3026898a3ce64100840276e9245434e28a864225"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/e2/42/7b9ac0606c9b7e882ee026e5aa1576176c294a9e84977865273a92e7c6e9/boto3-1.19.8.tar.gz"
    sha256 "568d5ee1bacb3127eac3e1d80119699711c1092e82e4b1d4541d1e2202eb95fc"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/9d/32/9ffbd038a124e77b229e0fb9e3e247b0b27724ee60b3bd76df3c7fb4248f/botocore-1.22.8.tar.gz"
    sha256 "89c48ac82cd3d814dd459428144a124e42acca80431c77813b7ac29f8fac3456"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/d7/69/c457a860456cbf80ecc2e44ed4c201b49ec7ad124d769b71f6d0a7935dca/cachetools-4.2.4.tar.gz"
    sha256 "89ea6f1b638d5a73a4f9226be57ac5e4f399d22770b92355f92dcb0f7f001693"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/68/e4/e014e7360fc6d1ccc507fe0b563b4646d00e0d4f9beec4975026dd15850b/charset-normalizer-2.0.9.tar.gz"
    sha256 "b0b883e8e874edfdece9c28f314e3dd5badf067342e42fb162203335ae61aa2c"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "crcmod" do
    url "https://files.pythonhosted.org/packages/6b/b0/e595ce2a2527e169c3bcd6c33d2473c1918e0b7f6826a043ca1245dd4e5b/crcmod-1.7.tar.gz"
    sha256 "dc7051a0db5f2bd48665a990d3ec1cc305a466a77358ca4492826f41f283601e"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/f9/4b/1cf8e281f7ae4046a59e5e39dd7471d46db9f61bb564fddbff9084c4334f/cryptography-36.0.1.tar.gz"
    sha256 "53e5c1dc3d7a953de055d77bef2ff607ceef7a2aac0353b5d630ab67f7423638"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/92/3c/34f8448b61809968052882b830f7d8d9a8e1c07048f70deb039ae599f73c/decorator-5.1.0.tar.gz"
    sha256 "e59913af105b9860aa2c8d3272d9de5a56a4e608db9a2f167a8480b323d529a7"
  end

  resource "dictdiffer" do
    url "https://files.pythonhosted.org/packages/61/7b/35cbccb7effc5d7e40f4c55e2b79399e1853041997fcda15c9ff160abba0/dictdiffer-0.9.0.tar.gz"
    sha256 "17bacf5fbfe613ccf1b6d512bd766e6b21fb798822a133aa86098b8ac9997578"
  end

  resource "diskcache" do
    url "https://files.pythonhosted.org/packages/6d/0b/6cb2f669c0eedceeaec4d1e45c97799a4c5ca78b560423d65f7a5d63e1bf/diskcache-5.3.0.tar.gz"
    sha256 "3f1fa30b29fdff26cfddcb3ee7d61376903f82c769ea2907a2b82a5bfb8abbe2"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/a5/26/256fa167fe1bf8b97130b4609464be20331af8a3af190fb636a8a7efd7a2/distro-1.6.0.tar.gz"
    sha256 "83f5e5a09f9c5f68f60173de572930effbcc0287bb84fdc4426cb4168c088424"
  end

  resource "dpath" do
    url "https://files.pythonhosted.org/packages/d0/d2/219bd67dc31eeb14be02bea9a23d0b16a0236f45504c6963f675c80a8d8c/dpath-2.0.5.tar.gz"
    sha256 "ef74321b01479653c812fee69c53922364614d266a8e804d22058c5c02e5674e"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/c7/f0/04e7aae32c5c45666fa94fa146ba3a6f78d44ed9fd11f3fc497bd6a3d13e/dulwich-0.20.26.tar.gz"
    sha256 "38aa50f859c8ea53071a049c3f1d5cc54f7dc60a4136a1ab631756a79f6582b5"
  end

  resource "flatten-dict" do
    url "https://files.pythonhosted.org/packages/89/c6/5fe21639369f2ea609c964e20870b5c6c98a134ef12af848a7776ddbabe3/flatten-dict-0.4.2.tar.gz"
    sha256 "506a96b6e6f805b81ae46a0f9f31290beb5fa79ded9d80dbe1b7fa236ab43076"
  end

  resource "flufl.lock" do
    url "https://files.pythonhosted.org/packages/f4/3d/2f24d5661a51585507fede31ec6d4c4ba94366efbe046bfa6d7e8ce0425b/flufl.lock-6.0.tar.gz"
    sha256 "fc748ee609ec864b4838ef649dbd1170fa79deb0c213c2fd51151bee6a7fc242"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/5c/ee/7c6287928ba776567603248e160387cf4143641ecf734e393ad9b2c82475/frozenlist-1.2.0.tar.gz"
    sha256 "68201be60ac56aff972dc18085800b6ee07973c49103a8aba669dee3d71079de"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/a5/b1/9c247e65c565e863643763020366b492a6bd4b1fd5854cbc8bdc42bd87ff/fsspec-2021.11.1.tar.gz"
    sha256 "03683e606651d5e4bd9180525d57477bd5430e5dc68d2e459835dc14cecc3dd4"
  end

  resource "ftfy" do
    url "https://files.pythonhosted.org/packages/af/da/d215a091986e5f01b80f5145cff6f22e2dc57c6b048aab2e882a07018473/ftfy-6.0.3.tar.gz"
    sha256 "ba71121a9c8d7790d3e833c6c1021143f3e5c4118293ec3afb5d43ed9ca8e72b"
  end

  resource "funcy" do
    url "https://files.pythonhosted.org/packages/2d/0d/65e6824020a10fee9ea07ec2e4a1527249c1cbf04486e0dfe2a71604b7d2/funcy-1.17.tar.gz"
    sha256 "40b9b9a88141ae6a174df1a95861f2b82f2fdc17669080788b73a3ed9370e968"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "gcsfs" do
    url "https://files.pythonhosted.org/packages/a6/36/29226da7327d7b4c03ddef496daec7718a5f4bcc4b5ec1265cbee6fa3073/gcsfs-2021.11.1.tar.gz"
    sha256 "cc03c5ab7190cf4dddb67be0016f3cb2148743935061da5ef142ea86149814dd"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/fc/44/64e02ef96f20b347385f0e9c03098659cb5a1285d36c3d17c56e534d80cf/gitdb-4.0.9.tar.gz"
    sha256 "bac2fd45c0a1c9cf619e63a90d62bdc63892ef92387424b855792a6cabe789aa"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/34/cc/aaa7a0d066ac9e94fbffa5fcf0738f5742dd7095bdde950bd582fca01f5a/GitPython-3.1.24.tar.gz"
    sha256 "df83fdf5e684fef7c6ee2c02fc68a5ceb7e7e759d08b694088d0cacb4eba59e5"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/5c/64/30a91e03a7c80463d21423d81bf77116cffa02166d642f754b8fcb0df729/google-api-core-2.3.2.tar.gz"
    sha256 "c8889f45cf58deca522888ae1d39b2a25e93e7d1b019ae8cee6456d5c726a40c"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/7c/0a/8997b497aaef363d0a2c0410d30b99dbbde835442e045110775b6b4d3725/google-api-python-client-2.33.0.tar.gz"
    sha256 "38e98611794632a12479fafbabe0b5027e8fcfc412e8375f1b23db0bc0209181"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/36/52/699d14b97ae4b1572c8e742c499afbac83b326e908ac26d602f7cbd16ffe/google-auth-2.3.3.tar.gz"
    sha256 "d83570a664c10b97a1dc6f8df87e5fdfff012f48f62be131e449c20dfc32630e"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/c6/b5/a9e956fd904ecb34ec9d297616fe98fa4106fc12f3b0a914dec983c267b9/google-auth-httplib2-0.1.0.tar.gz"
    sha256 "a07c39fd632becacd3f07718dfd6021bf396978f03ad3ce4321d060015cc30ac"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/30/21/b84fa7ef834d4b126faad13da6e582c8f888e196326b9d6aab1ae303df4f/google-auth-oauthlib-0.4.6.tar.gz"
    sha256 "a90a072f6993f2c327067bf65270046384cda5a8ecb20b94ea9a687f1f233a7a"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/29/74/ec516d6f25ed4ef4af1569437e7e5e2b63118f90d68bb069c5e809ce367d/google-cloud-core-2.2.1.tar.gz"
    sha256 "476d1f71ab78089e0638e0aaf34bfdc99bab4fce8f4170ba6321a5243d13c5c7"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/ce/4d/8c9b5b2452a985ac4fe320eb4b70bbd52b70dea212804b6eb0ffd51ea6ec/google-cloud-storage-1.43.0.tar.gz"
    sha256 "f3b4f4be5c8a1b5727a8f7136c94d3bacdd4b7bf11f9553f51ae4c1d876529d3"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/db/de/477cdcfd3ba2877cdf798f0328ea6aa79b2e632d169f5099d6240c4c4ebf/google-crc32c-1.3.0.tar.gz"
    sha256 "276de6273eb074a35bc598f8efbc00c7869c5cf2e29c90748fccc8c898c244df"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/b5/e8/94ce8dc454f4735d51bfa96bf15bac787e66f0eb8afcdc7b4b7855708583/google-resumable-media-2.1.0.tar.gz"
    sha256 "725b989e0dd387ef2703d1cc8e86217474217f4549593c477fd94f4024a0f911"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/97/94/e55c0151d6665a5ff7305fef38c7e8f1defa4679f884aaf9812fb42a1109/googleapis-common-protos-1.54.0.tar.gz"
    sha256 "a4031d6ec6c2b1b6dc3e0be7e10a1bd72fb0b18b07ef9be7b51f2c1004ce2437"
  end

  resource "grandalf" do
    url "https://files.pythonhosted.org/packages/a2/3f/df0618a962a1744e932f2a4547cb786f5a93df7e2476c99e7f7dbd68039f/grandalf-0.6.tar.gz"
    sha256 "7471db231bd7338bc0035b16edf0dc0c900c82d23060f4b4d0c4304caedda6e4"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/bd/e9/72c3dc8f7dd7874812be6a6ec788ba1300bfe31570963a7e788c86280cb9/h11-0.12.0.tar.gz"
    sha256 "47222cb6067e4a307d535814917cd98fd0a57b6788ce715755fa2b6c28b56042"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/6a/90/334411fe5455d30498add7d77a8bf4833bfc4671289a954fb2fd43795338/httpcore-0.13.7.tar.gz"
    sha256 "036f960468759e633574d7c121afba48af6419615d36ab8ede979f1ad6276fa3"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/37/fd/525d4c267cffe4437405fdb883c57b895ec03746337dc5ca7489d40f60d0/httplib2-0.20.2.tar.gz"
    sha256 "e404681d2fbcec7506bcb52c503f2b021e95bee0ef7d01e5c221468a2406d8dc"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/62/0d/9804c841eaf5e0f72890e54eff21bb49664289edf8cbe09bd47db513bd68/httpx-0.20.0.tar.gz"
    sha256 "09606d630f070d07f9ff28104fbcea429ea0014c1e89ac90b4d8de8286c40e7b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/da/9c/d04c32ecf37e0ed5a887b30058de4bb817791550462383e3473cc8527309/knack-0.9.0.tar.gz"
    sha256 "7fcab17585c0236885eaef311c01a1e626d84c982aabcac81703afda3f89c81f"
  end

  resource "mailchecker" do
    url "https://files.pythonhosted.org/packages/9d/63/d5254da4c8ce3d9f8a25c5e88a9209a376bb761726a626ca8f05e269d82e/mailchecker-4.1.6.tar.gz"
    sha256 "bf56e590dde59eb7498d8226e46fbc5a39e13615487bd97d2cb29ddd2340e069"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/f2/9f/4cee5ef9062573c2c8853599da2ca9c9afa7eb088f578ff5137128fd30a5/msal-1.16.0.tar.gz"
    sha256 "240fb04dba46a27fd6a3178db8334412d0d02e0be85166f9e05bb45d03399084"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/a4/9c/57f1a1023b6f6560180163a92fdb307672ed50e74e2e8328b69954ccc5e9/msal-extensions-0.3.1.tar.gz"
    sha256 "d9029af70f2cbdc5ad7ecfed61cb432ebe900484843ccf72825445dbfe62d311"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/bb/2c/e8ac4f491efd412d097d42c9eaf79bcaad698ba17ab6572fd756eb6bd8f8/msrest-0.6.21.tar.gz"
    sha256 "72661bc7bedc2dc2040e8f170b6e9ef226ee6d3892e01affd4d26b06474d68d8"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/8e/7c/e12a69795b7b7d5071614af2c691c97fbf16a2a513c66ec52dd7d0a115bb/multidict-5.2.0.tar.gz"
    sha256 "0dd1c93edb444b33ba2274b66f63def8a327d607c6c790772f448a53b6ea59ce"
  end

  resource "nanotime" do
    url "https://files.pythonhosted.org/packages/d5/54/6d5924f59cf671326e7809f4b3f70fa8df535d67e952ad0b6fea02f52faf/nanotime-0.5.2.tar.gz"
    sha256 "c7cc231fc5f6db401b448d7ab51c96d0a4733f4b69fabe569a576f89ffdf966b"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/97/ae/7497bc5e1c84af95e585e3f98585c9f06c627fac6340984c4243053e8f44/networkx-2.6.3.tar.gz"
    sha256 "c0946ed31d71f1b732b5aaa6da5a0388a345019af232ce2f49c766e2d6795c51"
  end

  resource "oauth2client" do
    url "https://files.pythonhosted.org/packages/a6/7b/17244b1083e8e604bf154cf9b716aecd6388acd656dd01893d0d244c94d9/oauth2client-4.1.3.tar.gz"
    sha256 "d486741e451287f69568a4d26d70d9acd73a2bbfa275746c535b4209891cccc6"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/9e/84/001a3f8d9680f3b26d5e7711e13d5ff92e4b511766a72ac6b4a4e5f06796/oauthlib-3.1.1.tar.gz"
    sha256 "8f0215fcc533dd8dd1bee6f4c412d4f0cd7297307d43ac61666389e3bc3198a3"
  end

  resource "oss2" do
    url "https://files.pythonhosted.org/packages/16/d0/cfe6e199900a97d6e3db55e48ab525c630052e49475722fd20f0f7c7b793/oss2-2.15.0.tar.gz"
    sha256 "d8b5a10ba2291ff4c78246576f243dcec262f1f646344e61f3192dc262e87430"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/f6/33/436c5cb94e9f8902e59d1d544eb298b83c84b9ec37b5b769c5a0ad6edb19/pathspec-0.9.0.tar.gz"
    sha256 "e564499435a2673d586f6b2130bb5b95f04a3ba06f81b8f895b651a3c76aabb1"
  end

  resource "phonenumbers" do
    url "https://files.pythonhosted.org/packages/81/05/dc4b20a0f8c082b6a44cf56e776dea0439b1c0488a5306c01c8d790da45d/phonenumbers-8.12.39.tar.gz"
    sha256 "0f7745e1f108654db347d885e814cbb5f225b8c5f5ce336024b193c79291ddaa"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/38/2e/32172e8418f2ba284cee4fd67cb547d39a7debb3eed37d514da173786112/portalocker-2.3.2.tar.gz"
    sha256 "75cfe02f702737f1726d83e04eedfa0bda2cc5b974b1ceafb8d6b42377efbd5f"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/88/87/72eb9ccf8a58021c542de2588a867dbefc7556e14b2866d1e40e9e2b587e/pyasn1-modules-0.2.8.tar.gz"
    sha256 "905f84c712230b2c592c19470d3ca8d552de726050d1d1716282a1f6146be65e"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/dd/3b/38d83c2725fec5b837fc05d5c6e0178a420ff839a6ad5872f10c89244899/pycryptodome-3.12.0.zip"
    sha256 "12c7343aec5a3b3df5c47265281b12b611f26ec9367b6129199d67da54b768c1"
  end

  resource "pydot" do
    url "https://files.pythonhosted.org/packages/13/6e/916cdf94f9b38ae0777b254c75c3bdddee49a54cc4014aac1460a7a172b3/pydot-1.4.2.tar.gz"
    sha256 "248081a39bcb56784deb018977e428605c1c758f10897a339fce1dd728ff007d"
  end

  resource "PyDrive2" do
    url "https://files.pythonhosted.org/packages/6d/48/c245b25f3a1bb74f8066ff4820f22f65067f997fdaea1f75726ca50401de/PyDrive2-1.10.0.tar.gz"
    sha256 "f7bd19b4ff1ef6c0b922fb6ac55c0d94724ab537387ae4a1de797784d77463ab"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/e8/78/15417f51306f6870de37517c5315c1282d001dbc537fe1eb2df40f99a97b/pygit2-1.7.2.tar.gz"
    sha256 "70a4536a35452c31f823b59b6fdb665aa3778a43b73ccda3a4f79fa9962ad2bb"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  end

  resource "pygtrie" do
    url "https://files.pythonhosted.org/packages/a5/8b/90d0f21a27a354e808a73eb0ffb94db990ab11ad1d8b3db3e5196c882cad/pygtrie-2.4.2.tar.gz"
    sha256 "43205559d28863358dbbf25045029f58e2ab357317a59b11f11ade278ac64692"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/1d/8e/01bdcfdbb352daaba8ea406d9df149c5bba7dbf70f908d4fa4c269fe6a08/PyJWT-2.3.0.tar.gz"
    sha256 "b888b4d56f06f6dcd777210c334e69c737be74755d3e5e9ee3fe67dc18a0ee41"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/54/9a/2a43c5dbf4507f86f7c43cba4195d5e25a81c988fd7b0ea779dfc9c6973f/pyOpenSSL-21.0.0.tar.gz"
    sha256 "5e2d8c5e46d0d865ae933bef5230090bdaf5506281e9eec60fa250ee80600cb3"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/ab/61/1a1613e3dcca483a7aa9d446cb4614e6425eb853b90db131c305bd9674cb/pyparsing-3.0.6.tar.gz"
    sha256 "d9bdec0013ef1eb5a84ab39a3b3868911598afa494f5faa038647101504e2b81"
  end

  resource "python-benedict" do
    url "https://files.pythonhosted.org/packages/c6/7f/8c151e65e99ca1764c102fce5f96e6be546974a2890f584cff150c330d9e/python-benedict-0.24.3.tar.gz"
    sha256 "f9d7b41cbe7fe79b3df0c12285eacf297a157fa7b5d9da461132908ab13c390f"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-fsutil" do
    url "https://files.pythonhosted.org/packages/eb/0c/96feb0054e570094bfb6a3d67ac5565386e9691b4edd1a6adc7a57549105/python-fsutil-0.5.0.tar.gz"
    sha256 "02a347540d10c1616390a536ced73fd67df8d01c499f497d0ab3de3fbb236f0e"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/bc/a4/57893fbaf7cbf303a4f2307564cf83855a5f2cc34544656e7263125a0d1e/python-slugify-5.0.2.tar.gz"
    sha256 "f13383a0b9fcbe649a1892b9c8eb4f8eab1d6d84b84bb7a624317afa98159cab"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/23/eb/68fc8fa86e0f5789832f275c8289257d8dc44dbe93fce7ff819112b9df8f/requests-oauthlib-1.3.0.tar.gz"
    sha256 "b4261601a71fd721a8bd6d7aa1cc1d6a8a93b4a9f5e96626f8e4d91e8beeaa6a"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/79/30/5b1b6c28c105629cc12b33bdcbb0b11b5bb1880c6cfbd955f9e792921aa8/rfc3986-1.5.0.tar.gz"
    sha256 "270aaf10d87d0d4e095063c65bf3ddbc6ee3d0b226328ce21e036f946e421835"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/3b/5a90d0f197087896472757ebd9ac29d802ccc4f6953d99a535b1a8db2bf6/rich-10.16.1.tar.gz"
    sha256 "4949e73de321784ef6664ebbc854ac82b20ff60b2865097b93f3b9b41e30da27"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/8c/ee/4022542e0fed77dd6ddade38e1e4dea3299f873b7fd4e6d78319953b0f83/rsa-4.8.tar.gz"
    sha256 "5c6bd9dc7a543b7fe4304a631f8a8a3b674e2bbfc49c2ae96200cdbe55df6b17"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/4d/15/7fc04de02ca774342800c9adf1a8239703977c49c5deaadec1689ec85506/ruamel.yaml-0.17.17.tar.gz"
    sha256 "9751de4cbb57d4bfbf8fc394e125ed4a2f170fbff3dc3d78abf50be85924f8be"
  end

  resource "s3fs" do
    url "https://files.pythonhosted.org/packages/fe/5e/e03d907a5b7538c22c3849e796478597eb9ad3e537e48400b8218f66219f/s3fs-2021.11.1.tar.gz"
    sha256 "1a9ea7596663cda3a5dc6802f11eb468b397de35a8793750e9a98c65abd1a114"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/88/ef/4d1b3f52ae20a7e72151fde5c9f254cd83f8a49047351f34006e517e1655/s3transfer-0.5.0.tar.gz"
    sha256 "50ed823e1dc5868ad40c8dc92072f757aa0e653a192845c94a3b676f4a62da4c"
  end

  resource "scmrepo" do
    url "https://files.pythonhosted.org/packages/85/82/947d3809993f8366c0dc98848d70228423f56adec3eed6f58b88846a6a98/scmrepo-0.0.7.tar.gz"
    sha256 "0dd8ac0e0ca8223d5b2efacb77b2cb49ec3cc383241cc69d1ef7595736a4b0a9"
  end

  resource "shortuuid" do
    url "https://files.pythonhosted.org/packages/ce/c2/31dc2345d8e06711f3da9d65e3a72a060293057321815bc7f11a930c2529/shortuuid-1.0.8.tar.gz"
    sha256 "9435e87e5a64f3b92f7110c81f989a3b7bdb9358e22d2359829167da476cfc23"
  end

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/d0/ac/3d23eb1327617bd8f2cadccbe704ea3a7407c0fb631d9e605ab65932284f/shtab-1.5.2.tar.gz"
    sha256 "378b9c165d50a8bbf4379b59871036507b847b14b5e014f7d60b6153ac51ead0"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a6/ae/44ed7978bcb1f6337a3e2bef19c941de750d73243fc9389140d62853b686/sniffio-1.2.0.tar.gz"
    sha256 "c4666eecec1d3f50960c6bdf61ab7bc350648da6c126e3cf6898d8cd4ddcd3de"
  end

  resource "sshfs" do
    url "https://files.pythonhosted.org/packages/5a/9d/58dbbb52b8bd02f0a4a97b0c737a39cd2434298f2c357433fbe02b422d04/sshfs-2021.11.2.tar.gz"
    sha256 "34550f587e695781649ca830dbe23fabca4b4179f7eb047de855d2981f03c155"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/e3/c1/b3e42d5b659ca598508e2a9ef315d5eef0a970f874ef9d3b38d4578765bd/tqdm-4.62.3.tar.gz"
    sha256 "d359de7217506c9851b7869f3708d8ee53ed70a1b8edbba4dbcb47442592920d"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0d/4a/60ba3706797b878016f16edc5fbaf1e222109e38d0fa4d7d9312cb53f8dd/typing_extensions-4.0.1.tar.gz"
    sha256 "4ca091dea149f945ec56afb48dae714f21e8692ef22a395223bcd328961b6a0e"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  resource "voluptuous" do
    url "https://files.pythonhosted.org/packages/c0/2c/ccbeb25364e3e0c5e4522f13d66e2fc639bb4d4ecdf73be0959552cbecb4/voluptuous-0.12.2.tar.gz"
    sha256 "4db1ac5079db9249820d49c891cb4660a6f8cae350491210abce741fabf56513"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  resource "webdav4" do
    url "https://files.pythonhosted.org/packages/f5/0b/2154a41fec215ced2b3635b7741f66786657d0fda8a7af603b931e28d5a4/webdav4-0.9.3.tar.gz"
    sha256 "0d1e29f743def2c2ae2aab5e152757e1d8bfacfd7b7985764824308ebde1ff29"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/eb/f6/d81ccf43ac2a3c80ddb6647653ac8b53ce2d65796029369923be06b815b8/wrapt-1.13.3.tar.gz"
    sha256 "1fea9cd438686e6682271d36f3481a9f3636195578bab9ca3382e2f5f01fc185"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/f6/da/46d1b3d69a9a0835dabf9d59c7eb0f1600599edd421a4c5a15ab09f527e0/yarl-1.7.2.tar.gz"
    sha256 "45399b46d60c253327a460e99856752009fcee5f5d3c80b2f7c0cae1c38d56dd"
  end

  resource "zc.lockfile" do
    url "https://files.pythonhosted.org/packages/11/98/f21922d501ab29d62665e7460c94f5ed485fd9d8348c126697947643a881/zc.lockfile-2.0.tar.gz"
    sha256 "307ad78227e48be260e64896ec8886edc7eae22d8ec53e4d528ab5537a83203b"
  end

  def install
    venv = virtualenv_create(libexec, Formula["python@3.9"].opt_bin/"python3")
    venv.pip_install resources

    # NOTE: dvc uses this file [1] to know which package it was installed from,
    # so that it is able to provide appropriate instructions for updates.
    # [1] https://github.com/iterative/dvc/blob/0.68.1/dvc/utils/pkg.py
    File.write("dvc/utils/build.py", "PKG = \"brew\"")

    venv.pip_install_and_link buildpath

    (bash_completion/"dvc").write `#{bin}/dvc completion -s bash`
    (zsh_completion/"_dvc").write `#{bin}/dvc completion -s zsh`
  end

  test do
    output = shell_output("#{bin}/dvc doctor 2>&1")
    assert_match "azure", output
    assert_match "gdrive", output
    assert_match "gs", output
    assert_match "http", output
    assert_match "https", output
    assert_match "s3", output
    assert_match "ssh", output
    assert_match "webdav", output
    assert_match "webdavs", output
  end
end
