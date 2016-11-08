class CharmTools < Formula
  include Language::Python::Virtualenv

  desc "Tools for authoring and maintaining juju charms"
  homepage "https://github.com/juju/charm-tools"
  url "https://github.com/juju/charm-tools/releases/download/v2.1.2/charm-tools-2.1.2.tar.gz"
  sha256 "81ec4363df3b79556260ee51690227ea02ef288ebbfdd73a0261ae2177ad0002"
  revision 1

  bottle do
    cellar :any
    sha256 "f7fee0bca5d96e591f44906d9aaac41f9a34cb481e27ddb5e05581e1b467e43d" => :sierra
    sha256 "2c405203fffc1bf829d456f443fc48a655fc6ec7e9813eb67438c18d6f03acf1" => :el_capitan
    sha256 "ead9927592752ba74d0535db1b68b97ddafb314da2fb78693b4a81282d21365f" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"
  depends_on :hg
  depends_on "charm"
  depends_on "openssl@1.1"

  # Additionally include ndg-httpsclient for requests[security]

  resource "Cheetah" do
    url "https://files.pythonhosted.org/packages/cd/b0/c2d700252fc251e91c08639ff41a8a5203b627f4e0a2ae18a6b662ab32ea/Cheetah-2.4.4.tar.gz"
    sha256 "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550"
  end

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/d4/32/642bd580c577af37b00a1eb59b0eaa996f2d11dfe394f3dd0c7a8a2de81a/Markdown-2.6.7.tar.gz"
    sha256 "daebf24846efa7ff269cfde8c41a48bb2303920c7b2c7c5e04fa82e6282d05c0"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/75/5e/b84feba55e20f8da46ead76f14a3943c8cb722d40360702b2365b91dec00/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "argparse" do
    url "https://files.pythonhosted.org/packages/18/dd/e617cfc3f6210ae183374cd9f6a26b20514bbb5a792af97949c5aacddf0f/argparse-1.4.0.tar.gz"
    sha256 "62b089a55be1d8949cd2bc7e0df0bddb9e028faefc8c32038cc84862aefdd6e4"
  end

  resource "blessings" do
    url "https://files.pythonhosted.org/packages/af/4a/61acd1c6c29662d3fcbcaee5ba95c20b1d315c5a33534732b6d81e0dc8e8/blessings-1.6.tar.gz"
    sha256 "edc5713061f10966048bf6b40d9a514b381e0ba849c64e034c4ef6c1847d3007"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/0a/f3/686af8873b70028fccf67b15c78fd4e4667a3da995007afc71e786d61b0a/cffi-1.8.3.tar.gz"
    sha256 "c321bd46faa7847261b89c0469569530cad5a41976bb6dba8202c0159f476568"
  end

  resource "colander" do
    url "https://files.pythonhosted.org/packages/62/23/14a8cf54ce7d521680a29061e02133885016ae53bdccd132662c53382a4e/colander-1.3.1.tar.gz"
    sha256 "48bdbb5e8f50fcf2f05aab6bb2c0ab58d6ec7eed81a72b7d0272744fe72fafc2"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/6c/c5/7fc1f8384443abd2d71631ead026eb59863a58cad0149b94b89f08c8002f/cryptography-1.5.3.tar.gz"
    sha256 "cf82ddac919b587f5e44247579b433224cc2e03332d2ea4d89aa70d7e6b64ae5"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "functools32" do
    url "https://files.pythonhosted.org/packages/c5/60/6ac26ad05857c601308d8fb9e87fa36d0ebf889423f47c3502ef034365db/functools32-3.2.3-2.tar.gz"
    sha256 "f6253dfbe0538ad2e387bd8fdfd9293c925d63553f5813c4e587745416501e6d"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/ff/a9/5751cdf17a70ea89f6dde23ceb1705bfb638fd8cee00f845308bf8d26397/httplib2-0.9.2.tar.gz"
    sha256 "c3aba1c9539711551f4d83e857b316b5134a1c4ddce98a875b7027be7dd6d988"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/fb/84/8c27516fbaa8147acd2e431086b473c453c428e24e8fb99a1d89ce381851/idna-2.1.tar.gz"
    sha256 "ed36f281aebf3cd0797f163bb165d84c31507cedd15928b095b1675e2d04c676"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/bb/26/3b64955ff73f9e3155079b9ed31812afdfa5333b5c76387454d651ef593a/ipaddress-1.0.17.tar.gz"
    sha256 "3a21c5a15f433710aaa26f1ae174b615973a25182006ae7f9c26de151cd51716"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/c0/75/c9209ee4d1b5975eb8c2cba4428bde6b61bd55664a98290dd015cdb18e98/iso8601-0.1.11.tar.gz"
    sha256 "e8fb52f78880ae063336c94eb5b87b181e6a0cc33a6c008511bac9a6e980ef30"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/58/0d/c816f5ea5adaf1293a1d81d32e4cdfdaf8496973aa5049786d7fdb14e7e7/jsonschema-2.5.1.tar.gz"
    sha256 "36673ac378feed3daa5956276a829699056523d7961027911f064b52255ead41"
  end

  resource "jujubundlelib" do
    url "https://files.pythonhosted.org/packages/03/0b/9bb2296c3a9d5262c2abffddbe7ff47efc60db0fe49ad2a1ad516ad4fb8c/jujubundlelib-0.5.2.tar.gz"
    sha256 "8baa49aa4f714b4b9dc268e38dddf9dde3c372d90c59ab332222b0217fc0bec3"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/2b/b2/ccc3d598524a179b9ebbb9887885c8e1e428bd21b892a1f83cf774b1378c/keyring-10.0.2.tar.gz"
    sha256 "91c31fd805b3ce6343406c7c51437f7505f3e9abb6e14ccac8242ea1fc912d77"
  end

  resource "launchpadlib" do
    url "https://files.pythonhosted.org/packages/6e/db/150e8325ee03c6eb88e14e02efbd83c90fcfec23d615d02fccb5a6349eb0/launchpadlib-1.10.4.tar.gz"
    sha256 "d24ede127d4fc56a1557ec115e6fc9b64756e0d60c4fd0ee13ca448d593d3f0e"
  end

  resource "lazr.authentication" do
    url "https://files.pythonhosted.org/packages/90/da/525645ece5afd54a22a7f95a194b84ada61cc3cbbc0eb98ac0af6e43367b/lazr.authentication-0.1.3.tar.gz"
    sha256 "23b66ba6a135168e22e0142f9c18b5fa3c1ed37b08c6ef71c8acd7adb244fa11"
  end

  resource "lazr.restfulclient" do
    url "https://files.pythonhosted.org/packages/0a/ad/30ac2d266a6890646d2a180d720aea58da382390e80e9252ab8c759ca0de/lazr.restfulclient-0.13.1.tar.gz"
    sha256 "0b678412b61e3f9722525c07f7bbfd3a15173c3869d3dab30f2671c9bead7f2a"
  end

  resource "lazr.uri" do
    url "https://files.pythonhosted.org/packages/ea/bf/71ad2f5eaf7885d36e3cbd0a87cf3812ad043cf99c9fa6cc6ab4c94ee862/lazr.uri-1.0.3.tar.gz"
    sha256 "5c620b5993c8c6a73084176bfc51de64972b8373620476ed841931a49752dc8b"
  end

  resource "libcharmstore" do
    url "https://files.pythonhosted.org/packages/54/a3/823a444fd6df0c670940ab089aa466621a58d575349e3d8d84b8ea02dd83/libcharmstore-0.0.3.tar.gz"
    sha256 "1beb37a662e9e0d60bbebc65ec360f2f8333316706c6ae0c59d437a8a8d76ecc"
  end

  resource "ndg-httpsclient" do
    url "https://files.pythonhosted.org/packages/a2/a7/ad1c1c48e35dc7545dab1a9c5513f49d5fa3b5015627200d2be27576c2a0/ndg_httpsclient-0.4.2.tar.gz"
    sha256 "580987ef194334c50389e0d7de885fccf15605c13c6eecaabd8d6c43768eb8ac"
  end

  resource "oauth" do
    url "https://files.pythonhosted.org/packages/e2/10/d7d6ae26ef7686109a10b3e88d345c4ec6686d07850f4ef7baefb7eb61e1/oauth-1.0.1.tar.gz"
    sha256 "e769819ff0b0c043d020246ce1defcaadd65b9c21d244468a45a7f06cb88af5d"
  end

  resource "otherstuf" do
    url "https://files.pythonhosted.org/packages/4f/b5/fe92e1d92610449f001e04dd9bf7dc13b8e99e5ef8859d2da61a99fc8445/otherstuf-1.1.0.tar.gz"
    sha256 "7722980c3b58845645da2acc838f49a1998c8a6bdbdbb1ba30bcde0b085c4f4c"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/6b/4e/971b8c917456a2ec9666311f7e695493002a64022397cd668150b5efd2a8/paramiko-2.0.2.tar.gz"
    sha256 "411bf90fa22b078a923ff19ef9772c1115a0953702db93549a2848acefd141dc"
  end

  resource "parse" do
    url "https://files.pythonhosted.org/packages/c3/e3/c2ca7f10c481b84ba7bf8c35c595ee4825d828fce7838fffc57f0ea0acc9/parse-1.6.6.tar.gz"
    sha256 "71435aaac494e08cec76de646de2aab8392c114e56fe3f81c565ecc7eb886178"
  end

  resource "path.py" do
    url "https://files.pythonhosted.org/packages/85/80/d13c3e5058c14f0bf3c19e9596a70f1e805fcda8510531f338b9e96cc5c7/path.py-8.2.1.tar.gz"
    sha256 "c9ad2d462a7f8d7f6f6d2b89220bd50425221e399a4b8dfe5fa6725eb26fd708"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/67/f6/ad4d6964da803ffe0ec9d513b0be6924be0f502636c17781308561f08034/pathspec-0.5.0.tar.gz"
    sha256 "aa3a071054d4740b963c91a3127a5e0e1358351718bae2a3f731ec24fb0bdd1f"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/c3/2c/63275fab26a0fd8cadafca71a3623e4d0f0ee8ed7124a5bb128853d178a7/pbr-1.10.0.tar.gz"
    sha256 "186428c270309e6fdfe2d5ab0949ab21ae5f7dea831eab96701b86bd666af39c"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/0c/d6/b1fe519846a21614fa4f8233361574eddb223e0bc36b182140d916acfb3b/pyOpenSSL-16.2.0.tar.gz"
    sha256 "7779a3bbb74e79db234af6a08775568c6769b5821faecf6e2f4143edb227516e"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/f7/83/377e3dd2e95f9020dbd0dfd3c47aaa7deebe3c68d3857a4e51917146ae8b/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/2e/ad/e627446492cc374c284e82381215dcd9a0a87c4f6e90e9789afefe6da0ad/requests-2.11.1.tar.gz"
    sha256 "5acf980358283faba0b897c73959cecf8b841205bb4b2ad3ef545f46eae1a133"
  end

  resource "ruamel.ordereddict" do
    url "https://files.pythonhosted.org/packages/b1/17/97868578071068fe7d115672b52624d421ff24e5e802f65d6bf3ea184e8f/ruamel.ordereddict-0.4.9.tar.gz"
    sha256 "7058c470f131487a3039fb9536dda9dd17004a7581bdeeafa836269a36a2b3f6"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/f1/5c/95172cdd6e9f8a014718d40382ca378db697f2a6f9a7fc1505a3f8dac400/ruamel.yaml-0.12.15.tar.gz"
    sha256 "def928a0cf7a4859c5af528199b7a420caefff765beeff410eacf7bfc08d4198"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "stuf" do
    url "https://files.pythonhosted.org/packages/76/62/171e06b6d2d3072ea333de19632c61a44f83199e20cbf4924d12827cf66a/stuf-0.9.16.tar.bz2"
    sha256 "e61d64a2180c19111e129d36bfae66a0cb9392e1045827d6495db4ac9cb549b0"
  end

  resource "testresources" do
    url "https://files.pythonhosted.org/packages/9d/57/8e3986cd95a80dd23195f599befa023eb85d031d2d870c47124fa5ccbf06/testresources-2.0.1.tar.gz"
    sha256 "ee9d1982154a1e212d4e4bac6b610800bfb558e4fb853572a827bc14a96e4417"
  end

  resource "theblues" do
    url "https://files.pythonhosted.org/packages/de/72/dde64e7f7224a641396cbf5824a6cbbb0795dbb53410c6e9b1cfe2be5788/theblues-0.3.7.tar.gz"
    sha256 "d4e328981944b6197b6c95697a073b6406cdaa2f397c639454770de3bcda5060"
  end

  resource "translationstring" do
    url "https://files.pythonhosted.org/packages/5e/eb/bee578cc150b44c653b63f5ebe258b5d0d812ddac12497e5f80fcad5d0b4/translationstring-1.3.tar.gz"
    sha256 "4ee44cfa58c52ade8910ea0ebc3d2d84bdcad9fa0422405b1801ec9b9a65b72d"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/19/2f/b1090ace275335a9c0dde9a4623b109b7960a2b5370ae59d1eb1539afd8a/typing-3.5.2.2.tar.gz"
    sha256 "2bce34292653af712963c877f3085250a336738e64f99048d1b8509bebc4772f"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/8b/2c/c0d3e47709d0458816167002e1aa3d64d03bdeb2a9d57c5bd18448fd24cd/virtualenv-15.0.3.tar.gz"
    sha256 "6d9c760d3fc5fa0894b0f99b9de82a4647e1164f0b700a7f99055034bf548b1d"
  end

  resource "wadllib" do
    url "https://files.pythonhosted.org/packages/7e/94/9e5f9ad89001215f67619adc2ed3ac771dbbdb23bc7d91bf0bce4aff7bd6/wadllib-1.3.2.tar.gz"
    sha256 "140e43fc16d4352a98a90a450c6326bee5e6de73ae373a569947f3b505405034"
  end

  resource "wsgi_intercept" do
    url "https://files.pythonhosted.org/packages/b7/42/56e25f6444d6254ae24b60d0da9cd8f4652db356088de91baffc1d42c624/wsgi_intercept-1.4.1.tar.gz"
    sha256 "a244cd7de9a06fab53d769668190d912d77e5d36aa38b6034d4413084c6f1458"
  end

  resource "zope.interface" do
    url "https://files.pythonhosted.org/packages/38/1b/d55c39f2cf442bd9fb2c59760ed058c84b57d25c680819c25f3aff741e1f/zope.interface-4.3.2.tar.gz"
    sha256 "6a0e224a052e3ce27b3a7b1300a24747513f7a507217fcc2a4cb02eb92945cee"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/charm-version"
  end
end
