class Parsedmarc < Formula
  include Language::Python::Virtualenv

  desc "DMARC report analyzer and visualizer"
  homepage "https://domainaware.github.io/parsedmarc/"
  url "https://files.pythonhosted.org/packages/4f/64/920c9a6bacd2bf967c19faeb121639c0662501c6d9b95908a1b16c87585a/parsedmarc-8.12.0.tar.gz"
  sha256 "9ac71cdd344c62e693aabaf118f09554a6b67e0e6c5f02bf0609696ef2d76cb7"
  license "Apache-2.0"
  revision 2
  head "https://github.com/domainaware/parsedmarc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27e2c5a64c3ab7066bfecd3e2c3337f4a3394c64c17743a5f65a58a82ff6eb9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a9424cc03ee4099dbf64bd5bf579391bee28a04160c914b5f057aa7b83d1ad3"
    sha256 cellar: :any,                 arm64_monterey: "a0d2d3ea38a1093711aac8f153470eaaa6e65c48a5768addd9d2898c531b406a"
    sha256 cellar: :any_skip_relocation, sonoma:         "5afc7a4f47758172adff03d2862a0b36bf27732f682882acb36ba3fcbe32b293"
    sha256 cellar: :any_skip_relocation, ventura:        "0b86ef3ad2fa9579c130d69b8576bec4faa59e84e046c9e4adbfad77a83eb105"
    sha256 cellar: :any,                 monterey:       "922c820e25e6e194b6d0f4a50501560aad796c041dd900df485b66d89826ea56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5b32087b0f2d726eda4ef2ada4cb57323411ebcc9e43853685420bf9a88de2e"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/b7/c3/112f2f992aeb321de483754c1c5acab08c8ac3388c9c7e6f3e4f45ec1c42/aiohappyeyeballs-2.3.5.tar.gz"
    sha256 "6fa48b9f1317254f122a07a131a86b71ca6946ca989ce6326fff54a99a920105"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/45/11/36ba898823ab19e49e6bd791d75b9185eadef45a46fc00d3c669824df8a0/aiohttp-3.10.2.tar.gz"
    sha256 "4d1f694b5d6e459352e5e925a42e05bac66655bfde44d81c59992463d2897014"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/99/d4/1f469fa246f554b86fb5cebc30eef1b2a38b7af7a2c2791bce0a4c6e4604/azure-core-1.30.2.tar.gz"
    sha256 "a14dc210efcd608821aa472d9fb8e8d035d29b68993819147bc290a8ac224472"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/51/c9/f7e3926686a89670ce641b360bd2da9a2d7a12b3e532403462d99f81e9d5/azure-identity-1.17.1.tar.gz"
    sha256 "32ecc67cc73f4bd0595e4f64b1ca65cd05186f4fe6f98ed2ae9f1aa32646efea"
  end

  resource "azure-monitor-ingestion" do
    url "https://files.pythonhosted.org/packages/7d/41/4faf617e09a90f45c253190e600941bf97f10cfd1a811ec139ae3b54e56b/azure-monitor-ingestion-1.0.4.tar.gz"
    sha256 "254d75993a1fe707d198f014aef5a14faa570cee7369b35bb03ae2aa8f99be79"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/33/ee/df4ec3cb6f292cfcc665562fbafafb68a6fe525c5a6476ab48a92b5ab669/boto3-1.34.158.tar.gz"
    sha256 "5b7b2ce0ec1e498933f600d29f3e1c641f8c44dd7e468c26795359d23d81fa39"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/dc/14/77b36078a68e756ffc05c0101a0eb4039430fda00f5aa601a6340f7a9fb6/botocore-1.34.158.tar.gz"
    sha256 "5934082e25ad726673afbf466092fb1223dafa250e6e756c819430ba6b1b3da5"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/a7/3f/ea907ec6d15f68ea7f381546ba58adcb298417a59f01a2962cb5e486489f/cachetools-5.4.0.tar.gz"
    sha256 "b8adc2e7c07f105ced7bc56dbb6dfbe7c4a00acce20e2227b3f355be89bc6827"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/1a/b2/f6b29ab17d7959eb1a0a5c64f5011dc85051ad4e25e401cbddcc515db00f/dateparser-1.2.0.tar.gz"
    sha256 "7975b43a4222283e0ae15be7b4999d08c9a70e2d378ac87385b1ccf2cffbbb30"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/37/7d/c871f55054e403fdfd6b8f65fd6d1c4e147ed100d3e9f9ba1fe695403939/dnspython-2.6.1.tar.gz"
    sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
  end

  resource "elasticsearch" do
    url "https://files.pythonhosted.org/packages/06/50/220b2d903eccaf6065b4d2d546c06d216e3c8eabcb8d9cd56af691cb712b/elasticsearch-7.13.4.tar.gz"
    sha256 "52dda85f76eeb85ec873bf9ffe0ba6849e544e591f66d4048a5e48016de268e0"
  end

  resource "elasticsearch-dsl" do
    url "https://files.pythonhosted.org/packages/ea/a1/86b304895d346eb5d4c51584f7d3f02ba91131efbe2545e867b62275976b/elasticsearch-dsl-7.4.0.tar.gz"
    sha256 "c4a7b93882918a413b63bed54018a1685d7410ffd8facbc860ee7fd57f214a6d"
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
    url "https://files.pythonhosted.org/packages/cf/3d/2102257e7acad73efc4a0c306ad3953f68c504c16982bbdfee3ad75d8085/frozenlist-1.4.1.tar.gz"
    sha256 "c037a86e8513059a2613aaba4d817bb90b9d9b6b69aace3ce9c877e8c8ed402b"
  end

  resource "geoip2" do
    url "https://files.pythonhosted.org/packages/a7/ae/892642e21881f95bdcb058580e74aaa3de0ee5ee4f76ccec02745f2a3abe/geoip2-4.8.0.tar.gz"
    sha256 "dd9cc180b7d41724240ea481d5d539149e65b234f64282b231b9170794a9ac35"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/c2/41/42a127bf163d9bf1f21540a3bf41c69b231b88707d8d753680b8878201a6/google-api-core-2.19.1.tar.gz"
    sha256 "f4695f1e3650b316a795108a76a1c416e6afb036199d1c1f1f110916df479ffd"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/23/7a/2c98d0454a7f59199be817a043d694a7d4f89febb022ef24ea062722a0fe/google_api_python_client-2.140.0.tar.gz"
    sha256 "0bb973adccbe66a3d0a70abe4e49b3f2f004d849416bfec38d22b75649d389d8"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/28/4d/626b37c6bcc1f211aef23f47c49375072c0cb19148627d98c85e099acbc8/google_auth-2.33.0.tar.gz"
    sha256 "d6a52342160d7290e334b4d47ba390767e4438ad0d45b7630774533e82655b95"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/56/be/217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacef/google-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/cc/0f/1772edb8d75ecf6280f1c7f51cbcebe274e8b17878b382f63738fd96cee5/google_auth_oauthlib-1.2.1.tar.gz"
    sha256 "afd0cad092a2eaa53cd8e8298557d6de1034c6cb4a740500b5357b648af97263"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/0b/1a/41723ae380fa9c561cbe7b61c4eef9091d5fe95486465ccfc84845877331/googleapis-common-protos-1.63.2.tar.gz"
    sha256 "27c5abdffc4911f28101e635de1533fb4cfd2c37fbaa9174587c799fac90aa87"
  end

  resource "html2text" do
    url "https://files.pythonhosted.org/packages/1a/43/e1d53588561e533212117750ee79ad0ba02a41f52a08c1df3396bd466c05/html2text-2024.2.26.tar.gz"
    sha256 "05f8e367d15aaabc96415376776cdd11afd5127a77fce6e36afc60c563ca2c32"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "imapclient" do
    url "https://files.pythonhosted.org/packages/b6/63/0eea51c9c263c18021cdc5866def55c98393f3bd74bbb8e3053e36f0f81a/IMAPClient-3.0.1.zip"
    sha256 "78e6d62fbfbbe233e1f0e0e993160fd665eb1fd35973acddc61c15719b22bc02"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "kafka-python-ng" do
    url "https://files.pythonhosted.org/packages/9f/19/e4a236b7504ef39ebca780c6a11481a3d2db759f9878cb0a4fbc8b08b243/kafka-python-ng-2.2.2.tar.gz"
    sha256 "87ad3a766e2c0bec71d9b99bdd9e9c5cda62d96cfda61a8ca16510484d6ad7d4"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/63/f7/ffbb6d2eb67b80a45b8a0834baa5557a14a5ffce0979439e7cd7f0c4055b/lxml-5.2.2.tar.gz"
    sha256 "bb2dc4898180bea79863d5487e5f9c7c34297414bad54bcd0f0852aee9cfdb87"
  end

  resource "mail-parser" do
    url "https://files.pythonhosted.org/packages/2b/3d/7f096230c4b61857c7682dc5497000a987b5f7e8376f54f0a5ed73e2cc3d/mail-parser-3.15.0.tar.gz"
    sha256 "d66638acf0633dfd8a718e1e3646a6d58f8e9d75080c94638c7b267b4b0d6c86"
  end

  resource "mailsuite" do
    url "https://files.pythonhosted.org/packages/76/c9/9819d416b6eae6332a26390198f7d20cd240b673608612bd01310802f8a4/mailsuite-1.9.15.tar.gz"
    sha256 "4789c0a61c9d6a66688d047ba6ba396377598379d82b4f97e6514130952909fc"
  end

  resource "maxminddb" do
    url "https://files.pythonhosted.org/packages/9f/9e/7806bf76d917182a4f4a08325f66eee6f32fe1123398789ba2547b5d3f3e/maxminddb-2.6.2.tar.gz"
    sha256 "7d842d32e2620abc894b7d79a5a1007a69df2c6cf279a06b94c9c3913f66f264"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/03/ce/45b9af8f43fbbf34d15162e1e39ce34b675c234c56638277cc05562b6dbf/msal-1.30.0.tar.gz"
    sha256 "b4bf00850092e465157d814efa24a18f788284c9a479491024d62903085ea2fb"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/2d/38/ad49272d0a5af95f7a0cb64a79bbd75c9c187f3b789385a143d8d537a5eb/msal_extensions-1.2.0.tar.gz"
    sha256 "6f41b320bfd2933d631a215c91ca0dd3e67d84bd1a2f50ce917d5874ec646bef"
  end

  resource "msgraph-core" do
    url "https://files.pythonhosted.org/packages/35/94/e2a15b577044b6b0e4b610a26fcd4439863d8d21bda419e0fd24580316cd/msgraph-core-0.2.2.tar.gz"
    sha256 "147324246788abe8ed7e05534cd9e4e0ec98b33b30e011693b8d014cebf97f63"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/f9/79/722ca999a3a09a63b35aac12ec27dfa8e5bb3a38b0f857f7a1a209a88836/multidict-6.0.5.tar.gz"
    sha256 "f7e301075edaf50500f0b341543c41194d8df3ae5caf4702f2095f3ca73dd8da"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "opensearch-py" do
    url "https://files.pythonhosted.org/packages/f1/1d/a5a965bf579b1bde4d216678f2a92db83509a2479a0e8449c320d1e76f8e/opensearch_py-2.6.0.tar.gz"
    sha256 "0b7c27e8ed84c03c99558406927b6161f186a72502ca6d0325413d8e5523ba96"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/ed/d3/c6c64067759e87af98cc668c1cc75171347d0f1577fab7ca3749134e3cd4/portalocker-2.10.1.tar.gz"
    sha256 "ef1bf844e878ab08aee7e40184156e1151f228f103aa5c6bd0724cc330960f8f"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/3e/fc/e9a65cd52c1330d8d23af6013651a0bc50b6d76bcbdf91fae7cd19c68f29/proto-plus-1.24.0.tar.gz"
    sha256 "30b72a5ecafe4406b0d339db35b56c4059064e69227b8c3bda7462397f966445"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/1b/61/0671db2ab2aee7c92d6c1b617c39b30a4cd973950118da56d77e7f397a9d/protobuf-5.27.3.tar.gz"
    sha256 "82460903e640f2b7e34ee81a947fdaad89de796d324bcbc38ff5430bcdead82c"
  end

  resource "publicsuffix2" do
    url "https://files.pythonhosted.org/packages/5a/04/1759906c4c5b67b2903f546de234a824d4028ef24eb0b1122daa43376c20/publicsuffix2-2.20191221.tar.gz"
    sha256 "00f8cc31aa8d0d5592a5ced19cccba7de428ebca985db26ac852d920ddd6fe7b"
  end

  resource "publicsuffixlist" do
    url "https://files.pythonhosted.org/packages/3f/8d/10e85166a5d84e160a7fddb11fa7b3fa0fffc11580cdc7ddc80663247e63/publicsuffixlist-1.0.2.20240810.tar.gz"
    sha256 "eb9557db21089ccc0296dd7be14e5e261fed5c0c53fdd337109c7c2c9196dd05"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/4a/a3/d2157f333900747f20984553aca98008b6dc843eb62f3a36030140ccec0d/pyasn1-0.6.0.tar.gz"
    sha256 "3a35ab2c4b5ef98e17dfdec8ab074046fbda76e281c5a706ccd82328cfc8f64c"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/f7/00/e7bd1dec10667e3f2be602686537969a7ac92b0a7c5165be2e5875dc3971/pyasn1_modules-0.4.0.tar.gz"
    sha256 "831dbcea1b177b28c9baddf4c6d1013c24c3accd14a1873fffaa6a2e905f17b6"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/fb/68/ce067f09fca4abeca8771fe667d89cc347d1e99da3e093112ac329c6020e/pyjwt-2.9.0.tar.gz"
    sha256 "7e1e5b56cc735432a7369cbfa0efe50fa113ebecdc04ae6922deba8b84582d0c"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/46/3a/31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842/pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/90/26/9f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738/pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/3f/51/64256d0dc72816a4fe3779449627c69ec8fee5a5625fd60ba048f53b3478/regex-2024.7.24.tar.gz"
    sha256 "9cfd009eed1a46b27c14039ad5bbc5e71b6367c5b2e6d5f5da0ea91600817506"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/cb/67/94c6730ee4c34505b14d94040e2f31edf144c230b6b49e971b4f25ff8fab/s3transfer-0.10.2.tar.gz"
    sha256 "0711534e9356d3cc692fdde846b4a1e4b0cb6519971860796e6bc4c7aea00ef6"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/5e/11/487b18cc768e2ae25a919f230417983c8d5afa1b6ee0abd8b6db0b89fa1d/setuptools-72.1.0.tar.gz"
    sha256 "8d243eff56d095e5817f796ede6ae32941278f542e0f941867cc05ae52b162ec"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/79/79/3ccb95bb4154952532f280f7a41979fbfb0fbbaee4d609810ecb01650afa/simplejson-3.19.2.tar.gz"
    sha256 "9eb442a2442ce417801c912df68e1f6ccfcd41577ae7274953ab3ad24ef7d82c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/58/83/6ba9844a41128c62e810fddddd72473201f3eacde02046066142a2d96cc5/tqdm-4.66.5.tar.gz"
    sha256 "e1020aef2e5096702d8a025ac7d16b1577279c9d63f8375b63083e9a5f0fcbad"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c8/93/65e479b023bbc46dab3e092bda6b0005424ea3217d711964ccdede3f9b1b/urllib3-1.26.19.tar.gz"
    sha256 "3e3d753a8618b86d7de333b4223005f68720bcd6a7d2bcb9fbd2229ec7c1e429"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/e0/ad/bedcdccbcbf91363fd425a948994f3340924145c2bc8ccb296f4a1e52c28/yarl-1.9.4.tar.gz"
    sha256 "566db86717cf8080b99b58b083b773a908ae40f06681e87e589a976faf8246bf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parsedmarc --version")

    touch testpath/"empty.xml"
    output = shell_output(bin/"parsedmarc empty.xml 2>&1")
    assert_match "Failed to parse empty.xml - Not a valid report", output
  end
end
