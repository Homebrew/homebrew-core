class ConjureUp < Formula
  include Language::Python::Virtualenv

  desc "Big software deployments so easy it's almost magical"
  homepage "https://conjure-up.io/"
  url "https://github.com/conjure-up/conjure-up/archive/2.5.5.tar.gz"
  sha256 "7a16b91c46c1f86eb7bc96597cbdb371ea94d062ff554c71615267cba54f3433"
  revision 2

  bottle do
    cellar :any
    sha256 "27fe4c914e98b5b9e6400ec25ba7586008e0e95504171f86c8b7f9ce5ef46f58" => :high_sierra
    sha256 "b2d5820fc44dbcd58176248bb3bfb5b928541b1a6c63867ecf9b98ba5a84645c" => :sierra
    sha256 "032fdbf6189f7640513d475c3fc1e2658919eb82cd6a9a736aed9b947448c657" => :el_capitan
  end

  depends_on "libyaml"
  depends_on "juju"
  depends_on "juju-wait"
  depends_on "jq"
  depends_on "redis"
  depends_on "awscli"
  depends_on "pwgen"
  depends_on "python"

  # list generated from the 'requirements.txt' file in the repository root
  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/28/51/913ed4312b63b0a1b6cad5a761b2c163eb20e353c7a3f19f08e04e8675e5/aiofiles-0.3.1.tar.gz"
    sha256 "6c4936cea65175277183553dbc27d08b286a24ae5bd86f44fbe485dfcf77a14a"
  end

  resource "bundle-placement" do
    url "https://files.pythonhosted.org/packages/7f/f3/635ef95ac9afb049e721774acbbda39a1a9d2963b10c08cded15bf09ae43/bundle-placement-0.0.2.tar.gz"
    sha256 "3ee288c0d5b889d1a9e04d1c09c9527b471b57a7df1f4898cebb990a6a967b05"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/15/d4/2f888fc463d516ff7bf2379a4e9a552fef7f22a94147655d9b1097108248/certifi-2018.1.18.tar.gz"
    sha256 "edbc3f203427eef571f79a7692bb160a2b0f7ccaa31953e99bd17e307cf63f7d"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/10/f7/3b302ff34045f25065091d40e074479d6893882faef135c96f181a57ed06/cffi-1.11.4.tar.gz"
    sha256 "df9083a992b17a28cd4251a3f5c879e0198bb26c9e808c4647e0a18739f1d11d"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "contextlib2" do
    url "https://files.pythonhosted.org/packages/6e/db/41233498c210b03ab8b072c8ee49b1cd63b3b0c76f8ea0a0e5d02df06898/contextlib2-0.5.5.tar.gz"
    sha256 "509f9419ee91cdd00ba34443217d5ca51f5a364a404e1dce9e8979cea969ca48"
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
    url "https://files.pythonhosted.org/packages/d3/84/54d9be41c75bdaaf40139212a07d8f6f28a2559647e28d5370b994312d28/juju-0.7.3.tar.gz"
    sha256 "07fe467668528bffb18412900ab3a41b091893fbb81f3a39934657f5bb49ad3a"
  end

  resource "juju-wait" do
    url "https://files.pythonhosted.org/packages/e4/34/a40b2df17343f75b6befd814b031f9fd37d61ffc309bd711fdbdb2c01eae/juju-wait-2.6.3.tar.gz"
    sha256 "52228937c6feffaa888aa286f40ce7601258ddc3a71264d466b3b809d9242c02"
  end

  resource "jujubundlelib" do
    url "https://files.pythonhosted.org/packages/f5/79/862a0f62f725ed537e298e04942742a6c0110d2da4404040d77ca3e0d8d5/jujubundlelib-0.5.5.tar.gz"
    sha256 "125383aee2f60af66bb909682aa0757d8e0be083e3f8125473e18a9f3f2d4f3d"
  end

  resource "kv" do
    url "https://files.pythonhosted.org/packages/c7/02/69ad28c7669bb1cebc0ca1bb92eaf07f6b3b67c4f79cf1dcc5082f18d7a4/kv-0.3.tar.gz"
    sha256 "d40755e7358e2b2a624feb9e442b06168b04cf14abf4d7aa749725dfbc5034e5"
  end

  resource "macaroonbakery" do
    url "https://files.pythonhosted.org/packages/c9/90/eb5af47027f17dd3f5e533817089740cec853b343766e988987eff9a0156/macaroonbakery-1.1.2.tar.gz"
    sha256 "d7645b98d5842db08412f8eeeaa3259260524ff5205332cfc3cf8df4b946bdfd"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/4d/de/32d741db316d8fdb7680822dd37001ef7a448255de9699ab4bfcbdf4172b/MarkupSafe-1.0.tar.gz"
    sha256 "a6be69091dac236ea9c6bc7d012beab42010fa914c459791d627dad4910eb665"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/a5/8a/212e9b47fb54be109f3ff0684165bb38c51117f34e175c379fce5c7df754/oauthlib-2.0.6.tar.gz"
    sha256 "ce57b501e906ff4f614e71c36a3ab9eacbb96d35c24d1970d2539bbc3ec70ce1"
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
    url "https://files.pythonhosted.org/packages/14/03/ff5279abda7b46e9538bfb1411d42831b7e65c460d73831ed2445649bc02/protobuf-3.5.1.tar.gz"
    sha256 "95b78959572de7d7fafa3acb718ed71f482932ddddddbd29ba8319c10639d863"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/57/93/47a2e3befaf194ccc3d05ffbcba2cdcdd22a231100ef7e4cf63f085c900b/psutil-5.2.2.tar.gz"
    sha256 "44746540c0fab5b95401520d29eb9ffe84b3b4a235bd1d1971cbe36e1f38dd13"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "pymacaroons" do
    url "https://files.pythonhosted.org/packages/37/b4/52ff00b59e91c4817ca60210c33caf11e85a7f68f7b361748ca2eb50923e/pymacaroons-0.13.0.tar.gz"
    sha256 "1e6bba42a5f66c245adf38a5a4006a99dcc06a0703786ea636098667d42903b8"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/08/19/cf56e60efd122fa6d2228118a9b345455b13ffe16a14be81d025b03b261f/PyNaCl-1.2.1.tar.gz"
    sha256 "e0d38fa0a75f65f556fb912f2c6790d1fa29b7dd27a1d9cc5591b281321eaaa9"
  end

  resource "pyRFC3339" do
    url "https://files.pythonhosted.org/packages/7a/8a/78e04792f04da5f3780058f8cfc35ff9eb74080faffbf321c58e6d34d089/pyRFC3339-1.0.tar.gz"
    sha256 "8dfbc6c458b8daba1c0f3620a8c78008b323a268b27b7359e92a4ae41325f535"
  end

  resource "python-utils" do
    url "https://files.pythonhosted.org/packages/30/95/d01fbd09ced38a16b7357a1d6cefe1327b9273885bffd6371cbec3e23af7/python-utils-2.3.0.tar.gz"
    sha256 "34aaf26b39b0b86628008f2ae0ac001b30e7986a8d303b61e1357dfcdad4f6d3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/60/88/d3152c234da4b2a1f7a989f89609ea488225eaea015bc16fbde2b3fdfefa/pytz-2017.3.zip"
    sha256 "fae4cffc040921b8a2d60c6cf0b5d662c1190fe54d718271db4eb17d44a185b7"
  end

  resource "pyvmomi" do
    url "https://files.pythonhosted.org/packages/95/82/40f8c37a4c5264a2d581c24eb5f191cbdfe7f574d4013180edc84bbbf401/pyvmomi-6.5.0.2017.5-1.tar.gz"
    sha256 "c28292594281901e894c39a0c06b4126a9c019b3d804c47fb116472299dbb42d"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "raven" do
    url "https://files.pythonhosted.org/packages/ee/82/9a85650c174920f5bd260b8138a1db7190156e55193b0a1d03d2fa7a2811/raven-6.1.0.tar.gz"
    sha256 "02cabffb173b99d860a95d4908e8b1864aad1b8452146e13fd7e212aa576a884"
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
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "theblues" do
    url "https://files.pythonhosted.org/packages/ab/09/21a4718cb6f06573153de35af742e4c251ca9b628c9001d06f6ed4b2cae5/theblues-0.3.8.tar.gz"
    sha256 "649f4013d3b9024f7990a7e0b42aed2196daea64a7c8501dde4f1f57ab8aa031"
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
    url "https://files.pythonhosted.org/packages/b6/12/6194aac840c65253e45a38912e318f9ac548f9ba86d75bdb8fe66841b335/websockets-4.0.1.tar.gz"
    sha256 "da4d4fbe059b0453e726d6d993760065d69b823a27efc3040402a6fcfe6a1ed9"
  end

  resource "ws4py" do
    url "https://files.pythonhosted.org/packages/aa/60/5d135c8161a2a67d7c227d57bb599fad967d818dbcdca08daa2d60eb87b9/ws4py-0.3.4.tar.gz"
    sha256 "85d5c01bb0d031e151a32fad56094caf54e20c2ddb51cf25b5709421ff92d007"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink "#{libexec}/bin/kv-cli"
  end

  test do
    assert_match "No spells found, syncing from registry, please wait", shell_output("#{bin}/conjure-up openstack-base metal --show-env")
    assert_predicate testpath/".cache/conjure-up-spells/spells-index.yaml", :exist?
  end
end
