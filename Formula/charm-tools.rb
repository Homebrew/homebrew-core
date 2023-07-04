class CharmTools < Formula
  include Language::Python::Virtualenv

  desc "Tools for authoring and maintaining juju charms"
  homepage "https://github.com/juju/charm-tools"
  url "https://files.pythonhosted.org/packages/0f/ea/5fa9e1a11e560314e119765b9c7c32a9ffa85caf51769f3d8f812cbc9237/charm-tools-3.0.6.tar.gz"
  sha256 "e783d701d1e32d7b3b356d48238381d0f1f8aa2891d8548d48a921e778825b69"
  license "GPL-3.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "efd4e567fe4b008728bede5c3783bacfaaa3b21b2e6a0727767a82d922138e64"
    sha256 cellar: :any,                 arm64_monterey: "67ad1c0afd01f41d488dc2f25ed0bae1012ba512a16986492542695f52dfbb44"
    sha256 cellar: :any,                 arm64_big_sur:  "11358e0bbd9ac297458b659226bb467fc1b43137221caa61eb094fd2f09a7dd3"
    sha256 cellar: :any,                 ventura:        "b0d981fea38fc16e43871555f9d3656924312d47df28ac31df9bfea3b5d71010"
    sha256 cellar: :any,                 monterey:       "0b3536a9c38621538b5e46ae4f7b1964c188d5fbef55b69fd04b23972ce3235d"
    sha256 cellar: :any,                 big_sur:        "9d374cf8a28c6d8ebd2ff26ab76f5eec9ca70b02322a5198d3e8eabca4df59b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41725d65ef337687832fa04b08d5264b7eeff15a68a6448d2da030726372777e"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "charm"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "python@3.11"
  depends_on "six"

  on_linux do
    depends_on "gmp"
  end

  # Needs pip<23
  resource "pip" do
    url "https://files.pythonhosted.org/packages/a3/50/c4d2727b99052780aad92c7297465af5fe6eec2dbae490aa9763273ffdc1/pip-22.3.1.tar.gz"
    sha256 "65fd48317359f3af8e593943e6ae1506b66325085ea64b706a998c6e83eeaf38"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "blessings" do
    url "https://files.pythonhosted.org/packages/5c/f8/9f5e69a63a9243448350b44c87fae74588aa634979e6c0c501f26a4f6df7/blessings-1.7.tar.gz"
    sha256 "98e5854d805f50a5b58ac2333411b0482516a8210f23f43308baeb58d77c157d"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "cheetah3" do
    url "https://files.pythonhosted.org/packages/23/33/ace0250068afca106c1df34348ab0728e575dc9c61928d216de3e381c460/Cheetah3-3.2.6.post1.tar.gz"
    sha256 "58b5d84e5fbff6cf8e117414b3ea49ef51654c02ee887d155113c5b91d761967"
  end

  resource "colander" do
    url "https://files.pythonhosted.org/packages/fa/3c/592bbb25f6199234167d713c220044473e2e57906d7ad7a34e13b7dc1144/colander-1.8.3.tar.gz"
    sha256 "259592a0d6a89cbe63c0c5771f9c0c2522387415af8d715f599583eac659f7d4"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/19/8c/47f061de65d1571210dc46436c14a0a4c260fd0f3eaf61ce9b9d445ce12f/cryptography-41.0.1.tar.gz"
    sha256 "d34579085401d3f49762d2f7d6634d6b6c2ae1242202e860f4d26b046e3a1006"
  end

  resource "dict2colander" do
    url "https://files.pythonhosted.org/packages/aa/7e/5ed2ba3dc2f06457b76d4bc8c93559179472bf87e6982f9a9e5cea30e84e/dict2colander-0.2.tar.gz"
    sha256 "6f668d60896991dcd271465b755f00ffd6f87f81e0d4d054be62a16c086978c7"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/00/0b/c506e9e44e4c4b6c89fcecda23dc115bf8e7ff7eb127e0cb9c114cbc9a15/filelock-3.12.2.tar.gz"
    sha256 "002740518d8aa59a26b0c76e10fb8c6e15eae825d34b6fdf670333fd7b938d81"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/a3/82/f6e29c8d5c098b6be61460371c2c5591f4a335923639edec43b3830650a4/importlib_metadata-6.7.0.tar.gz"
    sha256 "1aaf550d4f73e5d6783e7acb77aec43d49da8017410afae93822cc9cca98c4d4"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/27/23/97cd1cb5792ece594ec5cf16cc4921f91838c689c82c8078ee442751f8dc/iso8601-2.0.0.tar.gz"
    sha256 "739960d37c74c77bd9bd546a76562ccb581fe3d4820ff5c3141eb49c839fda8f"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/bf/02/a956c9bfd2dfe60b30c065ed8e28df7fcf72b292b861dca97e951c145ef6/jaraco.classes-3.2.3.tar.gz"
    sha256 "89559fa5c1d3c34eff6f631ad80bb21f378dbcbb35dd161fd2c6b93f5be2f98a"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/d6/f4/154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdf/jeepney-0.8.0.tar.gz"
    sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "jujubundlelib" do
    url "https://files.pythonhosted.org/packages/57/57/039c6b7e6a01df336f38549eec0836b61166f012528449e37a0ced4e9ddc/jujubundlelib-0.5.7.tar.gz"
    sha256 "7e2b1a679faab13c4d56256e31e0cc616d55841abd32598951735bf395ca47e3"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/55/fe/282f4c205add8e8bb3a1635cbbac59d6def2e0891b145aa553a0e40dd2d0/keyring-23.13.1.tar.gz"
    sha256 "ba2e15a9b35e21908d0aaf4e0a47acc52d6ae33444df0da2b49d41a46ef6d678"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/2e/d0/bea165535891bd1dcb5152263603e902c0ec1f4c9a2e152cc4adff6b3a38/more-itertools-9.1.0.tar.gz"
    sha256 "cabaa341ad0389ea83c17a94566a53ae4c9d07349861ecb14dc6d0345cf9ac5d"
  end

  resource "otherstuf" do
    url "https://files.pythonhosted.org/packages/4f/b5/fe92e1d92610449f001e04dd9bf7dc13b8e99e5ef8859d2da61a99fc8445/otherstuf-1.1.0.tar.gz"
    sha256 "7722980c3b58845645da2acc838f49a1998c8a6bdbdbb1ba30bcde0b085c4f4c"
  end

  resource "parse" do
    url "https://files.pythonhosted.org/packages/29/d9/a874f3b01b618dae366de5d18c529d961dddf58eccca5c99ba691040325e/parse-1.19.1.tar.gz"
    sha256 "cc3a47236ff05da377617ddefa867b7ba983819c664e1afe46249e5b469be464"
  end

  resource "path" do
    url "https://files.pythonhosted.org/packages/0a/52/94faab34ea4ddff296d99d32d16a7c342f70b1cd0f1d1d65b49e2a04b7a6/path-16.6.0.tar.gz"
    sha256 "bea3816e1d54f4e33aac78d2031a0b0ed2f95e69db85b45d51f17df97071da69"
  end

  resource "path-py" do
    url "https://files.pythonhosted.org/packages/b6/e3/81be70016d58ade0f516191fa80152daba5453d0b07ce648d9daae86a188/path.py-12.5.0.tar.gz"
    sha256 "8d885e8b2497aed005703d94e0fd97943401f035e42a136810308bff034529a8"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/32/1a/6baf904503c3e943cae9605c9c88a43b964dea5b59785cf956091b341b08/pathspec-0.10.3.tar.gz"
    sha256 "56200de4077d9d0791465aa9095a01d421861e405b5096955051deefd697d6f6"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cb/10/e5478cc0c3ee5563f91ab7b9da15d16e21f3737b6286ed3fd9a8fb1a99dd/platformdirs-3.8.0.tar.gz"
    sha256 "b0cabcb11063d21a0b261d557acb0a9d2126350e63b70cdf7db6347baea456dc"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/bf/90/445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89/pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requirements-parser" do
    url "https://files.pythonhosted.org/packages/c2/f9/76106e710015f0f8da37bff8db378ced99ae2553cc4b1cffb0aef87dc4ac/requirements-parser-0.5.0.tar.gz"
    sha256 "3336f3a3ae23e06d3f0f88595e4052396e3adf91688787f637e5d2ca1a904069"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/63/dd/b4719a290e49015536bd0ab06ab13e3b468d8697bec6c2f668ac48b05661/ruamel.yaml-0.17.32.tar.gz"
    sha256 "ec939063761914e14542972a5cba6d33c23b0859ab6342f61cf070cfc600efc2"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/d5/31/a3e6411947eb7a4f1c669f887e9e47d61a68f9d117f10c3c620296694a0b/ruamel.yaml.clib-0.2.7.tar.gz"
    sha256 "1f08fd5a2bea9c4180db71678e850b995d2a5f4537be0e94557668cf0f5f9497"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/53/a4/f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691/SecretStorage-3.3.3.tar.gz"
    sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
  end

  resource "stuf" do
    url "https://files.pythonhosted.org/packages/76/62/171e06b6d2d3072ea333de19632c61a44f83199e20cbf4924d12827cf66a/stuf-0.9.16.tar.bz2"
    sha256 "e61d64a2180c19111e129d36bfae66a0cb9392e1045827d6495db4ac9cb549b0"
  end

  resource "translationstring" do
    url "https://files.pythonhosted.org/packages/14/39/32325add93da9439775d7fe4b4887eb7986dbc1d5675b0431f4531f560e5/translationstring-1.4.tar.gz"
    sha256 "bf947538d76e69ba12ab17283b10355a9ecfbc078e6123443f43f2107f6376f3"
  end

  resource "types-setuptools" do
    url "https://files.pythonhosted.org/packages/02/3a/a2cc23768db03109c2005d425261ce3665e6f084c35de7b681e78542d1b6/types-setuptools-68.0.0.0.tar.gz"
    sha256 "fc958b4123b155ffc069a66d3af5fe6c1f9d0600c35c0c8444b2ab4147112641"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/d6/af/3b4cfedd46b3addab52e84a71ab26518272c23c77116de3c61ead54af903/urllib3-2.0.3.tar.gz"
    sha256 "bee28b5e56addb8226c96f7f13ac28cb4c301dd5ea8a6ca179c0b9835e032825"
  end

  resource "vergit" do
    url "https://files.pythonhosted.org/packages/d8/dc/2ef077a97a05633bbe7a46b9cb4b87fbf994a9aaa52b44a8f1086d20951f/vergit-1.0.2.tar.gz"
    sha256 "ea82a4d6057d4891a4b16e0881bd756ceea2b66253edc05dd619450f88a5ff31"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/21/6b/0910aebe4d5c2a27d5a79ab8fae06d22f7e01dff46baf29ced8d080134c3/virtualenv-20.23.1.tar.gz"
    sha256 "8ff19a38c1021c742148edc4f81cb43d7f8c6816d2ede2ab72af5b84c749ade1"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/fc/ef/0335f7217dd1e8096a9e8383e1d472aa14717878ffe07c4772e68b6e8735/wheel-0.40.0.tar.gz"
    sha256 "cd1196f3faee2b31968d626e1731c94f99cbdb67cf5a46e4f5656cbee7738873"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/00/27/f0ac6b846684cecce1ee93d32450c45ab607f65c2e0255f0092032d91f07/zipp-3.15.0.tar.gz"
    sha256 "112929ad649da941c23de50f356a2b5570c954b65150642bccdd66bf194d224b"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/charm-version"
  end
end
