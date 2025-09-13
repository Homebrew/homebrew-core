class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://files.pythonhosted.org/packages/42/7f/fd22e1bda654356e572e524762d4ee473d32a2c506960201d413073e5579/certbot-5.0.0.tar.gz"
  sha256 "4e9e4680e812037b582cef7335570074390b455d24a3e09bcaa2fdc473dbcc0a"
  license "Apache-2.0"
  head "https://github.com/certbot/certbot.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "51c7be44a2beaa19a7e908ef9e009b837f4ca6c026dfeb7ff0c88a593f83fe3d"
    sha256 cellar: :any,                 arm64_sequoia: "5cae36553051941d1e6a7a764887ef88da69c4531b0b837b8b9d75aa4569a565"
    sha256 cellar: :any,                 arm64_sonoma:  "2e5c66da81c267db5fc100845162b57550d5bf0e6fa1ea64b7e700d65ea96516"
    sha256 cellar: :any,                 arm64_ventura: "6ac369299a583e5ca8239dd386f1fc3bfe406e2b4a8408ae26e6c7763be5cb3e"
    sha256 cellar: :any,                 sonoma:        "7fadd1eff7a3e1d8aaf7d28f4c3833f620e8ddcfff8431514340042163b37695"
    sha256 cellar: :any,                 ventura:       "f51a28c967dc129d81dedd0994c4b26aea6fcdde84560694efad4a39a221bfa0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42e99e475ac3b7fed01a47a2d65214ee3ec854bf8f76fed322ce84eb1edfd873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2033c4e6daea9e6441f6f82541047d8b5b45c53ff8e82efa0574ce09a83ad1d0"
  end

  depends_on "augeas"
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "acme" do
    url "https://files.pythonhosted.org/packages/9f/11/2a8767ea1bac25ca73d952ca1d8bd701a65c84057e4ead8bda82fb086d9c/acme-5.0.0.tar.gz"
    sha256 "b701b23e66d3c58352896a72caa13523d9f72b183a0ba1cde93e6713a450a391"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/85/2e/3e5079847e653b1f6dc647aa24549d68c6addb4c595cc0d902d1b19308ad/beautifulsoup4-4.13.5.tar.gz"
    sha256 "5e70131382930e7c3de33450a2f54a63d5e4b19386eab43a5b34d594268f3695"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/2c/36/de7e622fd7907faec3823eaee7299b55130f577a4ba609717a290e9f3897/boto3-1.40.25.tar.gz"
    sha256 "debfa4b2c67492d53629a52c999d71cddc31041a8b62ca1a8b1fb60fb0712ee1"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/1a/ba/7faa7e1061c2d2d60700815928ec0e5a7eeb83c5311126eccc6125e1797b/botocore-1.40.25.tar.gz"
    sha256 "41fd186018a48dc517a4312a8d3085d548cb3fb1f463972134140bf7ee55a397"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/6c/81/3747dad6b14fa2cf53fcf10548cf5aea6913e96fab41a3c198676f8948a5/cachetools-5.5.2.tar.gz"
    sha256 "1a661caa9175d26759571b2e19580f9d6393969e5dfca11fdb1f947a23e640d4"
  end

  resource "certbot-apache" do
    url "https://files.pythonhosted.org/packages/25/b0/6b9b6cc1e94d802ca361e7f0d64966dee85b4885ca344a14c407b201e62f/certbot_apache-5.0.0.tar.gz"
    sha256 "c438b6cb4fda2fef5868b7111d130a96233ccccf5538c292e642a04a47c9dbb6"
  end

  resource "certbot-dns-cloudflare" do
    url "https://files.pythonhosted.org/packages/a9/96/6afc38a2f491b779f59cc547cd797dc2b6e0a2bca494a202732dc0029d20/certbot_dns_cloudflare-5.0.0.tar.gz"
    sha256 "84c01b06b2b0055f1b551eb3c0bc82c0a275063207cf9ea7ddc1b67129c728a4"
  end

  resource "certbot-dns-digitalocean" do
    url "https://files.pythonhosted.org/packages/32/10/5d1d242cd8e8c86d6ec05a4abcb3b6e0a44c09cd38d5a02f4ceb29e94594/certbot_dns_digitalocean-5.0.0.tar.gz"
    sha256 "0b01118809700a4cce84e98f0410ff088d0e5bf01c0c46e6b0e49caaad9ca9c4"
  end

  resource "certbot-dns-dnsimple" do
    url "https://files.pythonhosted.org/packages/d4/d5/6d9249cf92575e6295032ca7adc46dd6c9ddebf5e6d545b79b4ec95c6037/certbot_dns_dnsimple-5.0.0.tar.gz"
    sha256 "ecb0117a7034dc8a101fc2da16857db79f92903b671d929ba064c0b6f0730245"
  end

  resource "certbot-dns-dnsmadeeasy" do
    url "https://files.pythonhosted.org/packages/27/44/47d1533ef6f8352dc2a43fb132f42dd58975ab5ed8e2b7de3ccaed95c9f3/certbot_dns_dnsmadeeasy-5.0.0.tar.gz"
    sha256 "cc20990581bfdf280096f5a5d75ed658873ad78203107624647cca8ccb1c0c84"
  end

  resource "certbot-dns-gehirn" do
    url "https://files.pythonhosted.org/packages/8e/00/aea9a5ccf45f3a918c90a4abd8a584fd3bf0d28b0436f66a6bca3931139d/certbot_dns_gehirn-5.0.0.tar.gz"
    sha256 "6fbf877224c5cdd572bd7ccbb6efc8fb70472ed80735480583d700bd73830ef4"
  end

  resource "certbot-dns-google" do
    url "https://files.pythonhosted.org/packages/44/bf/ac0effe4f211442d6ad60d2506606c44f7724e8e03c11238e1dfbe044197/certbot_dns_google-5.0.0.tar.gz"
    sha256 "fc2d5bae2ca3571b14d2a34addad24cc7e0f338fb665bc3d59da76aaf121dcc1"
  end

  resource "certbot-dns-linode" do
    url "https://files.pythonhosted.org/packages/79/3f/7476be1b72f62941f94e6893be3125ebb4f9690c8f14d87b18ebcef75a67/certbot_dns_linode-5.0.0.tar.gz"
    sha256 "7f673ac5cecbeeee0b81ea26945a896df5fd3004231fb3db2ee261fecfbbe34c"
  end

  resource "certbot-dns-luadns" do
    url "https://files.pythonhosted.org/packages/55/c5/de09df4aa1164b6dfc2e2bcda6feaeb95fa21618e03c3ffba4cad8a38f8d/certbot_dns_luadns-5.0.0.tar.gz"
    sha256 "6685ab3bfc7d9c03ea5d87f77652ee75e1eb890faee40c2ece44b3f490eab2a1"
  end

  resource "certbot-dns-nsone" do
    url "https://files.pythonhosted.org/packages/1b/f0/3d14f8bcd845fdff228030ad34f09400256ccd464cb9a875f4282dd380b4/certbot_dns_nsone-5.0.0.tar.gz"
    sha256 "bc21f5e6ef22a1c2094a2fc2e33701cad562ae69a3b360a1c657640572ede14c"
  end

  resource "certbot-dns-ovh" do
    url "https://files.pythonhosted.org/packages/d3/2f/9ac38a3be9f2ba3d82f39640bc464bf6d8a9a4790f604222c762101be230/certbot_dns_ovh-5.0.0.tar.gz"
    sha256 "2ec86f7bdd914d8be4105132a59f1240b25ac466a103c25b85411f62d9b90e57"
  end

  resource "certbot-dns-rfc2136" do
    url "https://files.pythonhosted.org/packages/62/89/89e9102c1d0a586781dbc8ec84fe09604aae4702b0fc10bbd114044eee2d/certbot_dns_rfc2136-5.0.0.tar.gz"
    sha256 "c01dab063fc49a1012ff224240f5dca0bbe59c70ef6a0eeafe55dab6779ada85"
  end

  resource "certbot-dns-route53" do
    url "https://files.pythonhosted.org/packages/b0/a6/bd89f28802dfd5af8a5418ef6b1f8026fe68231003625706c69568e0f388/certbot_dns_route53-5.0.0.tar.gz"
    sha256 "b89653b7410f783f945cd83206fa9ffbe87fa3c4b491e12fb921c239e39b1bfa"
  end

  resource "certbot-dns-sakuracloud" do
    url "https://files.pythonhosted.org/packages/29/04/8c80c317c04c60561a8155779f61f9306b6cb971e21e428ad2e41354388e/certbot_dns_sakuracloud-5.0.0.tar.gz"
    sha256 "291af70379318a7989a2ab57e30a03ef7f6ab46fb85d6c153c7b63e81a737f20"
  end

  resource "certbot-nginx" do
    url "https://files.pythonhosted.org/packages/50/0f/b4e296e2b38a227f57347b3ebe6742271aec72e0e4728ce1b8266b6302c1/certbot_nginx-5.0.0.tar.gz"
    sha256 "c8e4b86d2537a5d9de5801a6e3a8cf17fa4f12777479192d0e2978cbc6b18305"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "cloudflare" do
    url "https://files.pythonhosted.org/packages/9b/8f/d3a435435c42d4b05ce2274432265c5890f91f6047e6dab52e50c811a4ea/cloudflare-2.19.4.tar.gz"
    sha256 "3b6000a01a237c23bccfdf6d20256ea5111ec74a826ae9e74f9f0e5bb5b2383f"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/85/4d/6c9ef746dfcc2a32e26f3860bb4a011c008c392b83eabdfb598d1a8bbe5d/configargparse-1.7.1.tar.gz"
    sha256 "79c2ddae836a1e5914b71d58e4b9adbd9f7779d4e6351a637b7d2d9b6c46d3d9"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "dns-lexicon" do
    url "https://files.pythonhosted.org/packages/60/58/055f9552cafeeac094a5e0334fe0eaf4cbf8e1485cc545a26c079ca632f1/dns_lexicon-3.21.1.tar.gz"
    sha256 "7cd19f692b384fe5eaa47cce334d24c78ae2eba1d2fb24d2b8a05e04fe294497"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/b5/4a/263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829/dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/40/bb/0ab3e58d22305b6f5440629d20683af28959bf793d98d11950e305c1c326/filelock-3.19.1.tar.gz"
    sha256 "66eda1888b0171c998b35be2bcc0f6d75c388a7ce20c3f3f37aa8e96c2dddf58"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/dc/21/e9d043e88222317afdbdb567165fdbc3b0aad90064c7e0c9eb0ad9955ad8/google_api_core-2.25.1.tar.gz"
    sha256 "d2aaa0b13c78c61cb3f4282c464c046e45fbd75755683c9c525e6e8f7ed0a5e8"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/c2/96/5561a5d7e37781c880ca90975a70d61940ec1648b2b12e991311a9e39f83/google_api_python_client-2.181.0.tar.gz"
    sha256 "d7060962a274a16a2c6f8fb4b1569324dbff11bfbca8eb050b88ead1dd32261c"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/9e/9b/e92ef23b84fa10a64ce4831390b7a4c2e53c0132568d99d4ae61d04c8855/google_auth-2.40.3.tar.gz"
    sha256 "500c3a29adedeb36ea9cf24b8d10858e152f2412e3ca37829b3fa18e33d63b77"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/56/be/217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacef/google-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/39/24/33db22342cf4a2ea27c9955e6713140fedd51e8b141b5ce5260897020f1a/googleapis_common_protos-1.70.0.tar.gz"
    sha256 "0e1b44e0ea153e6594f9f394fef15193a68aaaea2d843f83e2742717ca753257"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/5b/75/1d10a90b3411f707c10c226fa918cf4f5e0578113caa223369130f702b6b/httplib2-0.30.0.tar.gz"
    sha256 "d5b23c11fcf8e57e00ff91b7008656af0f6242c8886fd97065c97509e4e548c5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "josepy" do
    url "https://files.pythonhosted.org/packages/9d/19/4ebe24c42c341c5868dff072b78d503fc1b0725d88ea619d2db68f5624a9/josepy-2.1.0.tar.gz"
    sha256 "9beafbaa107ec7128e6c21d86b2bc2aea2f590158e50aca972dca3753046091f"
  end

  resource "jsonlines" do
    url "https://files.pythonhosted.org/packages/35/87/bcda8e46c88d0e34cad2f09ee2d0c7f5957bccdb9791b0b934ec84d84be4/jsonlines-4.0.0.tar.gz"
    sha256 "0c6d2c09117550c089995247f605ae4cf77dd1533041d366351f6f298822ea74"
  end

  resource "jsonpickle" do
    url "https://files.pythonhosted.org/packages/e4/a6/d07afcfdef402900229bcca795f80506b207af13a838d4d99ad45abf530c/jsonpickle-4.1.1.tar.gz"
    sha256 "f86e18f13e2b96c1c1eede0b7b90095bbb61d99fedc14813c44dc2f361dbbae1"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/f4/ac/87285f15f7cce6d4a008f33f1757fb5a13611ea8914eb58c3d0d26243468/proto_plus-1.26.1.tar.gz"
    sha256 "21a515a4c4c0088a773899e23c7bbade3d18f9c66c73edd4c7ee3816bc96a012"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/c0/df/fb4a8eeea482eca989b51cffd274aac2ee24e825f0bf3cbce5281fa1567b/protobuf-6.32.0.tar.gz"
    sha256 "a81439049127067fc49ec1d36e25c6ee1d1a2b7be930675f919258d03c04e7d2"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/04/8c/cd89ad05804f8e3c17dea8f178c3f40eeab5694c30e0c9f5bcd49f576fc3/pyopenssl-25.1.0.tar.gz"
    sha256 "8d031884482e0c67ee92bf9a4d8cceb08d92aba7136432ffb0703c5280fc205b"
  end

  resource "pyotp" do
    url "https://files.pythonhosted.org/packages/f3/b2/1d5994ba2acde054a443bd5e2d384175449c7d2b6d1a0614dbca3a63abfc/pyotp-2.9.0.tar.gz"
    sha256 "346b6642e0dbdde3b4ff5a930b664ca82abfa116356ed48cc42c7d6590d36f63"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/bb/22/f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60f/pyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
  end

  resource "pyrfc3339" do
    url "https://files.pythonhosted.org/packages/b4/7f/3c194647ecb80ada6937c38a162ab3edba85a8b6a58fa2919405f4de2509/pyrfc3339-2.1.0.tar.gz"
    sha256 "c569a9714faf115cdb20b51e830e798c1f4de8dabb07f6ff25d221b5d09d8d7f"
  end

  resource "python-augeas" do
    url "https://files.pythonhosted.org/packages/44/f6/e09619a5a4393fe061e24a6f129c3e1fbb9f25f774bfc2f5ae82ba5e24d3/python-augeas-1.2.0.tar.gz"
    sha256 "d2334710e12bdec8b6633a7c2b72df4ca24ab79094a3c9e699494fdb62054a10"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-digitalocean" do
    url "https://files.pythonhosted.org/packages/f8/f7/43cb73fb393c4c0da36294b6040c7424bc904042d55c1b37c73ecc9e7714/python-digitalocean-1.17.0.tar.gz"
    sha256 "107854fde1aafa21774e8053cf253b04173613c94531f75d5a039ad770562b24"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/72/97/bf44e6c6bd8ddbb99943baf7ba8b1a8485bcd2fe0e55e5708d7fee4ff1ae/requests_file-2.1.0.tar.gz"
    sha256 "0f549a3f3b0699415ac04d167e9cb39bccfb730cb832b4d20be3d9867356e658"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/da/8a/22b7beea3ee0d44b1916c0c1cb0ee3af23b700b6da9f04991899d0c555d4/rsa-4.9.1.tar.gz"
    sha256 "e7bdbfdb5497da4c07dfd35530e1a902659db6ff241e39d9953cad06ebd0ae75"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/6d/05/d52bf1e65044b4e5e27d4e63e8d1579dbdec54fce685908ae09bc3720030/s3transfer-0.13.1.tar.gz"
    sha256 "c3fdba22ba1bd367922f27ec8032d6a1cf5f10c934fb5d68cf60fd5a23d936cf"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/6d/e6/21ccce3262dd4889aa3332e5a119a3491a95e8f60939870a3a035aabac0d/soupsieve-2.8.tar.gz"
    sha256 "e2dd4a40a628cb5f28f6d4b0db8800b8f581b65bb380b97de22ba5ca8d72572f"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/97/78/182641ea38e3cfd56e9c7b3c0d48a53d432eea755003aa544af96403d4ac/tldextract-5.3.0.tar.gz"
    sha256 "b3d2b70a1594a0ecfa6967d57251527d58e00bb5a91a74387baa0d87a0678609"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/98/60/f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56/uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    if build.head?
      head_packages = %w[
        acme certbot certbot-apache certbot-nginx
        certbot-dns-cloudflare certbot-dns-digitalocean certbot-dns-dnsimple
        certbot-dns-dnsmadeeasy certbot-dns-gehirn certbot-dns-google
        certbot-dns-linode certbot-dns-luadns certbot-dns-nsone certbot-dns-ovh
        certbot-dns-rfc2136 certbot-dns-route53 certbot-dns-sakuracloud
      ]
      venv = virtualenv_create(libexec, "python3.13")
      venv.pip_install resources.reject { |r| head_packages.include? r.name }
      venv.pip_install_and_link head_packages.map { |pkg| buildpath/pkg }
      pkgshare.install buildpath/"certbot/examples"
    else
      virtualenv_install_with_resources
      pkgshare.install buildpath/"examples"
    end
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/certbot --version 2>&1")
    # This throws a bad exit code but we can check it actually is failing
    # for the right reasons by asserting. --version never fails even if
    # resources are missing or outdated/too new/etc.
    assert_match "Either run as root", shell_output("#{bin}/certbot 2>&1", 1)
  end
end
