class ConjureUp < Formula
  include Language::Python::Virtualenv

  desc "Big software deployments so easy it's almost magical"
  homepage "https://conjure-up.io/"
  url "https://github.com/conjure-up/conjure-up/archive/2.6.9.tar.gz"
  sha256 "b5ebba187d27b3474b36acd715df015b198c0e5df8aefb32200ba4f3f3de17f4"

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
    url "https://files.pythonhosted.org/packages/fa/aa/025a3ab62469b5167bc397837c9ffc486c42a97ef12ceaa6699d8f5a5416/bcrypt-3.1.7.tar.gz"
    sha256 "0b0069c752ec14172c5f78208f1863d7ad6755a6fae6fe76ec2c80d13be41e42"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/62/85/7585750fd65599e88df0fed59c74f5075d4ea2fe611deceb95dd1c2fb25b/certifi-2019.9.11.tar.gz"
    sha256 "e4f3620cfea4f83eedc95b24abd9cd56f3c4b146dd0177e83a21b4eb49e21e50"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/93/1a/ab8c62b5838722f29f3daffcc8d4bd61844aa9b5f437341cc890ceee483b/cffi-1.12.3.tar.gz"
    sha256 "041c81822e9f84b1d9c401182e174996f0bae9991f33725d059b771744290774"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/c2/95/f43d02315f4ec074219c6e3124a87eba1d2d12196c2767fadfdc07a83884/cryptography-2.7.tar.gz"
    sha256 "e6347742ac8f35ded4a46ff835c60e68c22a536a8ae5c4422966d06946b6d4c6"
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
    url "https://files.pythonhosted.org/packages/93/ea/d884a06f8c7f9b7afbc8138b762e80479fb17aedbbe2b06515a12de9378d/Jinja2-2.10.1.tar.gz"
    sha256 "065c4f02ebe7f7cf559e49ee5a95fb800a9e4528727aec6f24402a5374c65013"
  end

  resource "juju" do
    url "https://files.pythonhosted.org/packages/18/f2/714e253e7a8a0c697b2ccd11bc42622cf4aca69eaa599e00e8aa976cb540/juju-2.6.3.tar.gz"
    sha256 "cbf0ed3c317dc98b307f74ff1cb99978857c008aeb05d8206c7313a28fdc207e"
  end

  resource "juju-wait" do
    url "https://files.pythonhosted.org/packages/d6/01/381cc24aabf820ff306b738a01b11aed5ac365a6438d46792f9fee2fe5f8/juju-wait-2.7.0.tar.gz"
    sha256 "1e00cb75934defa50a2cc404574d4b633049f1fa011a197dfac33e3071840e98"
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
    url "https://files.pythonhosted.org/packages/d0/22/ca60ef57ad0ea904292daaa1cb0f1e991303667f70794a97674f4a3695fa/macaroonbakery-1.2.3.tar.gz"
    sha256 "bd27e7d2d98cb3dc1973d7b67b2a0c475fb005c0f9c35c04dbf9b272e98939ec"
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
    url "https://files.pythonhosted.org/packages/fc/c7/829c73c64d3749da7811c06319458e47f3461944da9d98bb4df1cb1598c2/oauthlib-3.1.0.tar.gz"
    sha256 "bee41cc35fcca6e988463cacc3bcb8a96224f470ca547e697b604cc697b2f889"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/54/68/dde7919279d4ecdd1607a7eb425a2874ccd49a73a5a71f8aa4f0102d3eb8/paramiko-2.6.0.tar.gz"
    sha256 "f4b2edfa0d226b70bd4ca31ea7e389325990283da23465d572ed1f70a7583041"
  end

  resource "PrettyTable" do
    url "https://files.pythonhosted.org/packages/ef/30/4b0746848746ed5941f052479e7c23d2b56d174b82f4fd34a25e389831f5/prettytable-0.7.2.tar.bz2"
    sha256 "853c116513625c738dc3ce1aee148b5b5757a86727e67eff6502c7ca59d43c36"
  end

  resource "progressbar2" do
    url "https://files.pythonhosted.org/packages/d1/5f/a370a1e05589665bcdb98ea3b270eed99d7c4c6d8ff56438ef1e564b3057/progressbar2-3.47.0.tar.gz"
    sha256 "7538d02045a1fd3aa2b2834bfda463da8755bd3ff050edc6c5ddff3bc616215f"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/7d/d0/473a91ac2c59639b9fe2f3248d98b4d6084d4be8254a7b83f010feac8de9/protobuf-3.9.2.tar.gz"
    sha256 "843f498e98ad1469ad54ecb4a7ccf48605a1c5d2bd26ae799c7a2cddab4a37ec"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/1c/ca/5b8c1fe032a458c2c4bcbe509d1401dca9dda35c7fc46b36bb81c2834740/psutil-5.6.3.tar.gz"
    sha256 "863a85c1c0a5103a12c05a35e59d336e1d665747e531256e061213e2e90f63f3"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ca/f8/2a60a2c88a97558bdd289b6dc9eb75b00bd90ff34155d681ba6dbbcb46b2/pyasn1-0.4.7.tar.gz"
    sha256 "a9495356ca1d66ed197a0f72b41eb1823cf7ea8b5bd07191673e8147aecf8604"
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
    url "https://files.pythonhosted.org/packages/27/c0/fbd352ca76050952a03db776d241959d5a2ee1abddfeb9e2a53fdb489be4/pytz-2019.2.tar.gz"
    sha256 "26c0b32e437e54a18161324a2fca3c4b9846b74a8dccddd843113109e1116b32"
  end

  resource "pyvmomi" do
    url "https://files.pythonhosted.org/packages/eb/87/ebf153a3aafdac7c54c5578b6240d7930a8c0a1a21bdd98d271fd131673c/pyvmomi-6.7.3.tar.gz"
    sha256 "d639d09eb3c7b118bc83b48472c27a4567dcc128dac0ac25ee2c03ed6afbe584"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/e3/e8/b3212641ee2718d556df0f23f78de8303f068fe29cdaa7a91018849582fe/PyYAML-5.1.2.tar.gz"
    sha256 "01adf0b6c6f61bd11af6e10ca52b7d4057dd0be0343eb9283c878cf3af56aee4"
  end

  resource "raven" do
    url "https://files.pythonhosted.org/packages/79/57/b74a86d74f96b224a477316d418389af9738ba7a63c829477e7a86dd6f47/raven-6.10.0.tar.gz"
    sha256 "3fa6de6efa2493a7c827472e984ce9b020797d0da16f1db67197bcc23c8fae54"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/01/62/ddcf76d1d19885e8579acb1b1df26a852b03472c0e46d2b959a714c90608/requests-2.22.0.tar.gz"
    sha256 "11e007a8a2aa0323f5a921e9e6a2d7e4e67d9877e85773fba9ba6419025cbeb4"
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

  resource "toposort" do
    url "https://files.pythonhosted.org/packages/e5/d8/9bc1598ddf74410beba243ffeaee8d0b3ca7e9ac5cefe77367da497433e1/toposort-1.5.tar.gz"
    sha256 "dba5ae845296e3bf37b042c640870ffebcdeb8cd4df45adaa01d8c5476c557dd"
  end

  resource "ubuntui" do
    url "https://files.pythonhosted.org/packages/e8/18/a8cf8f69de1b5bfc135bec5f46a14832e3f9eae3abf7b7978602dc49ed4b/ubuntui-0.1.9.tar.gz"
    sha256 "7249c2bfbdfe5bc4f86ac7a94fe606064f8f068f1436de35cca71b6cd6f57c78"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ff/44/29655168da441dff66de03952880c6e2d17b252836ff1aa4421fba556424/urllib3-1.25.6.tar.gz"
    sha256 "9a107b99a5393caf59c7aa3c1249c16e6879447533d0887f4336dde834c7be86"
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
    assert_match "conjure-up #{version}", shell_output("#{bin}/conjure-up --version")
    system bin/"conjure-up", "openstack-base", "metal", "--show-env"
    assert_predicate testpath/".cache/conjure-up-spells/spells-index.yaml",
                     :exist?
  end
end
