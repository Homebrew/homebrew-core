class ConjureUp < Formula
  include Language::Python::Virtualenv

  desc "Big software deployments so easy it's almost magical"
  homepage "https://conjure-up.io/"
  url "https://github.com/conjure-up/conjure-up/archive/2.6.5.tar.gz"
  sha256 "c890d92159d0abefe3d8fdeef2c92c6ba41558cd4460230ea0b86d698b7438d4"

  bottle do
    cellar :any
    sha256 "b954756a2d91131e29eec68786b42e9b1198a5ef59a25a8186383f750aff80a3" => :mojave
    sha256 "08fc76a19929526299af0bab676a5960c7c63619327eae78cbe48cdd07a07d17" => :high_sierra
    sha256 "c29d36b1b45a21243ff015a4da1a1d7b29767cc6b6da5b39e51d32d556742c31" => :sierra
  end

  depends_on "awscli"
  depends_on "jq"
  depends_on "juju"
  depends_on "juju-wait"
  depends_on "libyaml"
  depends_on "pwgen"
  depends_on "python"
  depends_on "redis"

  # list generated from the 'requirements.txt' file in the repository root
  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/28/51/913ed4312b63b0a1b6cad5a761b2c163eb20e353c7a3f19f08e04e8675e5/aiofiles-0.3.1.tar.gz"
    sha256 "6c4936cea65175277183553dbc27d08b286a24ae5bd86f44fbe485dfcf77a14a"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/fc/f1/8db7daa71f414ddabfa056c4ef792e1461ff655c2ae2928a2b675bfed6b4/asn1crypto-0.24.0.tar.gz"
    sha256 "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/ce/3a/3d540b9f5ee8d92ce757eebacf167b9deedb8e30aedec69a2a072b2399bb/bcrypt-3.1.6.tar.gz"
    sha256 "44636759d222baa62806bbceb20e96f75a015a6381690d1bc2eda91c01ec02ea"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/55/54/3ce77783acba5979ce16674fc98b1920d00b01d337cfaaf5db22543505ed/certifi-2018.11.29.tar.gz"
    sha256 "47f9c83ef4c0c621eaef743f133f09fa8a74a9b75f037e8624f83bd1b6626cb7"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/e7/a7/4cd50e57cc6f436f1cc3a7e8fa700ff9b8b4d471620629074913e3735fb2/cffi-1.11.5.tar.gz"
    sha256 "e90f17980e6ab0f3c2f3730e56d1fe9bcba1891eeea58966e89d352492cc74f4"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/69/ed/5e97b7f54237a9e4e6291b6e52173372b7fa45ca730d36ea90b790c0059a/cryptography-2.5.tar.gz"
    sha256 "4946b67235b9d2ea7d31307be9d5ad5959d6c4a8f98f900157b47abddf698401"
  end

  resource "env" do
    url "https://github.com/battlemidget/env/archive/1.0.0.tar.gz"
    sha256 "a26b5c973df792ecfc1fc6b18cf696ccaf4c02c918b2878e81c6d495debaa340"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/90/61/f820ff0076a2599dd39406dcb858ecb239438c02ce706c8e91131ab9c7f1/Jinja2-2.9.6.tar.gz"
    sha256 "ddaa01a212cd6d641401cb01b605f4a4d9f37bfc93043d7f760ec70fb99ff9ff"
  end

  resource "juju" do
    url "https://files.pythonhosted.org/packages/85/4b/5c2699d8b4b50b4ce3319b308c4daade42288025769c7c8273d4d20b019e/juju-0.11.2.tar.gz"
    sha256 "d286b9a9fed710685c7864bb832e1b8afe24c1dce6f5ad9dff64c2c2f526e0fe"
  end

  resource "juju-wait" do
    url "https://files.pythonhosted.org/packages/e4/34/a40b2df17343f75b6befd814b031f9fd37d61ffc309bd711fdbdb2c01eae/juju-wait-2.6.3.tar.gz"
    sha256 "52228937c6feffaa888aa286f40ce7601258ddc3a71264d466b3b809d9242c02"
  end

  resource "jujubundlelib" do
    url "https://files.pythonhosted.org/packages/fe/6c/a70cd143c77c3a5d6935e6b9e46261e8cab4db7911691650d0bbde8a1a78/jujubundlelib-0.5.6.tar.gz"
    sha256 "80e4fbc2b8593082f57de03703df8c5ba69ed1cf73519d499f5d49c51ec91949"
  end

  resource "kv" do
    url "https://files.pythonhosted.org/packages/c7/02/69ad28c7669bb1cebc0ca1bb92eaf07f6b3b67c4f79cf1dcc5082f18d7a4/kv-0.3.tar.gz"
    sha256 "d40755e7358e2b2a624feb9e442b06168b04cf14abf4d7aa749725dfbc5034e5"
  end

  resource "macaroonbakery" do
    url "https://files.pythonhosted.org/packages/44/c9/1d5824fd56fe591fc3c2cb2bc6cc49ee0ed96e656e2909ea715ad3846b7f/macaroonbakery-1.2.1.tar.gz"
    sha256 "7fa9ae3e9ac3678623544c75393da23dd51da4ccef4a6726e07011fd65fc8285"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/ac/7e/1b4c2e05809a4414ebce0892fe1e32c14ace86ca7d50c70f00979ca9b3a3/MarkupSafe-1.1.0.tar.gz"
    sha256 "4e97332c9ce444b0c2c38dd22ddc61c743eb208d916e4265a2a3b575bdccb1d3"
  end

  resource "melddict" do
    url "https://files.pythonhosted.org/packages/89/99/c2dd9897264764544cb02de5fe0ffc277c091e973908b0894abe8900be7a/melddict-1.0.1.tar.gz"
    sha256 "70ad91f4a7fb7ee32498e828604fe10c6ceb68a5779ca9d41e5469a6c24826ea"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/ec/90/882f43232719f2ebfbdbe8b7c57fc9642a25b3df30cb70a3701ea22622de/oauthlib-3.0.1.tar.gz"
    sha256 "0ce32c5d989a1827e3f1148f98b9085ed2370fc939bf524c9c851d8714797298"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/a4/57/86681372e7a8d642718cadeef38ead1c24c4a1af21ae852642bf974e37c7/paramiko-2.4.2.tar.gz"
    sha256 "a8975a7df3560c9f1e2b43dc54ebd40fd00a7017392ca5445ce7df409f900fcb"
  end

  resource "PrettyTable" do
    url "https://files.pythonhosted.org/packages/ef/30/4b0746848746ed5941f052479e7c23d2b56d174b82f4fd34a25e389831f5/prettytable-0.7.2.tar.bz2"
    sha256 "853c116513625c738dc3ce1aee148b5b5757a86727e67eff6502c7ca59d43c36"
  end

  resource "progressbar2" do
    url "https://files.pythonhosted.org/packages/ab/d1/44d8235bac6fca2480f256a47630aa759638f3d6ad4d3ebe8ec0ae38409d/progressbar2-3.20.0.tar.gz"
    sha256 "a16d34da27bfa9800605f1de3342138e102797a4b8198864c8822e94caa0e5f7"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/1b/90/f531329e628ff34aee79b0b9523196eb7b5b6b398f112bb0c03b24ab1973/protobuf-3.6.1.tar.gz"
    sha256 "1489b376b0f364bcc6f89519718c057eb191d7ad6f1b395ffd93d1aa45587811"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/57/93/47a2e3befaf194ccc3d05ffbcba2cdcdd22a231100ef7e4cf63f085c900b/psutil-5.2.2.tar.gz"
    sha256 "44746540c0fab5b95401520d29eb9ffe84b3b4a235bd1d1971cbe36e1f38dd13"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/46/60/b7e32f6ff481b8a1f6c8f02b0fd9b693d1c92ddd2efb038ec050d99a7245/pyasn1-0.4.5.tar.gz"
    sha256 "da2420fe13a9452d8ae97a0e478adde1dee153b11ba832a95b223a2ba01c10f7"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
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

  resource "python-utils" do
    url "https://files.pythonhosted.org/packages/30/95/d01fbd09ced38a16b7357a1d6cefe1327b9273885bffd6371cbec3e23af7/python-utils-2.3.0.tar.gz"
    sha256 "34aaf26b39b0b86628008f2ae0ac001b30e7986a8d303b61e1357dfcdad4f6d3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/af/be/6c59e30e208a5f28da85751b93ec7b97e4612268bb054d0dff396e758a90/pytz-2018.9.tar.gz"
    sha256 "d5f05e487007e29e03409f9398d074e158d920d36eb82eaf66fb1136b0c5374c"
  end

  resource "pyvmomi" do
    url "https://files.pythonhosted.org/packages/95/82/40f8c37a4c5264a2d581c24eb5f191cbdfe7f574d4013180edc84bbbf401/pyvmomi-6.5.0.2017.5-1.tar.gz"
    sha256 "c28292594281901e894c39a0c06b4126a9c019b3d804c47fb116472299dbb42d"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  resource "raven" do
    url "https://files.pythonhosted.org/packages/8f/80/e8d734244fd377fd7d65275b27252642512ccabe7850105922116340a37b/raven-6.9.0.tar.gz"
    sha256 "3fd787d19ebb49919268f06f19310e8112d619ef364f7989246fc8753d469888"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/80/14/ad120c720f86c547ba8988010d5186102030591f71f7099f23921ca47fe5/requests-oauthlib-0.8.0.tar.gz"
    sha256 "883ac416757eada6d3d07054ec7092ac21c7f35cb1d2cf82faf205637081f468"
  end

  resource "sh" do
    url "https://files.pythonhosted.org/packages/d8/97/39aa189a8392522cc24f14f392955cbeac48e2818d776241c37eb6d0eb3c/sh-1.12.13.tar.gz"
    sha256 "979928ca113cade663bb1a0ff710e3eb9147596cf28a7ee4c04f9d85804f7b9f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "theblues" do
    url "https://files.pythonhosted.org/packages/53/8b/fe35c9ffa939db896aaad229e42376fd203d44a86329e8bf4af736aa9982/theblues-0.5.1.tar.gz"
    sha256 "908b4c478fa4907a5e40512a0e78a646792a219ac3343e6cdb412cf29f6be58e"
  end

  resource "ubuntui" do
    url "https://files.pythonhosted.org/packages/e8/18/a8cf8f69de1b5bfc135bec5f46a14832e3f9eae3abf7b7978602dc49ed4b/ubuntui-0.1.9.tar.gz"
    sha256 "7249c2bfbdfe5bc4f86ac7a94fe606064f8f068f1436de35cca71b6cd6f57c78"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/85/5d/9317d75b7488c335b86bd9559ca03a2a023ed3413d0e8bfe18bea76f24be/urwid-1.3.1.tar.gz"
    sha256 "cfcec03e36de25a1073e2e35c2c7b0cc6969b85745715c3a025a31d9786896a1"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/ba/60/59844a5cef2428cb752bd4f446b72095b1edee404a58c27e87cd12a141e2/websockets-7.0.tar.gz"
    sha256 "08e3c3e0535befa4f0c4443824496c03ecc25062debbcf895874f8a0b4c97c9f"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resource("cffi") # needs to be installed prior to bcrypt
    res = resources.map(&:name).to_set - ["cffi"]

    res.each do |r|
      venv.pip_install resource(r)
    end
    venv.pip_install_and_link buildpath
    bin.install_symlink "#{libexec}/bin/kv-cli"
  end

  test do
    assert_match "No spells found, syncing from registry, please wait",
      shell_output("#{bin}/conjure-up openstack-base metal --show-env")
    assert_predicate testpath/".cache/conjure-up-spells/spells-index.yaml",
                     :exist?
  end
end
