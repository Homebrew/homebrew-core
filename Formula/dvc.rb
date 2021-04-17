class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://files.pythonhosted.org/packages/0f/3b/d51f69c500718eb65875dc8134370d1aedf1983327e284ab1464fc36c85a/dvc-2.1.0.tar.gz"
  sha256 "46cfbf0db27107fb3a2d5c643e3a948bb24539bf165ef70e77ce64283959e481"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b46bdccddfdba0c66b2347139c6c233ac9ab5c0444fc3a06dd9dbf111b6726da"
    sha256 cellar: :any, big_sur:       "61dd4903c533d4b02c2847ee3435b0ed6e0e11e8ed6b02e48de8e4e666baf6ce"
    sha256 cellar: :any, catalina:      "8ca4a65fdf2a7d1ce6e56ace647d573ee5876bbca293208ce2339098655682dc"
    sha256 cellar: :any, mojave:        "5a876797a39eea2728ab7a0bd66493dcf285c5efd45462023a2eb9f62fefe98e"
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
    url "https://files.pythonhosted.org/packages/81/93/4e8b882e6c4b0cd4c75f25bb8291f9b6fa1f7a432ea6dbfe52da114d3ff4/adlfs-0.7.4.tar.gz"
    sha256 "ddd0100199c124e4e15e59595f90183ad35855e192b73df1bb000ae509139c4a"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/99/f5/90ede947a3ce2d6de1614799f5fea4e93c19b6520a59dc5d2f64123b032f/aiohttp-3.7.4.post0.tar.gz"
    sha256 "493d3299ebe5f5a7c66b9819eacdcfbbaaf1a8e84911ddffcdc48888497afecf"
  end

  resource "aliyun-python-sdk-core" do
    url "https://files.pythonhosted.org/packages/ad/55/d1f3192da9d361c81590d41f601dc82ad95fa04f11be6245b6b9f8014435/aliyun-python-sdk-core-2.13.33.tar.gz"
    sha256 "23c4074b82b0148ecfea0d3c491e53d0073f96723e279f22b9563b2fa6d69ab7"
  end

  resource "aliyun-python-sdk-kms" do
    url "https://files.pythonhosted.org/packages/16/9e/9f4fdcee98e6d9f15217dcda94139827cbbf83284de5a6a3239a8e24a3ca/aliyun-python-sdk-kms-2.14.0.tar.gz"
    sha256 "8382847057e9f74205932358cf50b198aae81c1f931cef6fbb527edf6a940afc"
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

  resource "atpublic" do
    url "https://files.pythonhosted.org/packages/ab/3d/3df1468805427fedcf880da42fa26353feea3a31b5a0cc71008adcfdb816/atpublic-2.3.tar.gz"
    sha256 "d6b9167fc3e09a2de2d2adcfc9a1b48d84eab70753c97de3800362e1703e3367"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/f0/cb/80a4a274df7da7b8baf083249b0890a0579374c3d74b5ac0ee9291f912dc/attrs-20.3.0.tar.gz"
    sha256 "832aa3cde19744e49938b91fea06d69ecb9e649c93ba974535d08ad92164f700"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/d5/2d/269ab77f694cea9a02c7fb734744a4b52ecf92eb57b22a90cd7dcb83059d/azure-core-1.13.0.zip"
    sha256 "624b46db407dbed9e03134ab65214efab5b5315949a1fbd6cd592c46fb272588"
  end

  resource "azure-datalake-store" do
    url "https://files.pythonhosted.org/packages/13/8b/2c151c9f4c3f5345d9a32889e15a471d98e426851b9fcf13dc9f134f5b93/azure-datalake-store-0.0.52.tar.gz"
    sha256 "4198ddb32614d16d4502b43d5c9739f81432b7e0e4d75d30e05149fe6007fea2"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/09/73/a71e7bcd7e79afecf8cf5ec1a330804bc5e11f649436729d748df156d89d/azure-identity-1.5.0.zip"
    sha256 "872adfa760b2efdd62595659b283deba92d47b7a67557eb9ff48f0b5d04ee396"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/76/e9/563c5078837173e95f70c7b8ea70d66672d04263b833f02038e73e92faa9/azure-storage-blob-12.8.1.zip"
    sha256 "eb37b50ddfb6e558b29f6c8c03b0666514e55d6170bf4624e7261a3af93c6401"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d8/ba/21c475ead997ee21502d30f76fd93ad8d5858d19a3fad7cd153de698c4dd/bcrypt-3.2.0.tar.gz"
    sha256 "5b93c1726e50a93a033c36e5ca7fdcd29a5c7395af50a6892f5d9e7c6cfbfb29"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/c5/d6/af0c15b601e38bff38d975a231d8c4401d29e1385bf1ebb65b97cefa91e1/boto3-1.17.62.tar.gz"
    sha256 "d856a71d74351649ca8dd59ad17c8c3e79ea57734ff4a38a97611e1e10b06863"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/84/0f/19c3aa46381749e6a6bd24855fed7f732a7b768a580c15e138ecfa49b344/botocore-1.20.62.tar.gz"
    sha256 "f7c2c5c5ed5212b2628d8fb1c587b31c6e8d413ecbbd1a1cdf6f96ed6f5c8d5e"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/52/ba/619250fa6bc11ce6aa4de0604d45843090a53cd7d10d7253b89669313370/cachetools-4.2.2.tar.gz"
    sha256 "61b5ed1e22a0924aed1d23b478f37e8d52549ff8a961de2909c69bf950020cff"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a8/20/025f59f929bbcaa579704f443a438135918484fffaacfaddba776b374563/cffi-1.14.5.tar.gz"
    sha256 "fd78e5fee591709f32ef6edb9a015b4aa1a5022598e36227500c8f4e02328d9c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
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
    url "https://files.pythonhosted.org/packages/9b/77/461087a514d2e8ece1c975d8216bc03f7048e6090c5166bc34115afdaa53/cryptography-3.4.7.tar.gz"
    sha256 "3d10de8116d25649631977cb37da6cbdd2d6fa0e0281d014a5b7d337255ca713"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/da/93/84fa12f2dc341f8cf5f022ee09e109961055749df2d0c75c5f98746cfe6c/decorator-4.4.2.tar.gz"
    sha256 "e3a62f0520172440ca0dcc823749319382e377f37f140a0b99ef45fecb84bfe7"
  end

  resource "dictdiffer" do
    url "https://files.pythonhosted.org/packages/08/bf/9e878ffc50cbe57b63b46dee9f7689c8e1d6fa1c6b65f18a582c3e1a5ebd/dictdiffer-0.8.1.tar.gz"
    sha256 "1adec0d67cdf6166bda96ae2934ddb5e54433998ceab63c984574d187cc563d2"
  end

  resource "diskcache" do
    url "https://files.pythonhosted.org/packages/49/07/079b8b4eb2aba194fca4562c7f014ea45a40130ebff539628c05c52d9050/diskcache-5.2.1.tar.gz"
    sha256 "1805acd5868ac10ad547208951a1190a0ab7bbff4e70f9a07cde4dbdfaa69f64"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/a6/a4/75064c334d8ae433445a20816b788700db1651f21bdb0af33db2aab142fe/distro-1.5.0.tar.gz"
    sha256 "0e58756ae38fbd8fc3020d54badb8eae17c5b9dcbed388b17bb55b8a5928df92"
  end

  resource "dpath" do
    url "https://files.pythonhosted.org/packages/60/3f/562b045ad2542ab1279bbc5a05a62511c1ea1d8b5987fb0a50ee78704621/dpath-2.0.1.tar.gz"
    sha256 "bea06b5f4ff620a28dfc9848cf4d6b2bfeed34238edeb8ebe815c433b54eb1fa"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/31/02/791c17b92e6d04c43f9b318c95a3f3c3e1ea718aa72ad95b9dac147895fa/dulwich-0.20.21.tar.gz"
    sha256 "ac764c9a9b80fa61afe3404d5270c5060aa57f7f087b11a95395d3b76f3b71fd"
  end

  resource "flatten-dict" do
    url "https://files.pythonhosted.org/packages/7b/1c/52ee230b2008fd552e1b130d2696e98559ce9e2087fb49394bf71d23df3b/flatten-dict-0.3.0.tar.gz"
    sha256 "0ccc43f15c7c84c5ef387ad19254f6769a32d170313a1bcbf4ce582089313d7e"
  end

  resource "flufl.lock" do
    url "https://files.pythonhosted.org/packages/1e/68/393c148df629f90a919de653ebb967a8bd8c83d07d2bc3150ca0faff3940/flufl.lock-3.2.tar.gz"
    sha256 "a8d66accc9ab41f09961cd8f8db39f9c28e97e2769659a3567c63930a869ff5b"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/74/48/cb551051566afac1a13d56c303ab2aae81ae991a88f5f7db44385831c95a/fsspec-0.9.0.tar.gz"
    sha256 "3f7a62547e425b0b336a6ac2c2e6c6ac824648725bc8391af84bb510a63d1a56"
  end

  resource "ftfy" do
    url "https://files.pythonhosted.org/packages/ce/b5/5da463f9c7823e0e575e9908d004e2af4b36efa8d02d3d6dad57094fcb11/ftfy-6.0.1.tar.gz"
    sha256 "9eb68533eb2a6124e96ed7f63049e6c519194fda3fae92629b5e0b5753cb2c8f"
  end

  resource "funcy" do
    url "https://files.pythonhosted.org/packages/f0/50/f1a9e03bdb6935c77377d2e8762d9876b49b140825b8ac25131245e774f4/funcy-1.15.tar.gz"
    sha256 "65b746fed572b392d886810a98d56939c6e0d545abb750527a717c21ced21008"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "gcsfs" do
    url "https://files.pythonhosted.org/packages/1d/89/5e84feb030767fe151b1371fff772a982ff30c2485edbb5e957b14fdea8d/gcsfs-0.8.0.tar.gz"
    sha256 "6ffb81a93dc4075b056dacb5e8a661b75e79dd2e220538afae94768a6b7be3c6"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/34/fe/9265459642ab6e29afe734479f94385870e8702e7f892270ed6e52dd15bf/gitdb-4.0.7.tar.gz"
    sha256 "96bf5c08b157a666fec41129e6d327235284cca4c81e92109260f353ba138005"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/4a/8a/1519359949ce416eb059966c483fe340547a6fb5efb9f1dbcc0b33483146/GitPython-3.1.15.tar.gz"
    sha256 "05af150f47a5cca3f4b0af289b73aef8cf3c4fe2385015b06220cbcdee48bb6e"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/1f/11/5cd595fcbf4c85d4ab111d5e335ae52e811d910be93dafc7d4f37e6f4ed1/google-api-core-1.26.3.tar.gz"
    sha256 "b914345c7ea23861162693a27703bab804a55504f7e6e9abcaff174d80df32ac"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/62/44/c474be4ec1af5c0a0e38a00d0bf126572fe54d0b418b3549220f67e35251/google-api-python-client-2.3.0.tar.gz"
    sha256 "8a84834f929774bfec2cb1b467ffa9b44f647a8ccc85b07fbb8b173e1ae8c220"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/35/93/d5d63fde20def63d708b1f341c90d52fe75d0ade870975012e791583509e/google-auth-1.30.0.tar.gz"
    sha256 "9ad25fba07f46a628ad4d0ca09f38dcb262830df2ac95b217f9b0129c9e42206"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/c6/b5/a9e956fd904ecb34ec9d297616fe98fa4106fc12f3b0a914dec983c267b9/google-auth-httplib2-0.1.0.tar.gz"
    sha256 "a07c39fd632becacd3f07718dfd6021bf396978f03ad3ce4321d060015cc30ac"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/cd/b3/3897aefd988da1bd45953ace5c4fe9451a14aa0ada1f5d0bbb4d8d9e77be/google-auth-oauthlib-0.4.4.tar.gz"
    sha256 "09832c6e75032f93818edf1affe4746121d640c625a5bef9b5c96af676e98eee"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/1f/4a/369a8b1cf12089c1a902101b0431729e02cd2dd4e390377c920aa1d3ccab/googleapis-common-protos-1.53.0.tar.gz"
    sha256 "a88ee8903aa0a81f6c3cec2d5cf62d3c8aa67c06439b0496b49048fb1854ebf4"
  end

  resource "grandalf" do
    url "https://files.pythonhosted.org/packages/a2/3f/df0618a962a1744e932f2a4547cb786f5a93df7e2476c99e7f7dbd68039f/grandalf-0.6.tar.gz"
    sha256 "7471db231bd7338bc0035b16edf0dc0c900c82d23060f4b4d0c4304caedda6e4"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/ed/cd/533a1e9e04671bcee5d2854b4f651a3fab9586d698de769d93b05ee2bff1/httplib2-0.19.1.tar.gz"
    sha256 "0b12617eeca7433d4c396a100eaecfa4b08ee99aa881e6df6e257a7aad5d533d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/f0/bf/12827f26d127549b0c17aeb075b8bec2b0a48873418c51fca4bfcd0bd985/invoke-1.5.0.tar.gz"
    sha256 "f0c560075b5fb29ba14dad44a7185514e94970d1b9d57dcd3723bec5fed92650"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/b1/80/fb8c13a4cd38eb5021dc3741a9e588e4d1de88d895c1910c6fc8a08b7a70/isodate-0.6.0.tar.gz"
    sha256 "2e364a3d5759479cdb2d37cce6b9376ea504db2ff90252a2e5b7cc89cc9ff2d8"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "jsonpath-ng" do
    url "https://files.pythonhosted.org/packages/c5/d0/c4b2fa7e00e69670a92b103761b4e10a4bdaca109818d44753219c20b7be/jsonpath-ng-1.5.2.tar.gz"
    sha256 "144d91379be14d9019f51973bd647719c877bfc07dc6f3f5068895765950c69d"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/52/ff/78a46857700a241155370bb8f52fd2264f44fad35bf8819753ef68f06fc4/knack-0.8.1.tar.gz"
    sha256 "e61d9ae4e27199a2d74c261f81e9f82f5353a5d1c2e1ad25600a7d5109174ee0"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e5/21/a2e4517e3d216f0051687eea3d3317557bde68736f038a3b105ac3809247/lxml-4.6.3.tar.gz"
    sha256 "39b78571b3b30645ac77b95f7c69d1bffc4cf8c3b157c435a34da72e78c82468"
  end

  resource "mailchecker" do
    url "https://files.pythonhosted.org/packages/5d/4f/0e96f47b4847b0879893cbbbd5aaa70be32987cbb27f61a98fea97895986/mailchecker-4.0.7.tar.gz"
    sha256 "5b69c0053b271ee0bed6f6782111d8aace9aed151a67dcb6ff2eae30fe0d0878"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/f8/4c/425b2b921cb3ca77c18786577790616ffe78b0185f37cf54d460769d5547/msal-1.11.0.tar.gz"
    sha256 "467af02bb94a87a1b695b51bf867667e828acc0dd3c1de5fa543f69002db49fa"
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
    url "https://files.pythonhosted.org/packages/1c/74/e8b46156f37ca56d10d895d4e8595aa2b344cff3c1fb3629ec97a8656ccb/multidict-5.1.0.tar.gz"
    sha256 "25b4e5f22d3a37ddf3effc0710ba692cfc792c2b9edfb9c05aefe823256e84d5"
  end

  resource "nanotime" do
    url "https://files.pythonhosted.org/packages/d5/54/6d5924f59cf671326e7809f4b3f70fa8df535d67e952ad0b6fea02f52faf/nanotime-0.5.2.tar.gz"
    sha256 "c7cc231fc5f6db401b448d7ab51c96d0a4733f4b69fabe569a576f89ffdf966b"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/b0/21/adfbf6168631e28577e4af9eb9f26d75fe72b2bb1d33762a5f2c425e6c2a/networkx-2.5.1.tar.gz"
    sha256 "109cd585cac41297f71103c3c42ac6ef7379f29788eb54cb751be5a663bb235a"
  end

  resource "oauth2client" do
    url "https://files.pythonhosted.org/packages/a6/7b/17244b1083e8e604bf154cf9b716aecd6388acd656dd01893d0d244c94d9/oauth2client-4.1.3.tar.gz"
    sha256 "d486741e451287f69568a4d26d70d9acd73a2bbfa275746c535b4209891cccc6"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/fc/c7/829c73c64d3749da7811c06319458e47f3461944da9d98bb4df1cb1598c2/oauthlib-3.1.0.tar.gz"
    sha256 "bee41cc35fcca6e988463cacc3bcb8a96224f470ca547e697b604cc697b2f889"
  end

  resource "oss2" do
    url "https://files.pythonhosted.org/packages/4e/0a/c2c1bc04f2b0c43e5b54ade829f4e8c35aa13db42171252b1dd62780ffa5/oss2-2.14.0.tar.gz"
    sha256 "7fed58200da934ad4b8c1fb2754a1ac6bfd40a073f35e65b94880268b9f7fb48"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/cf/a1/20d00ce559a692911f11cadb7f94737aca3ede1c51de16e002c7d3a888e0/paramiko-2.7.2.tar.gz"
    sha256 "7f36f4ba2c0d81d219f4595e35f70d56cc94f9ac40a6acdf51d6ca210ce65035"
  end

  resource "pathlib2" do
    url "https://files.pythonhosted.org/packages/94/d8/65c86584e7e97ef824a1845c72bbe95d79f5b306364fa778a3c3e401b309/pathlib2-2.3.5.tar.gz"
    sha256 "6cd9a47b597b37cc57de1c05e56fb1a1c9cc9fab04fe78c29acd090418529868"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/b7/64/e097eea8dcd2b2f7df6e4425fc98e7494e37b1a6e149603c31d327080a05/pathspec-0.8.1.tar.gz"
    sha256 "86379d6b86d75816baba717e64b1a3a3469deb93bb76d613c9ce79edc5cb68fd"
  end

  resource "phonenumbers" do
    url "https://files.pythonhosted.org/packages/a4/87/9107104be8ebed5c1d31ad3771c0560bb2040e6b89f21bbdde3110bbee11/phonenumbers-8.12.22.tar.gz"
    sha256 "b20765cb9d1392308071a3462c06edcaa953cb383e3565f5fc0a6fb93f240150"
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
    url "https://files.pythonhosted.org/packages/88/7f/740b99ffb8173ba9d20eb890cc05187677df90219649645aca7e44eb8ff4/pycryptodome-3.10.1.tar.gz"
    sha256 "3e2e3a06580c5f190df843cdb90ea28d61099cf4924334d5297a995de68e4673"
  end

  resource "pydot" do
    url "https://files.pythonhosted.org/packages/13/6e/916cdf94f9b38ae0777b254c75c3bdddee49a54cc4014aac1460a7a172b3/pydot-1.4.2.tar.gz"
    sha256 "248081a39bcb56784deb018977e428605c1c758f10897a339fce1dd728ff007d"
  end

  resource "PyDrive2" do
    url "https://files.pythonhosted.org/packages/ec/32/db287b0b36a29bf6466ea287c75c366046a8a94a8a59cc41171b463c593b/PyDrive2-1.8.2.tar.gz"
    sha256 "53aee1c4301cf119dbdc555bfa017a9579c70f8cb9a24e930edfb90ec6b61aed"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/65/af/0544463f7eebb7a953767b55d101af021e3d94f5d12738efc4be01c10d55/pygit2-1.5.0.tar.gz"
    sha256 "9711367bd05f96ad6fc9c91d88fa96126ba2d1f1c3ea6f23c11402c243d66a20"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
  end

  resource "pygtrie" do
    url "https://files.pythonhosted.org/packages/18/41/2e5cefc895a32d9ca0f3574bd0df09e53a697023579a93582bedc4eeac4d/pygtrie-2.3.2.tar.gz"
    sha256 "6299cdedd2cbdfda0895c2dbc43efe8828e698c62b574f3ef7e14b3253f80e23"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/0c/c6/3cdc7cb1289b35186fd7fd61836b6d83632ca0f7eee552516777361667b1/PyJWT-2.1.0.tar.gz"
    sha256 "fba44e7898bbca160a2b2b501f492824fc8382485d3a6f11ba5d0c1937ce6130"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/cf/5a/25aeb636baeceab15c8e57e66b8aa930c011ec1c035f284170cacb05025e/PyNaCl-1.4.0.tar.gz"
    sha256 "54e9a2c849c742006516ad56a88f5c74bf2ce92c9f67435187c3c5953b346505"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/98/cd/cbc9c152daba9b5de6094a185c66f1c6eb91c507f378bb7cad83d623ea88/pyOpenSSL-20.0.1.tar.gz"
    sha256 "4c231c759543ba02560fcd2480c48dcec4dae34c9da7d3747c508227e0624b51"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "python-benedict" do
    url "https://files.pythonhosted.org/packages/13/2e/f799845699100d1ea31fa190dc7322782ad960554c90085f89871f829014/python-benedict-0.23.2.tar.gz"
    sha256 "b7bdffd92ba1c9b9e044bda08ed545a48a45bd7a5207f93b4b2a8eb2660d1b4c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "python-fsutil" do
    url "https://files.pythonhosted.org/packages/27/56/9aab18bd4769d515b49e9e3fcf827264bc131b36fa73212753cd5575e0a1/python-fsutil-0.4.0.tar.gz"
    sha256 "873eceb11fb488fc2d7675cd1bc74a743502f674f0be88f5e7b920c7baeefed6"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/40/78/dc0c2931eb93db0339d958f7cbbcb6591031b3e5d2759c927bd603b98786/python-slugify-5.0.0.tar.gz"
    sha256 "744cd5d42b381687657f3b652d1d9b183c0870ec43de23be682b6d83d69c6962"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/b0/61/eddc6eb2c682ea6fd97a7e1018a6294be80dba08fa28e7a3570148b4612d/pytz-2021.1.tar.gz"
    sha256 "83a4a90894bf38e243cf052c8b58f381bfe9a7a483f6a9cab140bc7f702ac4da"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/23/eb/68fc8fa86e0f5789832f275c8289257d8dc44dbe93fce7ff819112b9df8f/requests-oauthlib-1.3.0.tar.gz"
    sha256 "b4261601a71fd721a8bd6d7aa1cc1d6a8a93b4a9f5e96626f8e4d91e8beeaa6a"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/12/3c/e4e2b356057f3ce557fcda8a2b9bf114b06f71ade88dac8a0883ae800e28/rich-10.1.0.tar.gz"
    sha256 "8f05431091601888c50341697cfc421dc398ce37b12bca0237388ef9c7e2c9e9"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/db/b5/475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269/rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/62/cf/148028462ab88a71046ba0a30780357ae9e07125863ea9ca7808f1ea3798/ruamel.yaml-0.17.4.tar.gz"
    sha256 "44bc6b54fddd45e4bc0619059196679f9e8b79c027f4131bb072e6a22f4d5e28"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/fa/a1/f9c009a633fce3609e314294c7963abe64934d972abea257dce16a15666f/ruamel.yaml.clib-0.2.2.tar.gz"
    sha256 "2d24bd98af676f4990c4d715bcdc2a60b19c56a3fb3a763164d2d8ca0e806ba7"
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
    url "https://files.pythonhosted.org/packages/4f/9f/1718447f3db4ddc308da97135bdb2a5df325301f99c9a02b8c3e95e573e9/shtab-1.3.6.tar.gz"
    sha256 "7e587e2889b4e51339b6c59c956b3f0eb5194113967d913515025406d5be849c"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/dd/d4/2b4f196171674109f0fbb3951b8beab06cd0453c1b247ec0c4556d06648d/smmap-4.0.0.tar.gz"
    sha256 "7e65386bd122d45405ddf795637b7f7d2b532e7e401d46bbe3fb49b9986d5182"
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
    url "https://files.pythonhosted.org/packages/35/35/bd5af89c97ad5177ed234d9e79d01a984f8b5226b8ffc8b5d3c4fc8e157d/tqdm-4.60.0.tar.gz"
    sha256 "ebdebdb95e3477ceea267decfc0784859aa3df3e27e22d23b83e9b272bf157ae"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/aa/55/62e2d4934c282a60b4243a950c9dbfa01ae7cac0e8d6c0b5315b87432c81/typing_extensions-3.10.0.0.tar.gz"
    sha256 "50b6f157849174217d0656f99dc82fe932884fb250826c18350e159ec6cdf342"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/86/0a/80d87aa4ee79980bddabef13cb7d95de330f85355cf08dfdaf874889b02b/ujson-4.0.2.tar.gz"
    sha256 "c615a9e9e378a7383b756b7e7a73c38b22aeb8967a8bfbffd4741f7ffd043c4d"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/42/da/fa9aca2d866f932f17703b3b5edb7b17114bb261122b6e535ef0d9f618f8/uritemplate-3.0.1.tar.gz"
    sha256 "5af8ad10cec94f215e3f48112de2022e1d5a37ed427fbd88652fa908f2ab7cae"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/cb/cf/871177f1fc795c6c10787bc0e1f27bb6cf7b81dbde399fd35860472cecbc/urllib3-1.26.4.tar.gz"
    sha256 "e7b021f7241115872f92f43c6508082facffbd1c048e3c6e2bb9c2a157e28937"
  end

  resource "voluptuous" do
    url "https://files.pythonhosted.org/packages/17/0d/6e1e3ab6653720903efd7f644cc5be839d59ceb396143c08c1bebeab080b/voluptuous-0.12.1.tar.gz"
    sha256 "663572419281ddfaf4b4197fd4942d181630120fb39b333e3adad70aeb56444b"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  resource "webdavclient3" do
    url "https://files.pythonhosted.org/packages/9c/7f/7f5705a2684bcd42560550e7291994bbb26406f37bedc3d291ea12ece5f2/webdavclient3-3.14.5.tar.gz"
    sha256 "6072f9a583059f8ff313f8544d415b4191fc89bdf6230259b0527b706ab1837b"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/97/e7/af7219a0fe240e8ef6bb555341a63c43045c21ab0392b4435e754b716fa1/yarl-1.6.3.tar.gz"
    sha256 "8a9066529240171b68893d60dca86a763eae2139dd42f42106b03cf4b426bf10"
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
    system "#{bin}/dvc", "version"
  end
end
