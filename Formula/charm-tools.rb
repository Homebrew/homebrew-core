class CharmTools < Formula
  include Language::Python::Virtualenv

  desc "Tools for authoring and maintaining juju charms"
  homepage "https://github.com/juju/charm-tools"
  url "https://files.pythonhosted.org/packages/76/60/38a847663576e08ff59c20245cf3939683443a8c6a6c999c5f7af09dccc6/charm-tools-2.2.0.tar.gz"
  sha256 "15f5d4d3a15398a21687b9c3c2015b511fb5c6d43e4a7aa8141673b4109e843a"

  bottle do
    cellar :any
    sha256 "2f286917e60870d00a44d30e7bcda422555494f3357424a9c2f8297b4daf8a35" => :sierra
    sha256 "c4e02d209d4ecd993f270a1460f406f296a6624f0354e4baffd8d865d41c5d6e" => :el_capitan
    sha256 "58f505e114f5d0d766845b90381e93c8f7c5d7600575bb8333e07d8187371c9e" => :yosemite
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
    url "https://files.pythonhosted.org/packages/1d/25/3f6d2cb31ec42ca5bd3bfbea99b63892b735d76e26f20dd2dcc34ffe4f0d/Markdown-2.6.8.tar.gz"
    sha256 "0ac8a81e658167da95d063a9279c9c1b2699f37c7c4153256a458b3a43860e33"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/75/5e/b84feba55e20f8da46ead76f14a3943c8cb722d40360702b2365b91dec00/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "SecretStorage" do
    url "https://files.pythonhosted.org/packages/24/af/50f2324784ee65e2b752624144249c7710e761be437dd82815ff86d3021f/SecretStorage-2.2.1.tar.gz"
    sha256 "d771e99ada09e39aceb75c4bb2d460895627b2260ab24c9cb790fb8aad1ecab6"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz"
    sha256 "9e5896d1372858f8dd3344faf4e5014d21849c756c8d5701f78f8a103b372d92"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/ce/39/17e90c2efacc4060915f7d1f9b8d2a5b20e54e46233bdf3092e68193407d/asn1crypto-0.21.1.tar.gz"
    sha256 "4e6d7b22814d680114a439faafeccb9402a78095fb23bf0b25f9404c6938a017"
  end

  resource "blessings" do
    url "https://files.pythonhosted.org/packages/af/4a/61acd1c6c29662d3fcbcaee5ba95c20b1d315c5a33534732b6d81e0dc8e8/blessings-1.6.tar.gz"
    sha256 "edc5713061f10966048bf6b40d9a514b381e0ba849c64e034c4ef6c1847d3007"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a1/32/e3d6c3a8b5461b903651dd6ce958ed03c093d2e00128e3f33ea69f1d7965/cffi-1.9.1.tar.gz"
    sha256 "563e0bd53fda03c151573217b3a49b3abad8813de9dd0632e10090f6190fdaf8"
  end

  resource "colander" do
    url "https://files.pythonhosted.org/packages/4d/bc/48b9751b5c532ec74e78f3a8c09d26994f8e748e4895bbc5d2f6c8c5734b/colander-1.0b1.tar.gz"
    sha256 "8a342bf278227be6ac96e90befa949c235e667254db17e773e79d834459be971"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/ec/5f/d5bc241d06665eed93cd8d3aa7198024ce7833af7a67f6dc92df94e00588/cryptography-1.8.1.tar.gz"
    sha256 "323524312bb467565ebca7e50c8ae5e9674e544951d28a2904a50012a8828190"
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
    url "https://files.pythonhosted.org/packages/d8/82/28a51052215014efc07feac7330ed758702fc0581347098a81699b5281cb/idna-2.5.tar.gz"
    sha256 "3cb5ce08046c4e3a560fc02f138d0ac63e00f8ce5901a56b32ec8b7994082aab"
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
    url "https://files.pythonhosted.org/packages/b1/45/6551cde9f6395502e4b03a8eb8ac99c1b05ef84278bd5616734b12013991/jujubundlelib-0.5.3.tar.gz"
    sha256 "c097f83c93d90d11120886ab823c8ae400cd935873754b8bdf4689d5767a88f5"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/d2/2f/b70bf3068b5964e4c45507e03652da0743c72460ff929e70aef201ed5ffb/keyring-10.3.tar.gz"
    sha256 "220a92af8119eb38e7f9afbdf8c2c93eef8186cc39e9ab2a0e4c80807df00e45"
  end

  resource "launchpadlib" do
    url "https://files.pythonhosted.org/packages/e6/2b/721606eba8d52e66c6aa436d05ef4b8def963e3d6cbfbb61a05b3891bda3/launchpadlib-1.10.5.tar.gz"
    sha256 "b9c32cf960de042ba73e77ac4d4d0f694135713715f0afa1ca2630ffb03ba2a7"
  end

  resource "lazr.authentication" do
    url "https://launchpad.net/lazr.authentication/trunk/0.1.3/+download/lazr.authentication-0.1.3.tar.gz"
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
    url "https://files.pythonhosted.org/packages/79/3c/10086803929205fd9ffd50980a36921f12d37da11e80a23f36f6286f3e9c/libcharmstore-0.0.6.tar.gz"
    sha256 "3066a6049218912eafa446e31236f640c3db13941d44a7a4e8b22d08a4febc73"
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

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c6/70/bb32913de251017e266c5114d0a645f262fb10ebc9bf6de894966d124e35/packaging-16.8.tar.gz"
    sha256 "5d50835fdf0a7edf0b55e311b7c887786504efea1177abd7e69329a8e5ea619e"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/7d/66/3cd990e19ab6865960a29756dc43c1ab175886bb800cb673adbc33d75db7/paramiko-1.18.2.tar.gz"
    sha256 "f49daba38450f36f74e744a9dd1e5452c861623a2f565d80e975335d8f815435"
  end

  resource "parse" do
    url "https://files.pythonhosted.org/packages/ae/87/f7fc0cdf512f45e69faf59eb29459f83f39537f5e538300b23013a03d886/parse-1.8.0.tar.gz"
    sha256 "8b4f28bbe7c0f24981669ea92b2ba704ee63b5346027e82be30118bb5788ff10"
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
    url "https://files.pythonhosted.org/packages/35/a5/3d1beff9fc149b3da814419369a8c24ecf0d1410637fc91002989f433a1a/pbr-2.0.0.tar.gz"
    sha256 "0ccd2db529afd070df815b1521f01401d43de03941170f8a800e7531faba265d"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/0c/d6/b1fe519846a21614fa4f8233361574eddb223e0bc36b182140d916acfb3b/pyOpenSSL-16.2.0.tar.gz"
    sha256 "7779a3bbb74e79db234af6a08775568c6769b5821faecf6e2f4143edb227516e"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz"
    sha256 "0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04"
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
    url "https://files.pythonhosted.org/packages/b1/17/97868578071068fe7d115672b52624d421ff24e5e802f65d6bf3ea184e8f/ruamel.ordereddict-0.4.9.tar.gz"
    sha256 "7058c470f131487a3039fb9536dda9dd17004a7581bdeeafa836269a36a2b3f6"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/e1/fe/0021f94b54f7aa5a730b765f5a4eead9675be98c7f46c206c240fb9ef819/ruamel.yaml-0.10.23.tar.gz"
    sha256 "895347f81297f5542e1071092c6760ed13d86547764ebbaedbc2972eb8385dd8"
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

  resource "wsgi_intercept" do
    url "https://files.pythonhosted.org/packages/72/66/fc379742505328ace546e01e81c1a01a7a6284e1f08129035e543df1d0fd/wsgi_intercept-1.5.0.tar.gz"
    sha256 "ada141cff264edc5e90b1f8894b2e87e6a2c12214bba0d3c3c6dd311ae42b359"
  end

  resource "zope.interface" do
    url "https://files.pythonhosted.org/packages/44/af/cea1e18bc0d3be0e0824762d3236f0e61088eeed75287e7b854d65ec9916/zope.interface-4.3.3.tar.gz"
    sha256 "8780ef68ca8c3fe1abb30c058a59015129d6e04a6b02c2e56b9c7de6078dfa88"
  end

  def install
    ENV.prepend "CPPFLAGS", "-I#{MacOS.sdk_path}/usr/include/ffi"

    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/charm-version"
  end
end
