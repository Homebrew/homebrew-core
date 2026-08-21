class Parsedmarc < Formula
  include Language::Python::Virtualenv

  desc "DMARC report analyzer and visualizer"
  homepage "https://domainaware.github.io/parsedmarc/"
  url "https://files.pythonhosted.org/packages/e0/34/d9b91a88e213b026c1ae4878622aca771601987ac0a1b3715caa8a7669d0/parsedmarc-10.4.3.tar.gz"
  sha256 "8f79566ecf0c44df3787b6bd332c755bc35fb72995f7cde454b6a73bdab17753"
  license "Apache-2.0"
  head "https://github.com/domainaware/parsedmarc.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e5a82ee9f0d47081b683691bec6a5a44b80118e3ef2320f1ccad43158d4cdd9e"
    sha256 cellar: :any, arm64_sequoia: "798f6d8d47212290d9e5f6e82ff472216220582beadf815ee01b41e55429e443"
    sha256 cellar: :any, arm64_sonoma:  "76cba78893f6cc906dcc1c2e777d8803973a598a3095f7276b1049498f4b7b2f"
    sha256 cellar: :any, sonoma:        "9eb0fb3483089f0208c8cdf7cf2b228e8a3c0e6279c65eb2fd62423c284b6e66"
    sha256 cellar: :any, arm64_linux:   "4b42b304b07733c1f923b042d9d026e83f853dafe9e6f89af360fcabbc812a90"
    sha256 cellar: :any, x86_64_linux:  "c5ec60d8994ca2d1d01dadae648e52fcc35d61a35f8b184293642f765291cb6b"
  end

  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: %w[certifi cryptography]

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

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/61/cc/a381afa6efea9f496eff839d4a6a1aed3bfafc7b3ab4b0d1b243a12573dd/anyio-4.14.2.tar.gz"
    sha256 "cfa139f3ed1a23ee8f88a145ddb5ac7605b8bbfd8592baacd7ce3d8bb4313c7f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "authres" do
    url "https://files.pythonhosted.org/packages/6a/29/e28209b5d3d56c102845cca5a4a3abaf2724f79e83476a52b94d775ecce6/authres-1.2.0.tar.gz"
    sha256 "93d1b995ad7ce21e62db649f361048125dd6022563a0ae8a23909465f1fd25b7"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/a6/f3/b416179e408990df5db0d516283022dde0f5d0111d98c1a848e41853e81c/azure_core-1.41.0.tar.gz"
    sha256 "f46ff5dfcd230f25cf1c19e8a34b8dc08a337b2503e268bb600a16c00db8ad5a"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/c5/0e/3a63efb48aa4a5ae2cfca61ee152fbcb668092134d3eb8bfda472dd5c617/azure_identity-1.25.3.tar.gz"
    sha256 "ab23c0d63015f50b630ef6c6cf395e7262f439ce06e5d07a64e874c724f8d9e6"
  end

  resource "azure-monitor-ingestion" do
    url "https://files.pythonhosted.org/packages/71/a9/71d9da3ab13db73e3d4f344f9e4a06bc220d7fe7de8f96264d36ae2189d1/azure_monitor_ingestion-1.1.0.tar.gz"
    sha256 "97afee780d9ae3069128cde77027d4cc62fa824fe64d5bac880ac4a64b0a0c4e"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/02/3b/a8c14b2390a54189b0b14c03376e05150dcc4c1a875d18bff8f6594d7494/boto3-1.43.74.tar.gz"
    sha256 "9d4d0dcf81c941cfe7d927486435521e0f3bf657cb68b10dfe445cfe311f8839"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/1d/fb/00969dfa9fee1d1e278a0e65109d07acacceae4acd177d9d9413479720ab/botocore-1.43.74.tar.gz"
    sha256 "b127b24d49532b5d7b0851b4abb3d3b99f58a121f87f07c23dac7c4d88b25c72"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/59/6a/9f06999c4f27e9192c5eb38bfffadc2e6752df8178e97e88b10b9eb4c682/dateparser-1.4.2.tar.gz"
    sha256 "bed2a3fd9bad8f2fb2d72b57748bada260b3a9349a264c22ffc23c3249d7049a"
  end

  resource "dkimpy" do
    url "https://files.pythonhosted.org/packages/f0/6f/84e91828186bbfcedd7f9385ef5e0d369632444195c20e08951b7ffe0481/dkimpy-1.1.8.tar.gz"
    sha256 "b5f60fb47bbf5d8d762f134bcea0c388eba6b498342a682a21f1686545094b77"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "elastic-transport" do
    url "https://files.pythonhosted.org/packages/fc/63/c61700c42f74d70a4ae11394c619cf91b837b500144166e828546f1fdd8d/elastic_transport-8.19.0.tar.gz"
    sha256 "32afed2a70dad80511476c821b2cf823f35a82153289765f6b2e2eb8cb0de099"
  end

  resource "elasticsearch" do
    url "https://files.pythonhosted.org/packages/6b/79/365e306017a9fcfbbefab1a3b588d2404bea8806b36766ff0f886509a20e/elasticsearch-8.19.3.tar.gz"
    sha256 "e84dd618a220cac25b962790085045dd27ac72e01c0a5d81bd29a2d47a71f03f"
  end

  resource "events" do
    url "https://files.pythonhosted.org/packages/25/ed/e47dec0626edd468c84c04d97769e7ab4ea6457b7f54dcb3f72b17fcd876/Events-0.5-py3-none-any.whl"
    sha256 "a7286af378ba3e46640ac9825156c93bdba7502174dd696090fdfcd4d80a1abd"
  end

  resource "expiringdict" do
    url "https://files.pythonhosted.org/packages/fc/62/c2af4ebce24c379b949de69d49e3ba97c7e9c9775dc74d18307afa8618b7/expiringdict-1.2.2.tar.gz"
    sha256 "300fb92a7e98f15b05cf9a856c1415b3bc4f2e132be07daa326da6414c23ee09"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/7b/7c/9be3903e3d45415e8ca493c75f8990a0f6f579d168015d44c379350d0ab0/google_api_core-2.34.0.tar.gz"
    sha256 "98a779fe72de956eb1c9c2f47ff4c4432a668ece1a002ec38bed07ec2698ae59"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/6b/53/0cd38e3a29d72ce45e27feba2ce1cd8049d69af9c48cb14fb164f1be9133/google_api_python_client-2.198.0.tar.gz"
    sha256 "dfe3e16fb241af6e9c460a33f65085b3450e05cea09364f6b5d8997fb7e43e2a"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/db/4c/fa42116a48bab3f7a143cf5042ecff7df9c8b73f8a376203cd534d1dc966/google_auth-2.56.3.tar.gz"
    sha256 "40e229fc901f0a305b553050e5fce562d509bee0435be053abfa91582b51b90c"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/11/46/79983cb738f0eb14e6ab4f43457aa9652f8d46bc4376b178f676b68c5c37/google_auth_httplib2-0.4.1.tar.gz"
    sha256 "125b1bb4fcfdd2d97f19b673c1f46f831603d0acaffe415c8a35dadb312552a1"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/70/18/90c7fac516e63cf2058166fce0c88c353647c677b51cc036c09c49bb5cbb/google_auth_oauthlib-1.4.0.tar.gz"
    sha256 "18b5e28880eb8eba9065c436becdc0ee8e4b59117a73a510679c82f70cd363d2"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/72/73/74bcab964c9a7a61f2bb71e8179b0f13e6fa98f7ce00fd168aab291e4a2e/googleapis_common_protos-1.75.1.tar.gz"
    sha256 "d3042c6c5a2d4e67113104d6b6818b59b6bd92a197f2a91508e801fe815cf071"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/0c/98/304898ac4e04e2d5e4e4c2eadc178b1f2a16d5f4bc2f91306c87d64680b9/grpcio-1.83.0.tar.gz"
    sha256 "7674587248fbbb2ac6e4eecf83a8a0f3d91a928f941de571acfd3a2f007fbc24"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/e7/85/7c366e69d84c17bb778fe41419e1fbcce3033d5b7ce29bbffff0a98b859f/h2-4.4.1.tar.gz"
    sha256 "4e866ffb1a869ae14dd9b5e6beb5c24a13da0495ad72b65925ded182521c1516"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/26/5b/fcabf6028144a8723726318b07a32c2f3314acdff6265743cf08a344b18e/hpack-4.2.0.tar.gz"
    sha256 "0895cfa3b5531fc65fe439c05eb65144f123bf7a394fcaa56aa423548d8e45c0"
  end

  resource "html2text" do
    url "https://files.pythonhosted.org/packages/f8/27/e158d86ba1e82967cc2f790b0cb02030d4a8bef58e0c79a8590e9678107f/html2text-2025.4.15.tar.gz"
    sha256 "948a645f8f0bc3abe7fd587019a2197a12436cd73d0d4908af95bfc8da337588"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/84/f5/ccf58de92d61e3ad921119668f54ed36ca1d0cf5dcc5c1657dfb164fd78b/httplib2-0.32.0.tar.gz"
    sha256 "48a0ef30a42db65d8f3399045e1d09ab0ba66e3b9efc360d07f80ea55d286025"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/02/e7/94f8232d4a74cc99514c13a9f995811485a6903d48e5d952771ef6322e30/hyperframe-6.1.0.tar.gz"
    sha256 "f630908a00854a7adeabd6382b43923a4c4cd4b821fcb527e6ab9e15382a3b08"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/5f/f7/abb373e5757eaec4b922b92f97ec8d6d7e057cf06778247604fbc4e7c3f3/idna-3.19.tar.gz"
    sha256 "5e0811a4383b21dc5838069f801c4fb62113b7447663d2530d2bd6e77b49bf15"
  end

  resource "imapclient" do
    url "https://files.pythonhosted.org/packages/58/79/8138f8c91e791f49cf4c2269b1eaaaddb93013d162e92ddc249b84d38105/imapclient-3.1.0.tar.gz"
    sha256 "b0413a516ffcc4b4d69f2c611c0e95da57968edf5a5c78ac82d1bf882305facc"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "kafka-python" do
    url "https://files.pythonhosted.org/packages/d5/6a/8a3bfb819b5350652dfa5365409b7c611eed8ae0b37c84f53d0a26ae9513/kafka_python-3.0.11.tar.gz"
    sha256 "a003d927e79c801d6cfd1e59ceaaf78807351e75cdb5b8ee9ce4262586f9780f"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/05/3b/aab6728cae887456f409b4d75e8a01856e4f04bd510de38052a47768b680/lxml-6.1.1.tar.gz"
    sha256 "ba96ae44888e0185281e937633a743ea90d5a196c6000f82565ebb0580012d40"
  end

  resource "mail-parser" do
    url "https://files.pythonhosted.org/packages/e4/6a/757fec81cd21048d1c18b21813280c222422a7d6bcd7e4c09d09f516b6db/mail_parser-4.6.2.tar.gz"
    sha256 "5b402aa262df7faa8c05759dc35003fef332cbeaba0e4d8753639acbab50841f"
  end

  resource "mailsuite" do
    url "https://files.pythonhosted.org/packages/67/26/1541682687781c85f8eac157847671bbfaf2a1abc581c534879bbec56538/mailsuite-2.3.1.tar.gz"
    sha256 "5dce87cf3f463492a76d41fec5ac148b8b19a62078dec168a8dd7587e55acb27"
  end

  resource "maxminddb" do
    url "https://files.pythonhosted.org/packages/31/83/bcd7f2e7dfcf601258a4eab92155816218e8f8adf6608d5f7d39da7ba863/maxminddb-3.1.1.tar.gz"
    sha256 "b19a938c481518f19a2c534ffdcb3bc59582f0fbbdcf9f81ac9adf912a0af686"
  end

  resource "microsoft-kiota-abstractions" do
    url "https://files.pythonhosted.org/packages/d4/30/00121e45175d11dbb24203a670d27513ff0ae761ffcb7c5c76354621dd82/microsoft_kiota_abstractions-1.11.9.tar.gz"
    sha256 "c731f270573689437c07b3ecd9533fed7d6d895e19d98ed5d3df5cec1750fe14"
  end

  resource "microsoft-kiota-authentication-azure" do
    url "https://files.pythonhosted.org/packages/cb/ff/d046a015e5865074c51a3b5275e3e4104075073b6c0ba94d803e00a475c8/microsoft_kiota_authentication_azure-1.11.9.tar.gz"
    sha256 "41ac68bb2b91488306742d4bdaa52d10d7fa4ecf61bd5aaeaebe0691bf2a17c0"
  end

  resource "microsoft-kiota-http" do
    url "https://files.pythonhosted.org/packages/20/48/333f4d5e9af6e59e2529895777b18b78382f23d0ad3f88defb62d4ecf8b0/microsoft_kiota_http-1.11.9.tar.gz"
    sha256 "a7254df64665cadb1ff081f6c8c4df86b98d2e901985b56e746ab91bfa516d75"
  end

  resource "microsoft-kiota-serialization-form" do
    url "https://files.pythonhosted.org/packages/97/b1/3e69a62f9a18e6ac59e6852d6743a092be2811e3da57ae21f4cc05972121/microsoft_kiota_serialization_form-1.11.9.tar.gz"
    sha256 "b4130eba95ab49e358d0726408387c87943d740ed0cbe73697c292d78f4ee6a1"
  end

  resource "microsoft-kiota-serialization-json" do
    url "https://files.pythonhosted.org/packages/20/8f/c3473031f1d09f92e4d46c6632ab0dbe5c66678c0d591a9ea427daa032b8/microsoft_kiota_serialization_json-1.11.9.tar.gz"
    sha256 "1c577ddd479051a34a92c889ab85bbd37cbc76fed661b0f40ecbbd96e98947c5"
  end

  resource "microsoft-kiota-serialization-multipart" do
    url "https://files.pythonhosted.org/packages/cc/f7/7f1cc3d102cd44cb8e98c902b36b9ac373b88205a6775261fe3bc5caa247/microsoft_kiota_serialization_multipart-1.11.9.tar.gz"
    sha256 "ad815dfba1618cf8be3a20f5355aa7e97947efbc06dfeca086360c0cd1b18dd8"
  end

  resource "microsoft-kiota-serialization-text" do
    url "https://files.pythonhosted.org/packages/bb/cf/5e276a80380d6cc0430f601535916d7987ccbb9c6e38e2fa4923a82f3940/microsoft_kiota_serialization_text-1.11.9.tar.gz"
    sha256 "d47e8c0b754e7f9716962fbef2ff10d23675c0e5a51993ea519fa05c775bbec0"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/9a/99/d840198ecf6e8057bbc937f129ae940404485d736cda73253bbff9537f01/msal-1.37.0.tar.gz"
    sha256 "1b1672a33ee467c1d70b341bb16cafd51bb3c817147a95b93263794b03971bec"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/01/99/5d239b6156eddf761a636bded1118414d161bd6b7b37a9335549ed159396/msal_extensions-1.3.1.tar.gz"
    sha256 "c5b0fd10f65ef62b5f1d62f4251d51cbcaf003fcedae8c91b040a488614be1a4"
  end

  resource "msgraph-core" do
    url "https://files.pythonhosted.org/packages/ec/99/702da0cb467040e754ad5342a7ee6e799aacf8d0f4161dd25ad3b1e7be76/msgraph_core-1.5.1.tar.gz"
    sha256 "1eecc9089ead63ab9cfca4cfb0751fc664088d6a53fc9ee1fc0574eddfba030b"
  end

  resource "msgraph-sdk" do
    url "https://files.pythonhosted.org/packages/59/31/121dd2fef52c544fe767f1e2d0e2badec507528ed03496e71965f2249889/msgraph_sdk-1.61.0.tar.gz"
    sha256 "fe3b2e21715d9523e3b15082421011a0067873f3b48c431208be988f17b34ed9"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "opensearch-protobufs" do
    url "https://files.pythonhosted.org/packages/d8/2f/e0cc165af7bb7b44cb00023b9fcaa01a28d1755a059ede28d0cd970c3cec/opensearch_protobufs-1.2.0-py3-none-any.whl"
    sha256 "e806730894d0a0c8cdaa3cdbe07e4b7c46e1823f453777b36caf39e9cba28e2c"
  end

  resource "opensearch-py" do
    url "https://files.pythonhosted.org/packages/82/9e/e77844cb2d625ca32331bfdd28930113b3778399c01dd5f1c350ceb55e65/opensearch_py-3.2.0.tar.gz"
    sha256 "f40fb3a295275422df2ad6d9459f667af94472d5a9e567072e9ecf163eb22613"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/ee/8b/aa9e2d8b8dfa7c946f7dec5d1f8f6ba8eca062f43509a06bdb5ce93d26c0/opentelemetry_api-1.44.0.tar.gz"
    sha256 "67647e5e9566edcf421166fdf022b3537f818635daa852b289e34604dc6fb33a"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/5d/77/a6592cbc7c8d9bcc9d6757a9df45e04a7c585e3e6e7a13456da522b21109/opentelemetry_sdk-1.44.0.tar.gz"
    sha256 "cebe7f65dc12f26ead75c6064de12fd2a9052e5060c0272d402cfa203aae123b"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/8f/73/0cbdebcb4cf545fdd328da14f5137e37d0770c3f26185e478b0d15d94f50/opentelemetry_semantic_conventions-0.65b0.tar.gz"
    sha256 "f9b2b81e9d5b64f11bc952075e7e9c7fb0aab075c7fd1c46d597f1b919852d60"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/ec/44/c87281c333769159c50594f22610f77398a47ccbfbbf23074e744e86f87c/propcache-0.5.2.tar.gz"
    sha256 "01c4fc7480cd0598bb4b57022df55b9ca296da7fc5a8760bd8451a7e63a7d427"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/26/6a/056256feb4bd000869aba5c16cf2aa911572ca2a2feb185f86e457b5171e/proto_plus-1.28.3.tar.gz"
    sha256 "5f91b30dafa6bb38d432c5557a6ee1d35ffd40b4b1e0e3ca27260448560b91d9"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/da/01/9ef0afd7999eb9badb3a768b4aedd78c86d4c65cfaf1958ab276199e76b4/protobuf-7.35.1.tar.gz"
    sha256 "ce115a26fe0c39a2c29973d914d327e516a6455464489fe3cd1e51a1b354f81a"
  end

  resource "publicsuffix2" do
    url "https://files.pythonhosted.org/packages/5a/04/1759906c4c5b67b2903f546de234a824d4028ef24eb0b1122daa43376c20/publicsuffix2-2.20191221.tar.gz"
    sha256 "00f8cc31aa8d0d5592a5ced19cccba7de428ebca985db26ac852d920ddd6fe7b"
  end

  resource "publicsuffixlist" do
    url "https://files.pythonhosted.org/packages/d2/bf/35bd7dc084c53cced65599969ad934eaffc31671fb4aaf36906288e4259d/publicsuffixlist-1.0.2.20260815.tar.gz"
    sha256 "1b66ddb654990327af8c43db20a1d217e1856176214a3c9bd548fbae34d68373"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/9a/23310166d960def5897e91fe20e5b724601b02a22e84ba1f94232c0b7f67/pyasn1-0.6.4.tar.gz"
    sha256 "9c447d8431c947fe4c8febc4ed9e760bc29011a5b01e5c74b67025bd9fb8ce81"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pygelf" do
    url "https://files.pythonhosted.org/packages/49/91/ac1605bb40092ae41fbb833ee55447f72e19ce5459efa6bd3beecc67e971/pygelf-0.4.3.tar.gz"
    sha256 "8ed972563be3c8f168483f01dbf522b6bc697959c97a3f4881324b3f79638911"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/3b/81/58d0ac84e1ef3a3843791d6954d94c0b33d526c75eeb1efbce9d0a4c4077/pyjwt-2.13.0.tar.gz"
    sha256 "41571c89ca91598c79e8ef18a2d07367d4810fbbd6f637794879baf1b7703423"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/fb/48/fb042503b6ca6cd271261dc559fd6432f7d8c713153e9ec5c591af4dfc1c/pytz-2026.3.post1.tar.gz"
    sha256 "2211d3fcf9a797d3405cac96ac7f61d80e6a644f72a3309607282fe8a2010c5d"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/20/98/04b13f1ddfb63158025291c02e03eb42fbb7acb51d091d541050eb4e35e8/regex-2026.7.19.tar.gz"
    sha256 "7e77b324909c1617cbb4c668677e2c6ae13f44d7c1de0d4f15f2e3c10f3315b5"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/76/43/35e4d8aa320bffe8287fe8f65f578fa2d2db0a64212f0e710dce58267854/s3transfer-0.19.2.tar.gz"
    sha256 "ba0309fd86be3c27dbf78cdd813c13c5e1df16e5874b99d2535ebbdfb9892993"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "std-uritemplate" do
    url "https://files.pythonhosted.org/packages/7a/f8/8f2b708394a6371e9b0e1cabdaf1be314f6b28c3697786a0a7e5f31ee9bf/std_uritemplate-2.0.12.tar.gz"
    sha256 "c245e6d9c6804e435c45fa94ee4a3c8a57e08aeeb45af261101cb0d513964534"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/21/3b/6c24bec5be5e743ffd99576daa5cc077722fc7d5bbc00bd133fa0c698dc6/tqdm-4.70.0.tar.gz"
    sha256 "55b0b0dbd97462d06ebee91e4dac24ed4d4702be82b24f07e6c1d27e08cea220"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/81/5b/879b2f932adfa7a053c360d50bc896c977fa6426109185f7c12ebdd0cb9d/tzlocal-5.4.4.tar.gz"
    sha256 "8dbb8660838688a7b6ba4fed31d18dedf842afb4d47ca050d6d891c2c15f3be4"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/98/60/f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56/uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/19/70/80f3b7c10d2630aa66414bf23d210386700aa390547278c789afa994fd7e/xmltodict-1.0.4.tar.gz"
    sha256 "6d94c9f834dd9e44514162799d344d815a3a4faec913717a9ecbfa5be1bb8e61"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/31/33/ebe9e3d1f86c7a0b51094c0a146392045ca1631d2664889539dec8088a33/yarl-1.24.5.tar.gz"
    sha256 "e81b83143bee16329c23db3c1b2d82b29892fcbcb849186d2f6e98a5abe9a57f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parsedmarc --version")

    touch testpath/"empty.xml"
    output = shell_output("#{bin}/parsedmarc empty.xml 2>&1")
    assert_match "Failed to parse empty.xml", output
  end
end
