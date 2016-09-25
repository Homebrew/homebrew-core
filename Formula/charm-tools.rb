class CharmTools < Formula
  include Language::Python::Virtualenv

  desc "Tools for authoring and maintaining juju charms"
  homepage "https://github.com/juju/charm-tools"
  url "https://github.com/juju/charm-tools/releases/download/v2.1.2/charm-tools-2.1.2.tar.gz"
  sha256 "81ec4363df3b79556260ee51690227ea02ef288ebbfdd73a0261ae2177ad0002"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3ec84b54d75bd60d8c957912e8a13be1d5ef7fe008a6f486880aada62824be5a" => :sierra
    sha256 "ca750413f4324fa1a3ad19893c7575a75afddc4e1587c9d3c0133e827d5f6ed8" => :el_capitan
    sha256 "f34780f31601ae254867fb92c423a3cb1332f12e4de1134fa2dc474deaf1aefd" => :yosemite
    sha256 "5c80786313b50153e6c76ff3bac4e7f947fcc07e5ee9c9f64d51aab5ec23237d" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"
  depends_on :hg
  depends_on "charm"
  depends_on "openssl"

  # Additionally include ndg-httpsclient for requests[security]

  resource "argparse" do
    url "https://files.pythonhosted.org/packages/18/dd/e617cfc3f6210ae183374cd9f6a26b20514bbb5a792af97949c5aacddf0f/argparse-1.4.0.tar.gz"
    sha256 "62b089a55be1d8949cd2bc7e0df0bddb9e028faefc8c32038cc84862aefdd6e4"
  end

  resource "blessings" do
    url "https://files.pythonhosted.org/packages/af/4a/61acd1c6c29662d3fcbcaee5ba95c20b1d315c5a33534732b6d81e0dc8e8/blessings-1.6.tar.gz"
    sha256 "edc5713061f10966048bf6b40d9a514b381e0ba849c64e034c4ef6c1847d3007"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/83/3c/00b553fd05ae32f27b3637f705c413c4ce71290aa9b4c4764df694e906d9/cffi-1.7.0.tar.gz"
    sha256 "6ed5dd6afd8361f34819c68aaebf9e8fc12b5a5893f91f50c9e50c8886bb60df"
  end

  resource "Cheetah" do
    url "https://files.pythonhosted.org/packages/cd/b0/c2d700252fc251e91c08639ff41a8a5203b627f4e0a2ae18a6b662ab32ea/Cheetah-2.4.4.tar.gz"
    sha256 "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550"
  end

  resource "colander" do
    url "https://files.pythonhosted.org/packages/62/23/14a8cf54ce7d521680a29061e02133885016ae53bdccd132662c53382a4e/colander-1.3.1.tar.gz"
    sha256 "48bdbb5e8f50fcf2f05aab6bb2c0ab58d6ec7eed81a72b7d0272744fe72fafc2"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/a9/5b/a383b3a778609fe8177bd51307b5ebeee369b353550675353f46cb99c6f0/cryptography-1.4.tar.gz"
    sha256 "bb149540ed90c4b2171bf694fe6991d6331bc149ae623c8ff419324f4222d128"
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
    url "https://files.pythonhosted.org/packages/cd/c5/bd44885274379121507870d4abfe7ba908326cf7bfd50a48d9d6ae091c0d/ipaddress-1.0.16.tar.gz"
    sha256 "5a3182b322a706525c46282ca6f064d27a02cffbd449f9f47416f1dc96aa71b0"
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
    url "https://files.pythonhosted.org/packages/7e/84/65816c2936cf7191bcb5b3e3dc4fb87def6f8a38be25b3a78131bbb08594/keyring-9.3.1.tar.gz"
    sha256 "3be74f6568fcac1350b837d7e46bd3525e2e9fe2b78b3a3a87dc3b29f24a0c00"
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

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/9b/53/4492f2888408a2462fd7f364028b6c708f3ecaa52a028587d7dd729f40b4/Markdown-2.6.6.tar.gz"
    sha256 "9a292bb40d6d29abac8024887bcfc1159d7a32dc1d6f1f6e8d6d8e293666c504"
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
    url "https://files.pythonhosted.org/packages/c7/32/16e80b662842bd62209bc8d05ae2c42d03db4f63865fcef8f6993e301dff/pathspec-0.4.0.tar.gz"
    sha256 "d3147deb81d4d540f7489f9e761f6d2ab001351752a75ec45741adacc7880e1c"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/c3/2c/63275fab26a0fd8cadafca71a3623e4d0f0ee8ed7124a5bb128853d178a7/pbr-1.10.0.tar.gz"
    sha256 "186428c270309e6fdfe2d5ab0949ab21ae5f7dea831eab96701b86bd666af39c"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/77/f2/bccec75ca4280a9fa762a90a1b8b152a22eac5d9c726d7da1fcbfe0a20e6/pyOpenSSL-16.0.0.tar.gz"
    sha256 "363d10ee43d062285facf4e465f4f5163f9f702f9134f0a5896f134cbb92d17d"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/f7/83/377e3dd2e95f9020dbd0dfd3c47aaa7deebe3c68d3857a4e51917146ae8b/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/6d/31/666614af3db0acf377876d48688c5d334b6e493b96d21aa7d332169bee50/pycparser-2.14.tar.gz"
    sha256 "7959b4a74abdc27b312fed1c21e6caf9309ce0b29ea86b591fd2e99ecdf27f73"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/75/5e/b84feba55e20f8da46ead76f14a3943c8cb722d40360702b2365b91dec00/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/49/6f/183063f01aae1e025cf0130772b55848750a2f3a89bfa11b385b35d7329d/requests-2.10.0.tar.gz"
    sha256 "63f1815788157130cee16a933b2ee184038e975f0017306d723ac326b5525b54"
  end

  resource "ruamel.ordereddict" do
    url "https://files.pythonhosted.org/packages/b1/17/97868578071068fe7d115672b52624d421ff24e5e802f65d6bf3ea184e8f/ruamel.ordereddict-0.4.9.tar.gz"
    sha256 "7058c470f131487a3039fb9536dda9dd17004a7581bdeeafa836269a36a2b3f6"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/90/3b/579031b098897b534d1a548cd854f450808ab085b95e454890390dae4b11/ruamel.yaml-0.11.14.tar.gz"
    sha256 "c6bb9cb4e1e20266f462ed43f1a8a51e889c94abde31643af31785c36a336eab"
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
    url "https://files.pythonhosted.org/packages/ee/6e/de72396046de4c9d0c1c2b9b1923710c71d879d9243a118b6d5ce7a5eb4c/theblues-0.3.4.tar.gz"
    sha256 "06567fe1a6599832e13e9bd2a2ef2f18f278bcbd678f2ac2f0bab85fe45892b8"
  end

  resource "translationstring" do
    url "https://files.pythonhosted.org/packages/5e/eb/bee578cc150b44c653b63f5ebe258b5d0d812ddac12497e5f80fcad5d0b4/translationstring-1.3.tar.gz"
    sha256 "4ee44cfa58c52ade8910ea0ebc3d2d84bdcad9fa0422405b1801ec9b9a65b72d"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/5c/79/5dae7494b9f5ed061cff9a8ab8d6e1f02db352f3facf907d9eb614fb80e9/virtualenv-15.0.2.tar.gz"
    sha256 "fab40f32d9ad298fba04a260f3073505a16d52539a84843cf8c8369d4fd17167"
  end

  resource "wadllib" do
    url "https://files.pythonhosted.org/packages/7e/94/9e5f9ad89001215f67619adc2ed3ac771dbbdb23bc7d91bf0bce4aff7bd6/wadllib-1.3.2.tar.gz"
    sha256 "140e43fc16d4352a98a90a450c6326bee5e6de73ae373a569947f3b505405034"
  end

  resource "wsgi_intercept" do
    url "https://files.pythonhosted.org/packages/f5/c6/ce269dd014ffc57643fe6b3ab48bd0c0db6a34cdf06add279a61612c2309/wsgi_intercept-1.3.1.tar.gz"
    sha256 "5de354a99ca2b400ae302e423f6bb6c1d2a01767fdcc8e5589340d3e542eb97e"
  end

  resource "zope.interface" do
    url "https://files.pythonhosted.org/packages/ea/a3/38bdc8e8bd068ea5b4d21a2d80eca1547cd8509318e8d7c875f7247abe43/zope.interface-4.2.0.tar.gz"
    sha256 "36762743940a075283e1fb22a2ec9e8231871dace2aa00599511ddc4edf0f8f9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/charm-version"
  end
end
