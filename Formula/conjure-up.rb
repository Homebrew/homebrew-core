class ConjureUp < Formula
  include Language::Python::Virtualenv

  desc "Big software deployments so easy it's almost magical"
  homepage "https://conjure-up.io/"
  url "https://github.com/conjure-up/conjure-up/archive/2.6.7.tar.gz"
  sha256 "997a08c5f0bec19399c9c5ab214447c34b3e0a76df700b6125e18cb4e30e07a9"
  revision 1

  bottle do
    cellar :any
    sha256 "7f53828461b7f12babe82615d7b2c76eb6dce20a2e92a25d7da4cb44e496bf4d" => :mojave
    sha256 "d6d1c1aa6c055326581d55a15f5cd4f0173bf5cd3163cda2dbbdc6836a21be2d" => :high_sierra
    sha256 "92c6564310861de3332362904bc7eb14f571dbf2c52457cf33f7727929416782" => :sierra
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
    url "https://files.pythonhosted.org/packages/94/c2/e3cb60c1b7d9478203d4514e2d33ea424ad9bb98e45b21d6225db93f25c9/aiofiles-0.4.0.tar.gz"
    sha256 "021ea0ba314a86027c166ecc4b4c07f2d40fc0f4b3a950d1868a0f2571c2bbee"
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
    url "https://files.pythonhosted.org/packages/06/b8/d1ea38513c22e8c906275d135818fee16ad8495985956a9b7e2bb21942a1/certifi-2019.3.9.tar.gz"
    sha256 "b26104d6835d1f5e49452a26eb2ff87fe7090b89dfcaee5ea2212697e1e1d7ae"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/64/7c/27367b38e6cc3e1f49f193deb761fe75cda9f95da37b67b422e62281fcac/cffi-1.12.2.tar.gz"
    sha256 "e113878a446c6228669144ae8a56e268c91b7f1fafae927adc4879d9849e0ea7"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/07/ca/bc827c5e55918ad223d59d299fff92f3563476c3b00d0a9157d9c0217449/cryptography-2.6.1.tar.gz"
    sha256 "26c821cbeb683facb966045e2064303029d572a87ee69ca5a1bf54bf55f93ca6"
  end

  resource "env" do
    url "https://github.com/battlemidget/env/archive/1.0.0.tar.gz"
    sha256 "a26b5c973df792ecfc1fc6b18cf696ccaf4c02c918b2878e81c6d495debaa340"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/56/e6/332789f295cf22308386cf5bbd1f4e00ed11484299c5d7383378cf48ba47/Jinja2-2.10.tar.gz"
    sha256 "f84be1bb0040caca4cea721fcbbbbd61f9be9464ca236387158b0feea01914a4"
  end

  resource "juju" do
    url "https://files.pythonhosted.org/packages/ec/89/657d4cb0f1808c74137362454453f77d129ae24cb61ab15c29927553957f/juju-0.11.3.tar.gz"
    sha256 "491f9fc2a92a72159a4878b624db3d58ea81e3a105f486cbe50d51818ff6bdf8"
  end

  resource "juju-wait" do
    url "https://files.pythonhosted.org/packages/4c/ee/1a4b3298afd01f276e37dbd3f8d5a42478fb049f08f6255ca2742f7aab9f/juju-wait-2.6.4.tar.gz"
    sha256 "c1dd38c2525fc26d1e89739f9a932aebfd2c1e238e96c980f26527522e7111bf"
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
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
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
    url "https://files.pythonhosted.org/packages/12/1b/aea82bf4bd420405c78fa9b1c5782702bb86fc99b673c0603af0f3393f46/progressbar2-3.39.3.tar.gz"
    sha256 "8e5b5419e04193bb7c3fea71579937bbbcd64c26472b929718c2fe7ec420fe39"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/cf/72/8c1ed9148ded82adbb76c30f958c6d456a2abc08f092b62a586bdf973b80/protobuf-3.7.1.tar.gz"
    sha256 "21e395d7959551e759d604940a115c51c6347d90a475c9baf471a1a86b5604a9"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2f/b8/11ec5006d2ec2998cb68349b8d1317c24c284cf918ecd6729739388e4c56/psutil-5.6.1.tar.gz"
    sha256 "fa0a570e0a30b9dd618bffbece590ae15726b47f9f1eaf7518dfb35f4d7dcd21"
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
    url "https://files.pythonhosted.org/packages/71/24/0bb1257b3bc89f7b2facdbad91cc56902d116d649a263c242ef32f73110e/pyvmomi-6.7.1.2018.12.zip"
    sha256 "653f978fd14474a1d3ffc22b1fdffa8a406987ada4ef6d13d96a37ef4b038891"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  resource "raven" do
    url "https://files.pythonhosted.org/packages/79/57/b74a86d74f96b224a477316d418389af9738ba7a63c829477e7a86dd6f47/raven-6.10.0.tar.gz"
    sha256 "3fa6de6efa2493a7c827472e984ce9b020797d0da16f1db67197bcc23c8fae54"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/52/2c/514e4ac25da2b08ca5a464c50463682126385c4272c18193876e91f4bc38/requests-2.21.0.tar.gz"
    sha256 "502a824f31acdacb3a35b6690b5fbf0bc41d63a24a45c4004352b0242707598e"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/de/a2/f55312dfe2f7a344d0d4044fdfae12ac8a24169dc668bd55f72b27090c32/requests-oauthlib-1.2.0.tar.gz"
    sha256 "bd6533330e8748e94bf0b214775fed487d309b8b8fe823dc45641ebcd9a32f57"
  end

  resource "sh" do
    url "https://files.pythonhosted.org/packages/7c/71/199d27d3e7e78bf448bcecae0105a1d5b29173ffd2bbadaa95a74c156770/sh-1.12.14.tar.gz"
    sha256 "b52bf5833ed01c7b5c5fb73a7f71b3d98d48e9b9b8764236237bdc7ecae850fc"
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
    url "https://files.pythonhosted.org/packages/b1/53/37d82ab391393565f2f831b8eedbffd57db5a718216f82f1a8b4d381a1c1/urllib3-1.24.1.tar.gz"
    sha256 "de9529817c93f27c8ccbfead6985011db27bd0ddfcdb2d86f3f663385c6a9c22"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/c7/90/415728875c230fafd13d118512bde3184d810d7bf798a631abc05fac09d0/urwid-2.0.1.tar.gz"
    sha256 "644d3e3900867161a2fc9287a9762753d66bd194754679adb26aede559bcccbc"
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
