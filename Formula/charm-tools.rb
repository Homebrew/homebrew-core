class CharmTools < Formula
  include Language::Python::Virtualenv

  desc "Tools for authoring and maintaining juju charms"
  homepage "https://github.com/juju/charm-tools"
  url "https://files.pythonhosted.org/packages/99/4d/16d7398fe5eefc602a8870fb3e93597aabe681b0f1497749148695cba4a1/charm-tools-2.2.3.tar.gz"
  sha256 "ea659f59041cb3dff0be862d657830591e656a9a259931064edab7477875245b"
  revision 4

  bottle do
    cellar :any
    sha256 "276a8198e27a384e9d45392f485f184170cc324586740e046c6b55a44539a559" => :mojave
    sha256 "68365eeb6730d2d7645a791c7d60206d733f19d56c16deb31e5b42cc0378bc28" => :high_sierra
    sha256 "4dc6ab436414c0ffd0c07601bec4240b2907c090b7a7a300c5ec6bc49e960a01" => :sierra
    sha256 "11a6747479a401661fcd32e6233e581ec0f065a0fc737ee3da163c23d73bb00d" => :el_capitan
  end

  depends_on "charm"
  depends_on "libyaml"
  depends_on "mercurial"
  depends_on "openssl@1.1"
  depends_on "python@2"

  # Additionally include ndg-httpsclient for requests[security]
  resource "Cheetah" do
    url "https://files.pythonhosted.org/packages/cd/b0/c2d700252fc251e91c08639ff41a8a5203b627f4e0a2ae18a6b662ab32ea/Cheetah-2.4.4.tar.gz"
    sha256 "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550"
  end

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/29/82/dfe242bcfd9eec0e7bf93a80a8f8d8515a95b980c44f5c0b45606397a423/Markdown-2.6.9.tar.gz"
    sha256 "73af797238b95768b3a9b6fe6270e250e5c09d988b8e5b223fd5efa4e06faf81"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/75/5e/b84feba55e20f8da46ead76f14a3943c8cb722d40360702b2365b91dec00/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "SecretStorage" do
    url "https://files.pythonhosted.org/packages/a5/a5/0830cfe34a4cfd0d1c3c8b614ede1edb2aaf999091ac8548dd19cb352e79/SecretStorage-2.3.1.tar.gz"
    sha256 "3af65c87765323e6f64c83575b05393f9e003431959c9395d1791d51497f29b6"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/31/53/8bca924b30cb79d6d70dbab6a99e8731d1e4dd3b090b7f3d8412a8d8ffbc/asn1crypto-0.23.0.tar.gz"
    sha256 "0874981329cfebb366d6584c3d16e913f2a0eb026c9463efcc4aaf42a9d94d70"
  end

  resource "blessings" do
    url "https://files.pythonhosted.org/packages/af/4a/61acd1c6c29662d3fcbcaee5ba95c20b1d315c5a33534732b6d81e0dc8e8/blessings-1.6.tar.gz"
    sha256 "edc5713061f10966048bf6b40d9a514b381e0ba849c64e034c4ef6c1847d3007"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/c9/70/89b68b6600d479034276fed316e14b9107d50a62f5627da37fafe083fde3/cffi-1.11.2.tar.gz"
    sha256 "ab87dd91c0c4073758d07334c1e5f712ce8fe48f007b86f8238773963ee700a6"
  end

  resource "colander" do
    url "https://files.pythonhosted.org/packages/4d/bc/48b9751b5c532ec74e78f3a8c09d26994f8e748e4895bbc5d2f6c8c5734b/colander-1.0b1.tar.gz"
    sha256 "8a342bf278227be6ac96e90befa949c235e667254db17e773e79d834459be971"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/f3/7c/ec4f94489719803cb14d35e9625d1f5a613b9c4b8d01ee52a4c77485e681/cryptography-2.1.3.tar.gz"
    sha256 "68a26c353627163d74ee769d4749f2ee243866e9dac43c93bb33ebd8fbed1199"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/f9/e5/99ebb176e47f150ac115ffeda5fedb6a3dbb3c00c74a59fd84ddf12f5857/ecdsa-0.13.tar.gz"
    sha256 "64cf1ee26d1cde3c73c6d7d107f835fed7c6a2904aef9eac223d57ad800c43fa"
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
    url "https://files.pythonhosted.org/packages/e4/2e/a7e27d2c36076efeb8c0e519758968b20389adf57a9ce3af139891af2696/httplib2-0.10.3.tar.gz"
    sha256 "e404d3b7bd86c1bc931906098e7c1305d6a3a6dcef141b8bb1059903abb3ceeb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/4e/13/774faf38b445d0b3a844b65747175b2e0500164b7c28d78e34987a5bfe06/ipaddress-1.0.18.tar.gz"
    sha256 "5d8534c8e185f2d8a1fda1ef73f2c8f4b23264e8e30063feeb9511d492a413e1"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/58/0d/c816f5ea5adaf1293a1d81d32e4cdfdaf8496973aa5049786d7fdb14e7e7/jsonschema-2.5.1.tar.gz"
    sha256 "36673ac378feed3daa5956276a829699056523d7961027911f064b52255ead41"
  end

  resource "jujubundlelib" do
    url "https://files.pythonhosted.org/packages/f5/79/862a0f62f725ed537e298e04942742a6c0110d2da4404040d77ca3e0d8d5/jujubundlelib-0.5.5.tar.gz"
    sha256 "125383aee2f60af66bb909682aa0757d8e0be083e3f8125473e18a9f3f2d4f3d"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/37/0c/034139cd798dac3ceb4fcb4ed85e20c27f3e579c25cdaf066aad1552da3d/keyring-10.4.0.tar.gz"
    sha256 "901a3f4ed0dfba473060281b58fd3b649ce70f59cb34a9cf6cb5551218283b26"
  end

  resource "launchpadlib" do
    url "https://files.pythonhosted.org/packages/e6/2b/721606eba8d52e66c6aa436d05ef4b8def963e3d6cbfbb61a05b3891bda3/launchpadlib-1.10.5.tar.gz"
    sha256 "b9c32cf960de042ba73e77ac4d4d0f694135713715f0afa1ca2630ffb03ba2a7"
  end

  resource "lazr.restfulclient" do
    url "https://files.pythonhosted.org/packages/aa/3e/87b8658c0e4fe272c4da0c4f9d0e219c42ee7ddb149a063b8c3a95f265af/lazr.restfulclient-0.13.5.tar.gz"
    sha256 "722f27a8baefa83c347fe3a6330de5fe381d8473d3bb7c5726762cabf9556800"
  end

  resource "lazr.uri" do
    url "https://files.pythonhosted.org/packages/ea/bf/71ad2f5eaf7885d36e3cbd0a87cf3812ad043cf99c9fa6cc6ab4c94ee862/lazr.uri-1.0.3.tar.gz"
    sha256 "5c620b5993c8c6a73084176bfc51de64972b8373620476ed841931a49752dc8b"
  end

  resource "libcharmstore" do
    url "https://files.pythonhosted.org/packages/06/57/710e53ba029bbcdd86da4b9be293105ef4eb14178e283cf57188e89ba55c/libcharmstore-0.0.7.tar.gz"
    sha256 "19a6c83d565a0b91726f4289b664a68bbc766f8c80cc6d9f8230b030706cf990"
  end

  resource "ndg-httpsclient" do
    url "https://files.pythonhosted.org/packages/25/4c/28c412126f0394dbb3d8005465357581f087fc7ec100b0e83838a90009b7/ndg_httpsclient-0.4.3.tar.gz"
    sha256 "7bfd8c5cfcbc241a93ca6a4e45f952650f5c7ecf7c49b1dbcf5f4d390240be0b"
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
    url "https://files.pythonhosted.org/packages/23/1d/1d0254566e13a86e61931f24d2cf72cc32d1286636b581ac2999a2ec1787/paramiko-1.18.4.tar.gz"
    sha256 "c5f9e14d44bd4940244a7dccde6019d97472122f07585e1081fc4c7327ea2765"
  end

  resource "parse" do
    url "https://files.pythonhosted.org/packages/13/71/e0b5c968c552f75a938db18e88a4e64d97dc212907b4aca0ff71293b4c80/parse-1.8.2.tar.gz"
    sha256 "8048dde3f5ca07ad7ac7350460952d83b63eaacecdac1b37f45fd74870d849d2"
  end

  resource "path.py" do
    url "https://files.pythonhosted.org/packages/90/bb/3440e0734cb2dcfbf3644546dad7dfc08b197d5dd52877de95f95fd459b2/path.py-8.1.2.tar.gz"
    sha256 "ada95d117c4559abe64080961daf5badda68561afdd34c278f8ca20f2fa466d2"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/14/9d/c9d790d373d6f6938d793e9c549b87ad8670b6fa7fc6176485e6ef11c1a4/pathspec-0.3.4.tar.gz"
    sha256 "7605ca5c26f554766afe1d177164a2275a85bb803b76eba3428f422972f66728"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/d5/d6/f2bf137d71e4f213b575faa9eb426a8775732432edb67588a8ee836ecb80/pbr-3.1.1.tar.gz"
    sha256 "05f61c71aaefc02d8e37c0a3eeb9815ff526ea28b3b76324769e6158d7f95be1"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/ee/6a/cd78737dd990297205943cc4dcad3d3c502807fd2c5b18c5f33dc90ca214/pyOpenSSL-17.3.0.tar.gz"
    sha256 "29630b9064a82e04d8242ea01d7c93d70ec320f5e3ed48e95fcabc6b1d0f6c76"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/3c/a6/4d6c88aa1694a06f6671362cb3d0350f0d856edea4685c300785200d1cd9/pyasn1-0.3.7.tar.gz"
    sha256 "187f2a66d617683f8e82d5c00033b7c8a0287e1da88a9d577aebec321cad4965"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/f9/6d/07c44fb1ebe04d069459a189e7dab9e4abfe9432adcd4477367c25332748/requests-2.9.1.tar.gz"
    sha256 "c577815dd00f1394203fc44eb979724b098f88264a9ef898ee45b8e5e9cf587f"
  end

  resource "ruamel.base" do
    url "https://files.pythonhosted.org/packages/ea/77/60a0945f4b4eac4b6bd74d1b8e103ae58d0f07b934f962bb4c49e6ec205e/ruamel.base-1.0.0.tar.gz"
    sha256 "c041333a0f0f00cd6593eb36aa83abb1a9e7544e83ba7a42aa7ac7476cee5cf3"
  end

  resource "ruamel.ordereddict" do
    url "https://files.pythonhosted.org/packages/b1/8f/3b1b407ff387e006a4a33e62182b212077bed41676451d60327955a50c3c/ruamel.ordereddict-0.4.13.tar.gz"
    sha256 "bf0a198c8ce5d973c24e5dba12d3abc254996788ca6ad8448eabc6aa710db149"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/e1/fe/0021f94b54f7aa5a730b765f5a4eead9675be98c7f46c206c240fb9ef819/ruamel.yaml-0.10.23.tar.gz"
    sha256 "895347f81297f5542e1071092c6760ed13d86547764ebbaedbc2972eb8385dd8"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
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
    url "https://files.pythonhosted.org/packages/ab/09/21a4718cb6f06573153de35af742e4c251ca9b628c9001d06f6ed4b2cae5/theblues-0.3.8.tar.gz"
    sha256 "649f4013d3b9024f7990a7e0b42aed2196daea64a7c8501dde4f1f57ab8aa031"
  end

  resource "translationstring" do
    url "https://files.pythonhosted.org/packages/5e/eb/bee578cc150b44c653b63f5ebe258b5d0d812ddac12497e5f80fcad5d0b4/translationstring-1.3.tar.gz"
    sha256 "4ee44cfa58c52ade8910ea0ebc3d2d84bdcad9fa0422405b1801ec9b9a65b72d"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/d4/0c/9840c08189e030873387a73b90ada981885010dd9aea134d6de30cd24cb8/virtualenv-15.1.0.tar.gz"
    sha256 "02f8102c2436bb03b3ee6dede1919d1dac8a427541652e5ec95171ec8adbc93a"
  end

  resource "wadllib" do
    url "https://files.pythonhosted.org/packages/7e/94/9e5f9ad89001215f67619adc2ed3ac771dbbdb23bc7d91bf0bce4aff7bd6/wadllib-1.3.2.tar.gz"
    sha256 "140e43fc16d4352a98a90a450c6326bee5e6de73ae373a569947f3b505405034"
  end

  def install
    ENV.prepend_path "PATH", "/System/Library/Frameworks/Python.framework/Versions/Current/bin"
    ENV.prepend "CPPFLAGS", "-I#{MacOS.sdk_path}/usr/include/ffi"

    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/charm-version"
  end
end
