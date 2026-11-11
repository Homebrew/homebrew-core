class Parsedmarc < Formula
  include Language::Python::Virtualenv

  desc "DMARC report analyzer and visualizer"
  homepage "https://domainaware.github.io/parsedmarc/"
  url "https://files.pythonhosted.org/packages/dd/c4/d9c1330aa45f89d12ad219c81404f2605f356ec1436cb664577dc4f4e302/parsedmarc-11.2.2.tar.gz"
  sha256 "df380e4ef11dfacf2a46d9d4f4ea6518de35deacc116e3c226425c63d200ab4b"
  license "Apache-2.0"
  head "https://github.com/domainaware/parsedmarc.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f121b04d02facbfa4d37e57d231dd786e9dc309a02bf49a7ecbb81abf2c76d1d"
    sha256 cellar: :any, arm64_tahoe:       "31754e7ef55486c2d84761e1fa5cde68f107cd2a0e7a70d72ab829cce12e18a9"
    sha256 cellar: :any, arm64_sequoia:     "4e8ebd0c93216240aa9245621e4e3c801a1f2afe38109a63ac53468035be9978"
    sha256 cellar: :any, arm64_linux:       "16b5fba2ef315c1657549f4404fa9f30391fa4914c31459accd2d7c34ae61757"
    sha256 cellar: :any, x86_64_linux:      "d3c375844b8af325ebfb43006ee69abb5e3f9c271e749418adf3ef8fe6dd5f85"
  end

  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.15"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages package_name:     "parsedmarc[all]",
                exclude_packages: %w[certifi cryptography]

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/ce/f4/eec0465c2f67b2664688d0240b3212d5196fd89e741df67ddb81f8d35658/aiohappyeyeballs-2.7.1.tar.gz"
    sha256 "065665c041c42a5938ed220bdcd7230f22527fbec085e1853d2402c8a3615d9d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/6c/4c/bdccd81e9ee225b69c60e7766c9a5b05364f118f4d383713b89a682d772d/aiohttp-3.14.5.tar.gz"
    sha256 "5558a7f5a05af9ecf744af91e5baefc436f93c9333e656c27ec253f9a6bbe178"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
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
    url "https://files.pythonhosted.org/packages/cf/33/0b881d0093d64c965bb20fcf71b806c7097881b544a2a55d519cdcf3bab9/azure_identity-1.27.0.tar.gz"
    sha256 "6a4c50e25e8e9a47b324a95ad024897e56cb3c6241e0094e93b126a2bf71edc5"
  end

  resource "azure-monitor-ingestion" do
    url "https://files.pythonhosted.org/packages/71/a9/71d9da3ab13db73e3d4f344f9e4a06bc220d7fe7de8f96264d36ae2189d1/azure_monitor_ingestion-1.1.0.tar.gz"
    sha256 "97afee780d9ae3069128cde77027d4cc62fa824fe64d5bac880ac4a64b0a0c4e"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/ca/6b/2bc953d6f0b87505636d0a7c16e46a47ab6c49df4a278ac9c0b1c1732e65/boto3-1.43.127.tar.gz"
    sha256 "b5417e81d439b35ccf3a1eb51fa06cf9c97167c9a6beaa1929175ee9840d505a"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/8f/45/b4e606b0f66c11c6bd44e91381aa562c6b4dacf478b97b461a429036a89a/botocore-1.43.127.tar.gz"
    sha256 "93bae360fb3a6f1b8e36593faa8bbbfa05b19866f7a37e9606a98f13394156f8"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "dkimpy" do
    url "https://files.pythonhosted.org/packages/f0/6f/84e91828186bbfcedd7f9385ef5e0d369632444195c20e08951b7ffe0481/dkimpy-1.1.8.tar.gz"
    sha256 "b5f60fb47bbf5d8d762f134bcea0c388eba6b498342a682a21f1686545094b77"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/76/49/900383b471c645a3c397f47b3211d1fcecb3a540c98f683494cdf86b33de/dnspython-2.9.2.tar.gz"
    sha256 "8d4d39a513e649d634004ce4d39ade2352efcea472a0247535a5c2d18a9d7ba9"
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
    url "https://files.pythonhosted.org/packages/72/ef/63d89cb580f3a42c51db53b3d151352aa61b9c87ea8cfdd8d24ee6caa09d/google_api_core-2.44.0.tar.gz"
    sha256 "5ab9a396965c1227d7dea4581e562b7018aa2bca96d2de0be5eb70dc9c8ab3a1"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/b6/47/077e889d3c618d971d3bce4ab198c645a607276b8d4bb151cfe78d2c92bb/google_api_python_client-2.201.0.tar.gz"
    sha256 "d5691982abd7287f53cb0b0e0c6a9984d4103cf864ea0a88cb6e4347bbaf70de"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/c4/38/d79ab09dcfc1e1638d887c8f65657619d3ebc454165c558ef79355971ce3/google_auth-2.62.1.tar.gz"
    sha256 "3c8e1ce2553784ae17fd220e6f88df3281d86ab98019278f436d06dffab17a9e"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/bb/6d/a511ca64d5412850e351bdec6bb224e5090749bd85c186135e8fdb4fd85a/google_auth_httplib2-0.4.4.tar.gz"
    sha256 "b931de392c20cfaa351cd789274922bd8cdc001e0e9e96de31b39d71347f8e16"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/c4/40/1d7901e454831247e377ef3f642cb857cc0e82ec4d2380b7a148a48f20d1/google_auth_oauthlib-1.5.0.tar.gz"
    sha256 "b351107c7dd9017f426cbb0272ea1bc04f469020fd18f4443c7d40362e0b1510"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/62/b6/bc095b23a3e0d978e75c8c18cabe4c11f791837410670e4486f0d539bfba/googleapis_common_protos-1.76.0.tar.gz"
    sha256 "71db0e44a1d4c2dd024ebad44ca67129cc1e2892e4861df466764749d5ef8642"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/f0/03/f9e805772d4d01da2a1754a5f63c58601eacaf8f1e878729217188de7d16/grpcio-1.85.1.tar.gz"
    sha256 "5f530287d5de5f7f66089ead81de44f6787162944dab3922efa65dfdff108a1d"
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

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/c0/61/afa9d6b7452f9eca73f73d45324eb0bb52f098fd5e6049bf6b8263be9b4e/httpcore2-2.16.0.tar.gz"
    sha256 "c72cd0413563b17e1cd8354677dff887466f8ec2551679759e93126534428643"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/93/da/affa4b2adc11468c7d88d9b4258cac432479046edcf212284b55d4528593/httplib2-0.32.1.tar.gz"
    sha256 "37900eb8a74576bd99fc39ae1dc8409f95f965d45b56cbcb2194bb55f58a90e1"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/43/73/5ca2cedf5e4e50423d1c258877865a6b62793633b561c58499f8aeb33b7e/httpx2-2.16.0.tar.gz"
    sha256 "0d54c98128e8f2ff7fbbde0fca8c359e5f032edeaaaac443cdb7f31f685bcd7f"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/02/e7/94f8232d4a74cc99514c13a9f995811485a6903d48e5d952771ef6322e30/hyperframe-6.1.0.tar.gz"
    sha256 "f630908a00854a7adeabd6382b43923a4c4cd4b821fcb527e6ab9e15382a3b08"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "imapclient" do
    url "https://files.pythonhosted.org/packages/8d/f7/4e2d2e93313d7d7542a8378200ea931ff4e29b730d9eb5a9d8debafcbc68/imapclient-4.1.0.tar.gz"
    sha256 "b7cefa7c9bf3ec029c007dfade191480b82eb3816fc20ab23ef48e7aec841a7f"
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
    url "https://files.pythonhosted.org/packages/69/8f/7820b53ea017d615645cd29f5e73edf940906d20682b2b12506052a8a09b/kafka_python-3.0.13.tar.gz"
    sha256 "27161a9f5e0620eb6ec88324e0b3bd16e86d85d204bd29f8b5e8da351f6d11d0"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "mail-parser" do
    url "https://files.pythonhosted.org/packages/00/cc/20a5331698cc23ffe0e45955e12d57f1cc93c2ceb3873573757514f726b5/mail_parser-4.10.0.tar.gz"
    sha256 "2099f2620462342effe87aea7c6062cb87ddf8bdd05f1f718d5315d4476a4b75"
  end

  resource "mailsuite" do
    url "https://files.pythonhosted.org/packages/c6/79/19533c5a7d99f2d5ff02881b8ff1362e046b3e23dbfb2cced306aec961bd/mailsuite-2.3.6.tar.gz"
    sha256 "fe91357edbd16f8bf67052d6bdd5ed480c362ab63ef94c3a5dd91f9637c82d26"
  end

  resource "maxminddb" do
    url "https://files.pythonhosted.org/packages/b9/34/0923a42cce579398890058775ea145214acf80dd3340c26cfb0f16989300/maxminddb-3.2.0.tar.gz"
    sha256 "d28e0073fd1dd637c8b95947bc864b5625eca9f8f2db1538145e33b2a1cd4b92"
  end

  resource "microsoft-kiota-abstractions" do
    url "https://files.pythonhosted.org/packages/96/4b/552c5b6bf61d2dc6453e97ad207af694e8fd40258c1f2687329e921ed647/microsoft_kiota_abstractions-1.17.0.tar.gz"
    sha256 "80abade9214a094f2e0f6aa2d9f1f378286904df782dd62026695d73cc8cd135"
  end

  resource "microsoft-kiota-authentication-azure" do
    url "https://files.pythonhosted.org/packages/04/4d/ebf38d4e7f5284ada2819ebbd975f9b0525a5fbdeac69331e8716d05c40a/microsoft_kiota_authentication_azure-1.17.0.tar.gz"
    sha256 "9051ea9336f9fdb6d9f01590c100e69424587330038cecefa090240991941e8f"
  end

  resource "microsoft-kiota-http" do
    url "https://files.pythonhosted.org/packages/bb/ba/dbc238cfca3a980751a1c9acabeffb76aa3c578668faf787aa0c098bf450/microsoft_kiota_http-1.17.0.tar.gz"
    sha256 "d7f3563a718bef72c9333b5944f6cb0b67cede86425ada0b7e3f837b8f37e373"
  end

  resource "microsoft-kiota-serialization-form" do
    url "https://files.pythonhosted.org/packages/f8/d8/3f9dae5e8de1759072e2256119e4251280d7aa714b67487de503530880fd/microsoft_kiota_serialization_form-1.17.0.tar.gz"
    sha256 "b66b3c873c7aac0303d24931660c85dc6ba820a476d5093cbddbc435b5d1e0a4"
  end

  resource "microsoft-kiota-serialization-json" do
    url "https://files.pythonhosted.org/packages/a8/7e/ba5789d5bcae268265eefe8fa1415126a79a89ad0b9b4243e83bdfd74417/microsoft_kiota_serialization_json-1.17.0.tar.gz"
    sha256 "73268ed6f307cf14e568ebb25a9c5f4423501816a7daa13ad24aee226a79fded"
  end

  resource "microsoft-kiota-serialization-multipart" do
    url "https://files.pythonhosted.org/packages/5e/9b/b393909a8b2d7fe57de33cc96608717aa2cae0c671f3d1a4fe7e2a2dc39b/microsoft_kiota_serialization_multipart-1.17.0.tar.gz"
    sha256 "3522ec228ecda9b05245a7d54214b23d36655c724721bcf16a1657a61adafbc1"
  end

  resource "microsoft-kiota-serialization-text" do
    url "https://files.pythonhosted.org/packages/6a/04/7d31e6423a0a5dc6508f34d62af368b3b0a7e662a128f282b04759e4e6d6/microsoft_kiota_serialization_text-1.17.0.tar.gz"
    sha256 "a9d37fb0c89901f5ea38da8ecc38c20ec6a0b554e4e6fd792e59e459f18e2a0d"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/bb/85/747d28986a44b715cc51cf57aa021c8fd94e9614064261ceec77320e8b0b/msal-1.39.0.tar.gz"
    sha256 "6ab7de335e6d7f5717e2c7e1dbf86e4dda2f6acf3c56773b78dc53ebc6395b5f"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/01/99/5d239b6156eddf761a636bded1118414d161bd6b7b37a9335549ed159396/msal_extensions-1.3.1.tar.gz"
    sha256 "c5b0fd10f65ef62b5f1d62f4251d51cbcaf003fcedae8c91b040a488614be1a4"
  end

  resource "msgraph-core" do
    url "https://files.pythonhosted.org/packages/b6/bc/7519821548ddcc2b887dbd15f45a7859ca3d14d80e63ebb9c9feda4fafef/msgraph_core-1.5.2.tar.gz"
    sha256 "8ce6a4ffa76d0b4801c2b20df872dd85d4d925b8eceb9809e08d21daba3762cf"
  end

  resource "msgraph-sdk" do
    url "https://files.pythonhosted.org/packages/ed/fc/d2370f160e2453d2fc4e329a7a41f711407b0d098968a1417ce16095ff1a/msgraph_sdk-1.65.0.tar.gz"
    sha256 "4725563a199234ff360089ed632e71dfb0d718107ed08ac1e16e29d2214503f3"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/7b/6b/29ef8e752f5854dcc267ded0652c475bec99b86f255957a0d4fcad657b18/multidict-7.2.1.tar.gz"
    sha256 "e8af3e6f1bdbc31fd762b094133b478b89988eaebc63cbe82b1d9e3bbd15cede"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/33/17/2bb072de0b990303c985f26869fd47bb179024a051f47e7f9d208eb92f8e/oauthlib-4.0.1.tar.gz"
    sha256 "3d73febdb6faa00f277c81fb04be7b7586fb96fc3b7f0b9c772dada69a25ede7"
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
    url "https://files.pythonhosted.org/packages/19/14/cf3a6b6448849656e1e5f4e2101f3988dc6789724050096aba1bc5ccf592/opentelemetry_api-1.45.2.tar.gz"
    sha256 "d7b0008e21e5fd61cbe7a7f34ca3b6905a78ab677d9bc395e299359c75cda6b4"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/7b/1a/74a21d4d6969fb8b432ac397e66112a8167a6deb267ea4559dbaf2fe91ef/opentelemetry_sdk-1.45.2.tar.gz"
    sha256 "7eec4de13dd21ff3a1670dcb0e02079e692736f94d733dfdce5af461d884248d"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/37/3f/50f95972b50e8e353f5b9342034c9cd17730f1956f009ce6a3fbbd89f9ce/opentelemetry_semantic_conventions-0.66b2.tar.gz"
    sha256 "7da5f1a5dc4383eb66711d4d3d3e71824d9403ac1559fea021cc103c1a4c4976"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/b3/9a/9fbf4e4ec0c2d7f1c32519fff782ef467859b8faa9fbc5331a96f6395d43/propcache-0.5.4.tar.gz"
    sha256 "ff6b113f50bc066a698db5d944d2c6dc7507168dd3341e255a8892fd0715a558"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/46/70/783e33ffbb4466cc154a94f79b869b92a451e2bd45605054e68ff68b7af6/proto_plus-1.29.0.tar.gz"
    sha256 "cfb4e62ad7e13dd18f346cabbda00cab39930d36a05791fd81ddb074d6ee884f"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/d9/89/5b8517baa72f84a67b8a307ba953c91057af618bf40bf676f3c03551f8f0/protobuf-7.36.2.tar.gz"
    sha256 "497d0463ff3316681da6c0b9e8d06cb465d61abce00b613ab42226175644d1bb"
  end

  resource "publicsuffix2" do
    url "https://files.pythonhosted.org/packages/5a/04/1759906c4c5b67b2903f546de234a824d4028ef24eb0b1122daa43376c20/publicsuffix2-2.20191221.tar.gz"
    sha256 "00f8cc31aa8d0d5592a5ced19cccba7de428ebca985db26ac852d920ddd6fe7b"
  end

  resource "publicsuffixlist" do
    url "https://files.pythonhosted.org/packages/a6/96/d0b67e464e06d6e25449feeb915fbcdeaf9e51a3b33a9e5a909751854aa6/publicsuffixlist-1.1.2.20261109.tar.gz"
    sha256 "72da161a2381e991a789abea4947b2014806b05a29d2539de3fdc1f9d5dda152"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/88/7e/3c0da41061a2021cac7cd524fd57092adbe5b515e8bf9005702e366802e2/pyasn1-0.6.5.tar.gz"
    sha256 "6b11616a6bcf3a40e635f082bb232fa57b5e0dd7f517bd7ddd69ec3794508a47"
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
    url "https://files.pythonhosted.org/packages/43/ea/5194e52748b0da83d71e082d75496eaec6e58f419f5e184786ded517e6a9/pyjwt-2.15.1.tar.gz"
    sha256 "4f259e80cdfb6b3fc18a7de51fd1ef9ec79652f25019bae68975ca2468a34df8"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/e4/11/b213bebff182584360cb8d17c72c1677fec5c5c228de439e63bcf8ab1c8f/pyparsing-3.3.3.tar.gz"
    sha256 "928ae7e20211f3b6f3915a72f06a0cfd29ab9d24279dd6346b6b1a7146397d36"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
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
    url "https://files.pythonhosted.org/packages/49/c5/0a5ce655109cb96b8dfad36908a4e108d15f5dc2eff8fbc3146c4312e704/s3transfer-0.19.3.tar.gz"
    sha256 "8326acc3d056d7f7b8a37110c7d2aea41f67e83f6ae79cd3b5fbcca34c726406"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "std-uritemplate" do
    url "https://files.pythonhosted.org/packages/e6/13/856481251de9bf56c2190d10a2533a0407bc748e3bdbfd0f0c7982950e8c/std_uritemplate-2.0.13.tar.gz"
    sha256 "acdb8df280986572572a438877a90a243136042a7379152d3b2e05bd6507f989"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/ee/9f/c5201d42a484c061e528825fc8e2d565f5abd50a4ced6fb7d29c4ec99b2b/truststore-0.10.5.tar.gz"
    sha256 "30d36967ccaded5cbb38d602c433f53600036c79d502f4533a49b60a03bbefcd"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/98/60/f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56/uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/19/70/80f3b7c10d2630aa66414bf23d210386700aa390547278c789afa994fd7e/xmltodict-1.0.4.tar.gz"
    sha256 "6d94c9f834dd9e44514162799d344d815a3a4faec913717a9ecbfa5be1bb8e61"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/75/16/e8be8e2fb175bbf41a0680381a319f1199fae256588241a2ac8677eafb49/yarl-1.25.1.tar.gz"
    sha256 "03dd38de09bc213e9a8b29761eec33ee1d5318dac0e49d8af36e4d27830e23a7"
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
