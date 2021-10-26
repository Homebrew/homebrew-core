class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://files.pythonhosted.org/packages/50/f1/fc4f80b92948f4ec3418c2621fb19609f668b19ed65ebbdc68eadb266ce1/dvc-2.8.2.tar.gz"
  sha256 "4577aa37f2befbeca93e87f6e570a16156ff24101ed1eb95fc5d0606ea114f46"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "391499a4522c73856f286f7b7f118256ba0ee282544f4f096c9a7c7aa6256eb9"
    sha256 cellar: :any,                 big_sur:       "17fe2b93ef9f875490131fa4da32ed3c5195f02b2d09e287052d388757b470f6"
    sha256 cellar: :any,                 catalina:      "30d2a0a6593360f774e89053cc99b2f38a70b7001d185fa1a12356049507a75c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "548a9fb6121eff20cb2526c203094a8d6dd4f4ecb2dd422a7fe05026af7003dd"
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
    url "https://files.pythonhosted.org/packages/4a/4c/2dc35d03068e964c20fac70cd954d1298d27d49c17dc478b136ede988ec7/aiobotocore-1.4.2.tar.gz"
    sha256 "c2f4ef325aaa839e9e2a53346b4c1c203656783a4985ab36fd4c2a9ef2dc1d2b"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/99/f5/90ede947a3ce2d6de1614799f5fea4e93c19b6520a59dc5d2f64123b032f/aiohttp-3.7.4.post0.tar.gz"
    sha256 "493d3299ebe5f5a7c66b9819eacdcfbbaaf1a8e84911ddffcdc48888497afecf"
  end

  resource "aiohttp-retry" do
    url "https://files.pythonhosted.org/packages/23/d9/6fcb308129ade81c50a09b3f534880946d46008e9cba727b80a1274dba4b/aiohttp_retry-2.4.6.tar.gz"
    sha256 "288c1a0d93b4b3ad92910c56a0326c6b055c7e1345027b26f173ac18594a97da"
  end

  resource "aioitertools" do
    url "https://files.pythonhosted.org/packages/78/f7/ea3904946e33c6e2799b5303e11ae5f43cf6b08dda58c8db8d759e34c3fb/aioitertools-0.8.0.tar.gz"
    sha256 "8b02facfbc9b0f1867739949a223f3d3267ed8663691cc95abd94e2c1d8c2b46"
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
    url "https://files.pythonhosted.org/packages/66/02/ca9061e93c487a897859e3a41f6c1a4f494038d2791382169b9a0c528175/anyio-3.3.4.tar.gz"
    sha256 "67da67b5b21f96b9d3d65daa6ea99f5d5282cb09f50eb4456f8fb51dffefc3ff"
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
    url "https://files.pythonhosted.org/packages/a1/78/aae1545aba6e87e23ecab8d212b58bb70e72164b67eb090b81bb17ad38e3/async-timeout-3.0.1.tar.gz"
    sha256 "0c3c816a028d47f659d6ff5c745cb2acf1f966da1fe5c19c77a70282b25f4c5f"
  end

  resource "asyncssh" do
    url "https://files.pythonhosted.org/packages/00/28/e667023c17edc6c257615dd9bc2d99431700599cdb5a212bdf122dbe469d/asyncssh-2.7.0.tar.gz"
    sha256 "185013d8e67747c3c0f01b72416b8bd78417da1df48c71f76da53c607ef541b6"
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
    url "https://files.pythonhosted.org/packages/39/1a/d553fc6f999759b125a434cad778b8f8b4fe5ef3a5dc303eb8b57fbd8423/azure-core-1.19.0.zip"
    sha256 "18d2a6cd3b7391489f005775fe69e4d0870f9384b755e45185efd45c050e2306"
  end

  resource "azure-datalake-store" do
    url "https://files.pythonhosted.org/packages/13/8b/2c151c9f4c3f5345d9a32889e15a471d98e426851b9fcf13dc9f134f5b93/azure-datalake-store-0.0.52.tar.gz"
    sha256 "4198ddb32614d16d4502b43d5c9739f81432b7e0e4d75d30e05149fe6007fea2"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/79/bb/82653e6f40895c4fc4a213d3b54010a59bb0a9b404ea3f76d9337ad686d1/azure-identity-1.7.0.zip"
    sha256 "3faaecb645e3b2300648a4a452458ec0e31e13d9dc928e710992e43ef4694205"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/c3/27/53976afdd9d66aa02b736b47dc991fe55ae5dd2be686b2ecb8dcf9f58930/azure-storage-blob-12.9.0.zip"
    sha256 "cff66a115c73c90e496c8c8b3026898a3ce64100840276e9245434e28a864225"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/4d/67/f27c22aad4221ac647a239f2f56fa7d86d8a09b21ad80744784fe371d1cf/boto3-1.17.106.tar.gz"
    sha256 "c0740378b913ca53f5fc0dba91e99a752c5a30ae7b58a0c5e54e3e2a68df26c5"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/91/21/e5d47bb39b19056e98d8caf93561af123074380f2d1c420151e723d0ae80/botocore-1.20.106.tar.gz"
    sha256 "6d5c983808b1d00437f56d0c08412bd82d9f8012fdb77e555f97277a1fd4d5df"
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

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/9f/c5/334c019f92c26e59637bb42bd14a190428874b2b2de75a355da394cf16c1/charset-normalizer-2.0.7.tar.gz"
    sha256 "e019de665e2bcf9c2b64e2e5aa025fa991da8720daa3c1138cadd2fd1856aed0"
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
    url "https://files.pythonhosted.org/packages/10/91/90b8d4cd611ac2aa526290ae4b4285aa5ea57ee191c63c2f3d04170d7683/cryptography-35.0.0.tar.gz"
    sha256 "9933f28f70d0517686bd7de36166dda42094eac49415459d9bdf5e7df3e0086d"
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
    url "https://files.pythonhosted.org/packages/49/07/079b8b4eb2aba194fca4562c7f014ea45a40130ebff539628c05c52d9050/diskcache-5.2.1.tar.gz"
    sha256 "1805acd5868ac10ad547208951a1190a0ab7bbff4e70f9a07cde4dbdfaa69f64"
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
    url "https://files.pythonhosted.org/packages/8a/ee/105b06f79efb7cf041d88267aa5027f0ac89e8650635e29ae1973638445b/dulwich-0.20.25.tar.gz"
    sha256 "79baea81583eb61eb7bd4a819ab6096686b362c626a4640d84d4fc5539139353"
  end

  resource "flatten-dict" do
    url "https://files.pythonhosted.org/packages/89/c6/5fe21639369f2ea609c964e20870b5c6c98a134ef12af848a7776ddbabe3/flatten-dict-0.4.2.tar.gz"
    sha256 "506a96b6e6f805b81ae46a0f9f31290beb5fa79ded9d80dbe1b7fa236ab43076"
  end

  resource "flufl.lock" do
    url "https://files.pythonhosted.org/packages/f4/3d/2f24d5661a51585507fede31ec6d4c4ba94366efbe046bfa6d7e8ce0425b/flufl.lock-6.0.tar.gz"
    sha256 "fc748ee609ec864b4838ef649dbd1170fa79deb0c213c2fd51151bee6a7fc242"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/dd/05/2bf31696ea1633d54e771f56b6080cdb7ba57f1be21fcc69808d141b3f4b/fsspec-2021.10.1.tar.gz"
    sha256 "c245626e3cb8de5cd91485840b215a385fa6f2b0f6ab87978305e99e2d842753"
  end

  resource "ftfy" do
    url "https://files.pythonhosted.org/packages/af/da/d215a091986e5f01b80f5145cff6f22e2dc57c6b048aab2e882a07018473/ftfy-6.0.3.tar.gz"
    sha256 "ba71121a9c8d7790d3e833c6c1021143f3e5c4118293ec3afb5d43ed9ca8e72b"
  end

  resource "funcy" do
    url "https://files.pythonhosted.org/packages/b2/74/6a505bf9f0dca368970f3549d0ceab1e21ae212bf74214169ec0def6fe4f/funcy-1.16.tar.gz"
    sha256 "2775409b7dc9106283f1224d97e6df5f2c02e7291c8caed72764f5a115dffb50"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "gcsfs" do
    url "https://files.pythonhosted.org/packages/c7/46/95dfbcc75a4ae6f4c32733c60fa24a2cbae602a6852baa9a6e07bc9f31d2/gcsfs-2021.10.1.tar.gz"
    sha256 "018744725cf1fd58da9515f3707503d41c4a816ae6f8b85ac31673fd11628639"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/34/fe/9265459642ab6e29afe734479f94385870e8702e7f892270ed6e52dd15bf/gitdb-4.0.7.tar.gz"
    sha256 "96bf5c08b157a666fec41129e6d327235284cca4c81e92109260f353ba138005"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/34/cc/aaa7a0d066ac9e94fbffa5fcf0738f5742dd7095bdde950bd582fca01f5a/GitPython-3.1.24.tar.gz"
    sha256 "df83fdf5e684fef7c6ee2c02fc68a5ceb7e7e759d08b694088d0cacb4eba59e5"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/df/31/048b8f0fe64de4218fd17218676e6b1ea95724a98ed4146c22c0b33acda4/google-api-core-2.1.1.tar.gz"
    sha256 "646d9399c3c478fe475cfe523e84572ab31a340814ea977fb2774eca5a6549a2"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/ff/de/4b391e331fc70832f2c09726d278dbea416076a631d989fddc82619bcbd9/google-api-python-client-2.27.0.tar.gz"
    sha256 "659e9955f0f1e02fcce5dec85622eb5af1807572ef0f09c49d68d8426da670e7"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/0c/69/504d2b70d10075c76499807b479ef5c3ffec672aadf8029412dda08abebc/google-auth-2.3.0.tar.gz"
    sha256 "2800f6dfad29c6ced5faf9ca0c38ea8ba1ebe2559b10c029bd021e3de3301627"
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
    url "https://files.pythonhosted.org/packages/66/5f/2cae690555463bfd9296df65eafdbcf828b9818944f793de7466f9681c40/google-cloud-core-2.1.0.tar.gz"
    sha256 "35a1f5f02a86e0fa2e28c669f0db4a76d928671a28fbbbb493ab59ba9d1cb9a9"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/cc/65/a68758fdbd74e9ab25e96ae6e7f97c669e47b65901c7aed18a1cccf07e68/google-cloud-storage-1.42.3.tar.gz"
    sha256 "7754d4dcaa45975514b404ece0da2bb4292acbc67ca559a69e12a19d54fcdb06"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/db/de/477cdcfd3ba2877cdf798f0328ea6aa79b2e632d169f5099d6240c4c4ebf/google-crc32c-1.3.0.tar.gz"
    sha256 "276de6273eb074a35bc598f8efbc00c7869c5cf2e29c90748fccc8c898c244df"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/ba/51/6e2db8e49ca5e75f0dbcc0d4e93768bc9f86b1c32565bea61d134ca62d4d/google-resumable-media-2.0.3.tar.gz"
    sha256 "b4b4709d04a6a03cbec746c2b5cb18f1f9878bf1ef3cd61908842a3d94c20471"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/1f/4a/369a8b1cf12089c1a902101b0431729e02cd2dd4e390377c920aa1d3ccab/googleapis-common-protos-1.53.0.tar.gz"
    sha256 "a88ee8903aa0a81f6c3cec2d5cf62d3c8aa67c06439b0496b49048fb1854ebf4"
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
    url "https://files.pythonhosted.org/packages/92/92/478727070c62def583e645ceeba18e69df266bf78e11639bc787c2386421/httplib2-0.20.1.tar.gz"
    sha256 "0efbcb8bfbfbc11578130d87d8afcc65c2274c6eb446e59fc674e4d7c972d327"
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
    url "https://files.pythonhosted.org/packages/b1/80/fb8c13a4cd38eb5021dc3741a9e588e4d1de88d895c1910c6fc8a08b7a70/isodate-0.6.0.tar.gz"
    sha256 "2e364a3d5759479cdb2d37cce6b9376ea504db2ff90252a2e5b7cc89cc9ff2d8"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/b2/4f/4c6fc2ee28055b961ebbbbed5e7f645c70e25b774b564ae152e3aa62ce9e/knack-0.8.2.tar.gz"
    sha256 "4eaa50a1c5e79d1c5c8e5e1705b661721b0b83a089695e59e229cc26c64963b9"
  end

  resource "mailchecker" do
    url "https://files.pythonhosted.org/packages/15/28/d93e1f03176ebe574d8bb226551180f869753a21a23b896528794d592e39/mailchecker-4.0.13.tar.gz"
    sha256 "4a9bf12cccbab22e819cad04cdad3f9b8f143dbd4e02c9e047726155e8cd0822"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/29/4b/e772f95418e4c2039a946a3a5e4274c15cb1ab3f46c3ea93afa6ac1d3ea7/msal-1.15.0.tar.gz"
    sha256 "00d3cc77c3bcd8e2accaf178aa58a1d036918faa9c0f3039772cc16a470bdacc"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/8e/76/32e0bc0ab99c439aadf854751601bf9ad8aca01c884cf30fab0a29746c6b/msal-extensions-0.3.0.tar.gz"
    sha256 "5523dfa15da88297e90d2e73486c8ef875a17f61ea7b7e2953a300432c2e7861"
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
    url "https://files.pythonhosted.org/packages/df/86/aef78bab3afd461faecf9955a6501c4999933a48394e90f03cd512aad844/packaging-21.0.tar.gz"
    sha256 "7dc96269f53a4ccec5c0670940a4281106dd0bb343f47b7471f779df49c2fbe7"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/f6/33/436c5cb94e9f8902e59d1d544eb298b83c84b9ec37b5b769c5a0ad6edb19/pathspec-0.9.0.tar.gz"
    sha256 "e564499435a2673d586f6b2130bb5b95f04a3ba06f81b8f895b651a3c76aabb1"
  end

  resource "phonenumbers" do
    url "https://files.pythonhosted.org/packages/9a/09/2416b2416542fa34de402063aa7b11ee648f5309ac013823c5e3e552e541/phonenumbers-8.12.35.tar.gz"
    sha256 "f426d419aabf6366c27ef1193918cc55217ef0e8be8f09cbf0667131037ca229"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/31/e3/b75d97109c793db0e23bcad15ab642da7517fe8dd6ad31567ed66ff51760/portalocker-1.7.1.tar.gz"
    sha256 "6d6f5de5a3e68c4dd65a98ec1babb26d28ccc5e770e07b672d65d5a35e4b2d8a"
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
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/64/ab/f2b4059ddf59bffbdbb4bdb60a6729c6c1de5eea1ef186d5a633ae12db3b/pycryptodome-3.11.0.tar.gz"
    sha256 "428096bbf7a77e207f418dfd4d7c284df8ade81d2dc80f010e92753a3e406ad0"
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
    url "https://files.pythonhosted.org/packages/11/31/211d72f836ba94990026155f7a2d52e1384a05b9c04592c0b8cbb926f404/pygit2-1.7.0.tar.gz"
    sha256 "602bffa8b4dbc185a6c7f36515563b600e0ee9002583c97ae3150eedaf340edb"
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
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
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
    url "https://files.pythonhosted.org/packages/4e/fd/5d40b0363467f8c87d5f5f551b7b431e234bff2becf959daab453f9d7795/rich-10.12.0.tar.gz"
    sha256 "83fb3eff778beec3c55201455c17cccde1ccdf66d5b4dade8ef28f56b50c4bd4"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/db/b5/475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269/rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/71/81/f597606e81f53eb69330e3f8287e9b5a3f7ed0481824036d550da705cd82/ruamel.yaml-0.17.16.tar.gz"
    sha256 "1a771fc92d3823682b7f0893ad56cb5a5c87c48e62b5399d6f42c8759a583b33"
  end

  resource "s3fs" do
    url "https://files.pythonhosted.org/packages/94/dc/27c989bd777f9baa7ad8c7c2394635190718f02a412b2ab3170dbc884f55/s3fs-2021.10.1.tar.gz"
    sha256 "493ae25053e5262552a247a9f1c3a2c8fbcd20f5907fce63a749126ba58fe05e"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/27/90/f467e516a845cf378d85f0a51913c642e31e2570eb64b352c4dc4c6cbfc7/s3transfer-0.4.2.tar.gz"
    sha256 "cb022f4b16551edebbb31a377d3f09600dbada7363d8c5db7976e7f47732e1b2"
  end

  resource "shortuuid" do
    url "https://files.pythonhosted.org/packages/6f/e0/a881ca1332e9195acb4c2b912d58a4278f6950e118b628188e2bc8830589/shortuuid-1.0.1.tar.gz"
    sha256 "3c11d2007b915c43bee3e10625f068d8a349e04f0d81f08f5fa08507427ebf1f"
  end

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/23/0b/ac9e560111691ed8dc3a8bdab5200b77142ee9de08d7818bf87c12a4718b/shtab-1.4.2.tar.gz"
    sha256 "a11f296bf149df2c1cc781941e485191298ad1b745dc11d01cb226c555aff7cb"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/dd/d4/2b4f196171674109f0fbb3951b8beab06cd0453c1b247ec0c4556d06648d/smmap-4.0.0.tar.gz"
    sha256 "7e65386bd122d45405ddf795637b7f7d2b532e7e401d46bbe3fb49b9986d5182"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a6/ae/44ed7978bcb1f6337a3e2bef19c941de750d73243fc9389140d62853b686/sniffio-1.2.0.tar.gz"
    sha256 "c4666eecec1d3f50960c6bdf61ab7bc350648da6c126e3cf6898d8cd4ddcd3de"
  end

  resource "sshfs" do
    url "https://files.pythonhosted.org/packages/78/4f/e195a080b22fec0f1dfdb498bf4ce7edf464272ad134b16a37afa57c951d/sshfs-2021.9.0.tar.gz"
    sha256 "b2b4e0bc50eb00a9ffc3e7fd502bde1aa5fb8321cd8e85deac12e01050f7cae6"
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
    url "https://files.pythonhosted.org/packages/ed/12/c5079a15cf5c01d7f4252b473b00f7e68ee711be605b9f001528f0298b98/typing_extensions-3.10.0.2.tar.gz"
    sha256 "49f75d16ff11f1cd258e1b988ccff82a3ca5570217d7ad8c5f48205dd99a677e"
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
    url "https://files.pythonhosted.org/packages/57/f0/b9c4beb5be22485ff0f09427dcc4e483dbf3a34fd5afb4f93cd6c68b2fac/wrapt-1.13.2.tar.gz"
    sha256 "dca56cc5963a5fd7c2aa8607017753f534ee514e09103a6c55d2db70b50e7447"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/7f/5c/a4ce6d4f46413afe49734bf901939105f4ce7fcfbcf87d0777cc39501060/yarl-1.7.0.tar.gz"
    sha256 "8e7ebaf62e19c2feb097ffb7c94deb0f0c9fab52590784c8cd679d30ab009162"
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
    File.open("dvc/utils/build.py", "w+") { |file| file.write("PKG = \"brew\"") }

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
