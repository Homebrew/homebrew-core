class Parsedmarc < Formula
  include Language::Python::Virtualenv

  desc "DMARC report analyzer and visualizer"
  homepage "https://domainaware.github.io/parsedmarc/"
  url "https://files.pythonhosted.org/packages/19/ae/ab3ca937e2ab57967081b0c23b06dfe9422e8c5cd435ea8368e0b12e64f4/parsedmarc-9.3.0.tar.gz"
  sha256 "f50d7cd50963d7062e1895ac72dafc1054e9151f0348755b6df3aff12500f83e"
  license "Apache-2.0"
  head "https://github.com/domainaware/parsedmarc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c219d9e1c66b02f496c6fbf2f6d7cec4ad2941a62a0f560819e4abea82165ebc"
    sha256 cellar: :any,                 arm64_sequoia: "587762cf2e01bbd3cb6c41cdcdcd09cc19116d5b92cf0c0abf14e537da58febe"
    sha256 cellar: :any,                 arm64_sonoma:  "f7379486a49eb4cfda697328ad0320d8f065ef76993f1fe5bf8561bb93e53db8"
    sha256 cellar: :any,                 sonoma:        "b03e562acefc75bc1219724f9f1d97ecd4bfc478dc706182a7094eb7d6782e6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "898670c37a7075f63fef4432e7f8f11433d71e378304644464c06350d5488449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dfac45d4ff3e3a44936e8ea5db7956eea35b2ce463e133492b3a9585d367d40"
  end

  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13" # `mailsuite` refuses to build on 3.14, https://github.com/seanthegeek/mailsuite/issues/15

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/50/42/32cf8e7704ceb4481406eb87161349abb46a57fee3f008ba9cb610968646/aiohttp-3.13.3.tar.gz"
    sha256 "a949eee43d3782f2daae4f4a2819b2cb9b0c5d3b7f7a927067cc84dafdbb9f88"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/34/83/bbde3faa84ddcb8eb0eca4b3ffb3221252281db4ce351300fe248c5c70b1/azure_core-1.39.0.tar.gz"
    sha256 "8a90a562998dd44ce84597590fff6249701b98c0e8797c95fcdd695b54c35d74"
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
    url "https://files.pythonhosted.org/packages/e4/8b/d00575be514744ca4839e7d85bf4a8a3c7b6b4574433291e58d14c68ae09/boto3-1.42.73.tar.gz"
    sha256 "d37b58d6cd452ca808dd6823ae19ca65b6244096c5125ef9052988b337298bae"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/28/23/0c88ca116ef63b1ae77c901cd5d2095d22a8dbde9e80df74545db4a061b4/botocore-1.42.73.tar.gz"
    sha256 "575858641e4949aaf2af1ced145b8524529edf006d075877af6b82ff96ad854c"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/7b/60/e3bec1881450851b087e301bedc3daa9377a4d45f1c26aa90b0b235e38aa/charset_normalizer-3.4.6.tar.gz"
    sha256 "1ae6b62897110aa7c79ea2f5dd38d1abca6db663687c0b1ad9aed6f6bae3d9d6"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/3d/2c/668dfb8c073a5dde3efb80fa382de1502e3b14002fd386a8c1b0b49e92a9/dateparser-1.3.0.tar.gz"
    sha256 "5bccf5d1ec6785e5be71cc7ec80f014575a09b4923e762f850e57443bddbf1a5"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
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
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "geoip2" do
    url "https://files.pythonhosted.org/packages/18/70/3d9e87289f79713aaf0fea9df4aa8e68776640fe59beb6299bb214610cfd/geoip2-5.2.0.tar.gz"
    sha256 "6c9ded1953f8eb16043ed0a8ea20e6e9524ea7b65eb745724e12490aca44ef00"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/22/98/586ec94553b569080caef635f98a3723db36a38eac0e3d7eb3ea9d2e4b9a/google_api_core-2.30.0.tar.gz"
    sha256 "02edfa9fab31e17fc0befb5f161b3bf93c9096d99aed584625f38065c511ad9b"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/90/f4/e14b6815d3b1885328dd209676a3a4c704882743ac94e18ef0093894f5c8/google_api_python_client-2.193.0.tar.gz"
    sha256 "8f88d16e89d11341e0a8b199cafde0fb7e6b44260dffb88d451577cbd1bb5d33"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/ea/80/6a696a07d3d3b0a92488933532f03dbefa4a24ab80fb231395b9a2a1be77/google_auth-2.49.1.tar.gz"
    sha256 "16d40da1c3c5a0533f57d268fe72e0ebb0ae1cc3b567024122651c045d879b64"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/d5/ad/c1f2b1175096a8d04cf202ad5ea6065f108d26be6fc7215876bde4a7981d/google_auth_httplib2-0.3.0.tar.gz"
    sha256 "177898a0175252480d5ed916aeea183c2df87c1f9c26705d74ae6b951c268b0b"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/ac/b4/1b19567e4c567b796f5c593d89895f3cfae5a38e04f27c6af87618fd0942/google_auth_oauthlib-1.3.0.tar.gz"
    sha256 "cd39e807ac7229d6b8b9c1e297321d36fcc8a9e4857dff4301870985df51a528"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/99/96/a0205167fa0154f4a542fd6925bdc63d039d88dab3588b875078107e6f06/googleapis_common_protos-1.73.0.tar.gz"
    sha256 "778d07cd4fbeff84c6f7c72102f0daf98fa2bfd3fa8bea426edc545588da0b5a"
  end

  resource "html2text" do
    url "https://files.pythonhosted.org/packages/f8/27/e158d86ba1e82967cc2f790b0cb02030d4a8bef58e0c79a8590e9678107f/html2text-2025.4.15.tar.gz"
    sha256 "948a645f8f0bc3abe7fd587019a2197a12436cd73d0d4908af95bfc8da337588"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/c1/1f/e86365613582c027dda5ddb64e1010e57a3d53e99ab8a72093fa13d565ec/httplib2-0.31.2.tar.gz"
    sha256 "385e0869d7397484f4eab426197a4c020b606edd43372492337c0b4010ae5d24"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
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

  resource "kafka-python-ng" do
    url "https://files.pythonhosted.org/packages/ce/04/1d65bdf3f0103a08710e226b851de4b357ac702f1cadabf6128bab7518a7/kafka_python_ng-2.2.3.tar.gz"
    sha256 "f79f28e10ade9b5a9860b2ec15b7cc8dc510d5702f5a399430478cff5f93a05a"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "mail-parser" do
    url "https://files.pythonhosted.org/packages/07/57/20176377e709ea57481f559159f00b366d143cc0a8cf7271b7f0e9c9c7ff/mail_parser-4.1.4.tar.gz"
    sha256 "b65abad3beee3ffb75c7851bc373412c69e1a22561d49dd7142ee7fb4321ed82"
  end

  resource "mailsuite" do
    url "https://files.pythonhosted.org/packages/67/46/6a77b4b3282e6a76ee07f3c1908934800f80d53d0b6e47f0c00c821e3e68/mailsuite-1.11.2.tar.gz"
    sha256 "8a570e1f6ee554a861ff114efdd916664c2dc7ac0f62b293591de7d71aa851d9"
  end

  resource "maxminddb" do
    url "https://files.pythonhosted.org/packages/31/83/bcd7f2e7dfcf601258a4eab92155816218e8f8adf6608d5f7d39da7ba863/maxminddb-3.1.1.tar.gz"
    sha256 "b19a938c481518f19a2c534ffdcb3bc59582f0fbbdcf9f81ac9adf912a0af686"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/3c/aa/5a646093ac218e4a329391d5a31e5092a89db7d2ef1637a90b82cd0b6f94/msal-1.35.1.tar.gz"
    sha256 "70cac18ab80a053bff86219ba64cfe3da1f307c74b009e2da57ef040eb1b5656"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/01/99/5d239b6156eddf761a636bded1118414d161bd6b7b37a9335549ed159396/msal_extensions-1.3.1.tar.gz"
    sha256 "c5b0fd10f65ef62b5f1d62f4251d51cbcaf003fcedae8c91b040a488614be1a4"
  end

  resource "msgraph-core" do
    url "https://files.pythonhosted.org/packages/35/94/e2a15b577044b6b0e4b610a26fcd4439863d8d21bda419e0fd24580316cd/msgraph-core-0.2.2.tar.gz"
    sha256 "147324246788abe8ed7e05534cd9e4e0ec98b33b30e011693b8d014cebf97f63"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "opensearch-py" do
    url "https://files.pythonhosted.org/packages/b8/58/ecec7f855aae7bcfb08f570088c6cb993f68c361a0727abab35dbf021acb/opensearch_py-3.0.0.tar.gz"
    sha256 "ebb38f303f8a3f794db816196315bcddad880be0dc75094e3334bc271db2ed39"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/9e/da/e9fc233cf63743258bff22b3dfa7ea5baef7b5bc324af47a0ad89b8ffc6f/propcache-0.4.1.tar.gz"
    sha256 "f48107a8c637e80362555f37ecf49abe20370e557cc4ab374f04ec4423c97c3d"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/3a/02/8832cde80e7380c600fbf55090b6ab7b62bd6825dbedde6d6657c15a1f8e/proto_plus-1.27.1.tar.gz"
    sha256 "912a7460446625b792f6448bade9e55cd4e41e6ac10e27009ef71a7f317fa147"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/66/70/e908e9c5e52ef7c3a6c7902c9dfbb34c7e29c25d2f81ade3856445fd5c94/protobuf-6.33.6.tar.gz"
    sha256 "a6768d25248312c297558af96a9f9c929e8c4cee0659cb07e780731095f38135"
  end

  resource "publicsuffix2" do
    url "https://files.pythonhosted.org/packages/5a/04/1759906c4c5b67b2903f546de234a824d4028ef24eb0b1122daa43376c20/publicsuffix2-2.20191221.tar.gz"
    sha256 "00f8cc31aa8d0d5592a5ced19cccba7de428ebca985db26ac852d920ddd6fe7b"
  end

  resource "publicsuffixlist" do
    url "https://files.pythonhosted.org/packages/d4/eb/9a6d6e157a69095d6d337473c9f2de3821ef523da0e7422ee69da9d807ff/publicsuffixlist-1.0.2.20260318.tar.gz"
    sha256 "47eaed18c8029de89513454f68bc46e0b7f6e1eae54220ea1ffcf1623274d7c3"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/5c/5f/6583902b6f79b399c9c40674ac384fd9cd77805f9e6205075f828ef11fb2/pyasn1-0.6.3.tar.gz"
    sha256 "697a8ecd6d98891189184ca1fa05d1bb00e2f84b5977c481452050549c8a72cf"
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
    url "https://files.pythonhosted.org/packages/c2/27/a3b6e5bf6ff856d2509292e95c8f57f0df7017cf5394921fc4e4ef40308a/pyjwt-2.12.1.tar.gz"
    sha256 "c74a7a2adf861c04d002db713dd85f84beb242228e671280bf709d765b03672b"
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
    url "https://files.pythonhosted.org/packages/56/db/b8721d71d945e6a8ac63c0fc900b2067181dbb50805958d4d4661cf7d277/pytz-2026.1.post1.tar.gz"
    sha256 "3378dde6a0c3d26719182142c56e60c7f9af7e968076f31aae569d72a0358ee1"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8b/71/41455aa99a5a5ac1eaf311f5d8efd9ce6433c03ac1e0962de163350d0d97/regex-2026.2.28.tar.gz"
    sha256 "a729e47d418ea11d03469f321aaf67cdee8954cde3ff2cf8403ab87951ad10f2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/05/04/74127fc843314818edfa81b5540e26dd537353b123a4edc563109d8f17dd/s3transfer-0.16.0.tar.gz"
    sha256 "8e990f13268025792229cd52fa10cb7163744bf56e719e0b9cb925ab79abf920"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/09/a9/6ba95a270c6f1fbcd8dac228323f2777d886cb206987444e4bce66338dd4/tqdm-4.67.3.tar.gz"
    sha256 "7d825f03f89244ef73f1d4ce193cb1774a8179fd96f31d7e1dcde62092b960bb"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/8b/2e/c14812d3d4d9cd1773c6be938f89e5735a1f11a9f184ac3639b93cef35d5/tzlocal-5.3.1.tar.gz"
    sha256 "cceffc7edecefea1f595541dbd6e990cb1ea3d19bf01b2809f362a03dd7921fd"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/98/60/f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56/uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e4/e8/6ff5e6bc22095cfc59b6ea711b687e2b7ed4bdb373f7eeec370a97d7392f/urllib3-1.26.20.tar.gz"
    sha256 "40c2dc0c681e47eb8f90e7e27bf6ff7df2e677421fd46756da1161c39ca70d32"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/19/70/80f3b7c10d2630aa66414bf23d210386700aa390547278c789afa994fd7e/xmltodict-1.0.4.tar.gz"
    sha256 "6d94c9f834dd9e44514162799d344d815a3a4faec913717a9ecbfa5be1bb8e61"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/23/6e/beb1beec874a72f23815c1434518bfc4ed2175065173fb138c3705f658d4/yarl-1.23.0.tar.gz"
    sha256 "53b1ea6ca88ebd4420379c330aea57e258408dd0df9af0992e5de2078dc9f5d5"
  end

  def install
    venv = virtualenv_install_with_resources

    # Workaround if `numpy` is installed based on upstream fix
    # Ref: https://github.com/elastic/elasticsearch-py/commit/aed94d2af193238221f7c247a3f6114084c92992
    inreplace venv.site_packages/"elasticsearch/serializer.py", /\n *np\.float_,$/, ""
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parsedmarc --version")

    touch testpath/"empty.xml"
    output = shell_output("#{bin}/parsedmarc empty.xml 2>&1")
    assert_match "Failed to parse empty.xml - Not a valid report", output
  end
end
