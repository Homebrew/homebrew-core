class CharmTools < Formula
  include Language::Python::Virtualenv

  desc "Tools for authoring and maintaining juju charms"
  homepage "https://github.com/juju/charm-tools"
  url "https://files.pythonhosted.org/packages/3e/0c/6f4b8a7e907a426985bbd5314bd7a5bfcbbd62d225c1b97d449a83de1cfa/charm-tools-2.7.3.tar.gz"
  sha256 "6105a2807a100f56a0ca05c989b3f77cdffcc2eef02913e20e0255b652096bb5"
  revision 1

  bottle do
    cellar :any
    sha256 "c284dc36c8de6c6039b9d16e2b3a0d735f8997ac350bec99bebd1644de9dc47a" => :catalina
    sha256 "118ff4b6125920c24da95468fd86d1296e2762c9725e6716205113772b359184" => :mojave
    sha256 "94558890e5674e2452282d60f4ca88486f096a981abce10c14c3d4883b9c84a6" => :high_sierra
  end

  depends_on "charm"
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "python@3.8"

  uses_from_macos "libffi"

  # Additionally include ndg-httpsclient for requests[security]
  resource "Cheetah3" do
    url "https://files.pythonhosted.org/packages/4e/72/e6a7d92279e3551db1b68fd336fd7a6e3d2f2ec742bf486486e6150d77d2/Cheetah3-3.2.4.tar.gz"
    sha256 "caabb9c22961a3413ac85cd1e5525ec9ca80daeba6555f4f60802b6c256e252b"
  end

  # pyyaml>=3.11,<4.3
  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  # 'secretstorage<2.4'
  resource "SecretStorage" do
    url "https://files.pythonhosted.org/packages/a5/a5/0830cfe34a4cfd0d1c3c8b614ede1edb2aaf999091ac8548dd19cb352e79/SecretStorage-2.3.1.tar.gz"
    sha256 "3af65c87765323e6f64c83575b05393f9e003431959c9395d1791d51497f29b6"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz"
    sha256 "9e5896d1372858f8dd3344faf4e5014d21849c756c8d5701f78f8a103b372d92"
  end

  # blessings<=1.6
  resource "blessings" do
    url "https://files.pythonhosted.org/packages/af/4a/61acd1c6c29662d3fcbcaee5ba95c20b1d315c5a33534732b6d81e0dc8e8/blessings-1.6.tar.gz"
    sha256 "edc5713061f10966048bf6b40d9a514b381e0ba849c64e034c4ef6c1847d3007"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/b8/e2/a3a86a67c3fc8249ed305fc7b7d290ebe5e4d46ad45573884761ef4dea7b/certifi-2020.4.5.1.tar.gz"
    sha256 "51fcb31174be6e6664c5f69e3e1691a2d72a1a12e90f872cbdb1567eb47b6519"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/05/54/3324b0c46340c31b909fcec598696aaec7ddc8c18a63f2db352562d3354c/cffi-1.14.0.tar.gz"
    sha256 "2d384f4a127a15ba701207f7639d94106693b6cd64173d6c8988e2c25f3ac2b6"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "colander" do
    url "https://files.pythonhosted.org/packages/db/e4/74ab06f54211917b41865cafc987ce511e35503de48da9bfe9358a1bdc3e/colander-1.7.0.tar.gz"
    sha256 "d758163a22d22c39b9eaae049749a5cd503f341231a02ed95af480b1145e81f2"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/56/3b/78c6816918fdf2405d62c98e48589112669f36711e50158a0c15d804c30d/cryptography-2.9.2.tar.gz"
    sha256 "a0c30272fb4ddda5f5ffc1089d7405b7a71b0b0f51993cb4e5dbb4590b2fc229"
  end

  resource "dict2colander" do
    url "https://files.pythonhosted.org/packages/aa/7e/5ed2ba3dc2f06457b76d4bc8c93559179472bf87e6982f9a9e5cea30e84e/dict2colander-0.2.tar.gz"
    sha256 "6f668d60896991dcd271465b755f00ffd6f87f81e0d4d054be62a16c086978c7"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/7d/29/694a3a4d7c0e1aef76092e9167fbe372e0f7da055f5dcf4e1313ec21d96a/distlib-0.3.0.zip"
    sha256 "2e166e231a26b36d6dfe35a48c4464346620f8645ed0ace01ee31822b288de21"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/a6/a4/75064c334d8ae433445a20816b788700db1651f21bdb0af33db2aab142fe/distro-1.5.0.tar.gz"
    sha256 "0e58756ae38fbd8fc3020d54badb8eae17c5b9dcbed388b17bb55b8a5928df92"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/14/ec/6ee2168387ce0154632f856d5cc5592328e9cf93127c5c9aeca92c8c16cb/filelock-3.0.12.tar.gz"
    sha256 "18d82244ee114f543149c66a6e0c14e9c4f8a1044b5cdaadd0f82159d6a6ff59"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/b4/ff/605ae6e8e77cad745c877d512851cc40d75d8068b1e456fcb4e30ee2d944/httplib2-0.17.3.tar.gz"
    sha256 "39dd15a333f67bfb70798faa9de8a6e99c819da6ad82b77f9a259a5c7b1225a2"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/19/57503b5de719ee45e83472f339f617b0c01ad75cba44aba1e4c97c2b0abd/idna-2.9.tar.gz"
    sha256 "7588d1c14ae4c77d74036e8c22ff447b26d0fde8f007354fd48a7814db15b7cb"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/45/13/3db24895497345fb44c4248c08b16da34a9eb02643cea2754b21b5ed08b0/iso8601-0.1.12.tar.gz"
    sha256 "49c4b20e1f38aa5cf109ddcd39647ac419f928512c869dc01d5c7098eddede82"
  end

  # 'jsonschema<=2.5.1'
  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/58/0d/c816f5ea5adaf1293a1d81d32e4cdfdaf8496973aa5049786d7fdb14e7e7/jsonschema-2.5.1.tar.gz"
    sha256 "36673ac378feed3daa5956276a829699056523d7961027911f064b52255ead41"
  end

  resource "jujubundlelib" do
    url "https://files.pythonhosted.org/packages/fe/6c/a70cd143c77c3a5d6935e6b9e46261e8cab4db7911691650d0bbde8a1a78/jujubundlelib-0.5.6.tar.gz"
    sha256 "80e4fbc2b8593082f57de03703df8c5ba69ed1cf73519d499f5d49c51ec91949"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/a6/52/eb8a0e13b54ec9240c7dd68fcd0951c52f62033d438af372831af770f7cc/keyring-21.2.1.tar.gz"
    sha256 "c53e0e5ccde3ad34284a40ce7976b5b3a3d6de70344c3f8ee44364cc340976ec"
  end

  resource "launchpadlib" do
    url "https://files.pythonhosted.org/packages/af/23/d97442ef2e13db4648608a9e1a5822b9ff5e25e7f05013b8a57343120e85/launchpadlib-1.10.13.tar.gz"
    sha256 "5804d68ec93247194449d17d187e949086da0a4d044f12155fad269ef8515435"
  end

  resource "lazr.restfulclient" do
    url "https://files.pythonhosted.org/packages/4a/2f/14812d3b0808c594c1e090505229d5ae31d55eb93c23417d91b3a1f57853/lazr.restfulclient-0.14.3.tar.gz"
    sha256 "9f28bbb7c00374159376bd4ce36b4dacde7c6b86a0af625aa5e3ae214651a690"
  end

  resource "lazr.uri" do
    url "https://files.pythonhosted.org/packages/ea/bf/71ad2f5eaf7885d36e3cbd0a87cf3812ad043cf99c9fa6cc6ab4c94ee862/lazr.uri-1.0.3.tar.gz"
    sha256 "5c620b5993c8c6a73084176bfc51de64972b8373620476ed841931a49752dc8b"
  end

  resource "libcharmstore" do
    url "https://files.pythonhosted.org/packages/bc/83/c97392aa3ab2c2fd81a4e8896d986d59f7087342b71fed9d2168ada7589d/libcharmstore-0.0.9.tar.gz"
    sha256 "0e82e7c4177b02f342bd85a3c3b1f46d1a0ddb4447e1305d3a3854226946e41e"
  end

  resource "macaroonbakery" do
    url "https://files.pythonhosted.org/packages/52/40/2a8bb2f507ce1a6c5b896c1b98044d74d34b07a6dd771526b4fe84e3181f/macaroonbakery-1.3.1.tar.gz"
    sha256 "23f38415341a1d04a155b4dac6730d3ad5f39b86ce07b1bb134bdda52b48b053"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/fc/c7/829c73c64d3749da7811c06319458e47f3461944da9d98bb4df1cb1598c2/oauthlib-3.1.0.tar.gz"
    sha256 "bee41cc35fcca6e988463cacc3bcb8a96224f470ca547e697b604cc697b2f889"
  end

  resource "otherstuf" do
    url "https://files.pythonhosted.org/packages/4f/b5/fe92e1d92610449f001e04dd9bf7dc13b8e99e5ef8859d2da61a99fc8445/otherstuf-1.1.0.tar.gz"
    sha256 "7722980c3b58845645da2acc838f49a1998c8a6bdbdbb1ba30bcde0b085c4f4c"
  end

  resource "parse" do
    url "https://files.pythonhosted.org/packages/f4/65/220bb4075fddb09d5b3ea2c1c1fa66c1c72be9361ec187aab50fa161e576/parse-1.15.0.tar.gz"
    sha256 "a6d4e2c2f1fbde6717d28084a191a052950f758c0cbd83805357e6575c2b95c0"
  end

  resource "path" do
    url "https://files.pythonhosted.org/packages/ff/15/3cb6e963733af47dc11289c20215f78ab5dc090f54cb568b891add332694/path-13.1.0.tar.gz"
    sha256 "97249b37e5e4017429a780920147200a2215e268c1a18fa549fec0b654ce99b7"
  end

  resource "path.py" do
    url "https://files.pythonhosted.org/packages/b9/22/7f03ee0463f6734dd9f6957e7ab15681c9d44a8ce7a13af569a8e3e8d863/path.py-12.4.0.tar.gz"
    sha256 "6647ca22523f5e868b110cc3d958be01aa92e662a8241e464f7416779427bf3e"
  end

  # pathspec<=0.3.4
  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/14/9d/c9d790d373d6f6938d793e9c549b87ad8670b6fa7fc6176485e6ef11c1a4/pathspec-0.3.4.tar.gz"
    sha256 "7605ca5c26f554766afe1d177164a2275a85bb803b76eba3428f422972f66728"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/8a/a8/bb34d7997eb360bc3e98d201a20b5ef44e54098bb2b8e978ae620d933002/pbr-5.4.5.tar.gz"
    sha256 "07f558fece33b05caf857474a366dfcc00562bca13dd8b47b2b3e22d9f9bf55c"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/c9/d5/e6e789e50e478463a84bd1cdb45aa408d49a2e1aaffc45da43d10722c007/protobuf-3.11.3.tar.gz"
    sha256 "c77c974d1dadf246d789f6dad1c24426137c9091e930dbf50e0a29c1fcf00b1f"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "pymacaroons" do
    url "https://files.pythonhosted.org/packages/37/b4/52ff00b59e91c4817ca60210c33caf11e85a7f68f7b361748ca2eb50923e/pymacaroons-0.13.0.tar.gz"
    sha256 "1e6bba42a5f66c245adf38a5a4006a99dcc06a0703786ea636098667d42903b8"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/61/ab/2ac6dea8489fa713e2b4c6c5b549cc962dd4a842b5998d9e80cf8440b7cd/PyNaCl-1.3.0.tar.gz"
    sha256 "0c6100edd16fefd1557da078c7a31e7b7d7a52ce39fdca2bec29d4f7b6e7600c"
  end

  resource "pyRFC3339" do
    url "https://files.pythonhosted.org/packages/00/52/75ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7/pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f4/f6/94fee50f4d54f58637d4b9987a1b862aeb6cd969e73623e02c5c00755577/pytz-2020.1.tar.gz"
    sha256 "c35965d010ce31b23eeb663ed3cc8c906275d6be1a34393a1d73a41febf4a048"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/f5/4f/280162d4bd4d8aad241a21aecff7a6e46891b905a4341e7ab549ebaf7915/requests-2.23.0.tar.gz"
    sha256 "b3f43d496c6daba4493e7c431722aeb7dbc6288f52a6e04e7b6023b0247817e6"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/9a/ee/55cd64bbff971c181e2d9e1c13aba9a27fd4cd2bee545dbe90c44427c757/ruamel.yaml-0.15.100.tar.gz"
    sha256 "8e42f3067a59e819935a2926e247170ed93c8f0b2ab64526f888e026854db2e4"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
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
    url "https://files.pythonhosted.org/packages/9e/44/09471b2abf1cc22a427a8d49e4cfa9049bc18ea2c99d318faffc37b367a3/theblues-0.5.2.tar.gz"
    sha256 "a9aded6b151c67d83eb9adcbcb38640872d9f29db985053259afd2fc012e5ed9"
  end

  resource "translationstring" do
    url "https://files.pythonhosted.org/packages/5e/eb/bee578cc150b44c653b63f5ebe258b5d0d812ddac12497e5f80fcad5d0b4/translationstring-1.3.tar.gz"
    sha256 "4ee44cfa58c52ade8910ea0ebc3d2d84bdcad9fa0422405b1801ec9b9a65b72d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/05/8c/40cd6949373e23081b3ea20d5594ae523e681b6f472e600fbc95ed046a36/urllib3-1.25.9.tar.gz"
    sha256 "3018294ebefce6572a474f0604c2021e33b3fd8006ecd11d62107a5d2a963527"
  end

  resource "vergit" do
    url "https://files.pythonhosted.org/packages/d8/dc/2ef077a97a05633bbe7a46b9cb4b87fbf994a9aaa52b44a8f1086d20951f/vergit-1.0.2.tar.gz"
    sha256 "ea82a4d6057d4891a4b16e0881bd756ceea2b66253edc05dd619450f88a5ff31"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/54/a2/bbfd87f524096f26b373a3428e56bdcda6661ba38314f1d864a71a6e70ce/virtualenv-20.0.18.tar.gz"
    sha256 "ac53ade75ca189bc97b6c1d9ec0f1a50efe33cbf178ae09452dcd9fd309013c1"
  end

  resource "wadllib" do
    url "https://files.pythonhosted.org/packages/07/d5/2a77dcbb4185d4df41c61a3abccd6e570b652b11973437430cefd65d91ab/wadllib-1.3.4.tar.gz"
    sha256 "e995691713d3c795d2b36278de8e212241870f46bec6ecba91794ea3cc5bd67d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/charm-version"
  end
end
