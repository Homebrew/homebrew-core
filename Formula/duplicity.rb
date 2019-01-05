class Duplicity < Formula
  include Language::Python::Virtualenv

  desc "Bandwidth-efficient encrypted backup"
  homepage "https://launchpad.net/duplicity"
  url "https://launchpad.net/duplicity/0.7-series/0.7.18.2/+download/duplicity-0.7.18.2.tar.gz"
  sha256 "c236888f43128e96cd33017b01a2855c0e24738195fed5cadad08c28fd6b6748"

  bottle do
    cellar :any
    sha256 "515c51441302155f7c049f29f52c973f7b833e297f9d580de3192ea62a2e41b6" => :mojave
    sha256 "239ed9c8dd0d9dd296b8956c5a1451b6a8f6d131a4326202d6f6c250e2de5280" => :high_sierra
    sha256 "1457b84bf7b2f60e168f5f8592b8bf1a136f9dc3dfed6e394105ff9b3a3d6fc3" => :sierra
  end

  depends_on "gnupg"
  depends_on "librsync"
  depends_on "openssl"
  # Dependency pycryptopp only supports Python 2
  depends_on "python@2" # does not support Python 3

  # Generated with homebrew-pypi-poet from
  # for i in azure-storage boto dropbox fasteners kerberos mega.py
  # paramiko pexpect pycrypto pycryptopp python-swiftclient python-keystoneclient
  # requests requests-oauthlib typing; do poet -r $i >> resources; done
  # Additional dependencies of requests[security] should also be installed:
  #   ndg-httpsclient, pyOpenSSL
  # pyrax was dropped because it has pinned dependencies & is deprecated.

  # must be installed early
  resource "pytz" do
    url "https://files.pythonhosted.org/packages/a4/09/c47e57fc9c7062b4e83b075d418800d322caa87ec0ac21e6308bd3a2d519/pytz-2017.2.zip"
    sha256 "f5c056e8f62d45ba8215e5cb8f50dfccb198b4b9fbea8500674f3443e4689589"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/3a/cb/46b76381ebda237c1b08d1c94394659679a4f1bd6475fe3703b303830ee0/Babel-2.5.0.tar.gz"
    sha256 "754177ee7481b6fac1bf84edeeb6338ab51640984e97e4083657d384b1c8830d"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/fa/38/0f35ec4beb6562f1abfa07914db1cea978e93da409ba6293f810d9e677d6/PyNaCl-1.2.0.tar.gz"
    sha256 "45c5bcdf8ddefe2e9381f5d37fe778bbda6991fe7004e0b1ea3570df2fc07207"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/31/53/8bca924b30cb79d6d70dbab6a99e8731d1e4dd3b090b7f3d8412a8d8ffbc/asn1crypto-0.23.0.tar.gz"
    sha256 "0874981329cfebb366d6584c3d16e913f2a0eb026c9463efcc4aaf42a9d94d70"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/85/76/8809248c38bf1c994f40bc07cf3a17dec0aa00ba0915f159c904b040893e/azure-common-1.1.8.zip"
    sha256 "25559617b41fe0902f34b215a3440a3ffa4862fe442bf351415be0e1d2eb4289"
  end

  resource "azure-storage" do
    url "https://files.pythonhosted.org/packages/5c/7e/eaa76c75b7001b1dd91a875b10c1b63fb9562e6c2bb12e5c8546177e27ba/azure-storage-0.36.0.tar.gz"
    sha256 "fb6212dcbed91b49d9637aa5e8888eafdfcd523b7e560c8044d2d838bbd3ca5f"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/f3/ec/bb6b384b5134fd881b91b6aa3a88ccddaad0103857760711a5ab8c799358/bcrypt-3.1.4.tar.gz"
    sha256 "67ed1a374c9155ec0840214ce804616de49c3df9c5bc66740687c1c9b1cd9e8d"
  end

  resource "boto" do
    url "https://files.pythonhosted.org/packages/66/e7/fe1db6a5ed53831b53b8a6695a8f134a58833cadb5f2740802bc3730ac15/boto-2.48.0.tar.gz"
    sha256 "deb8925b734b109679e3de65856018996338758f4b916ff4fe7bb62b6d7000d1"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/20/d0/3f7a84b0c5b89e94abbd073a5f00c7176089f526edb056686751d5064cbd/certifi-2017.7.27.1.tar.gz"
    sha256 "40523d2efb60523e113b44602298f0960e900388cf3bb6043f645cf57ea9e3f5"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/c9/70/89b68b6600d479034276fed316e14b9107d50a62f5627da37fafe083fde3/cffi-1.11.2.tar.gz"
    sha256 "ab87dd91c0c4073758d07334c1e5f712ce8fe48f007b86f8238773963ee700a6"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/f3/7c/ec4f94489719803cb14d35e9625d1f5a613b9c4b8d01ee52a4c77485e681/cryptography-2.1.3.tar.gz"
    sha256 "68a26c353627163d74ee769d4749f2ee243866e9dac43c93bb33ebd8fbed1199"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/03/53/55f00f682f3e692a85be2bf4e227a77f67f6e504d9f505e0423590bdefa6/debtcollector-1.17.0.tar.gz"
    sha256 "71e3350b6b97acede200f30b3858749b21303a70fde4ded26e4cbe599a3b0466"
  end

  # Pinned on 6.9.0 by duplicity's requirements.txt file. Don't update until that changes.
  resource "dropbox" do
    url "https://files.pythonhosted.org/packages/1f/7d/6e90b169fe4142b3b2332fd22d2aecfdc971e42eef19ea1c50b2384067f2/dropbox-6.9.0.tar.gz"
    sha256 "db1be6dab980f6819508c9f70d2c82b32aad4b7f5f0c52354fdb48ca4abdee49"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "fasteners" do
    url "https://files.pythonhosted.org/packages/f4/6f/41b835c9bf69b03615630f8a6f6d45dafbec95eb4e2bb816638f043552b2/fasteners-0.14.1.tar.gz"
    sha256 "427c76773fe036ddfa41e57d89086ea03111bbac57c55fc55f3006d027107e18"
  end

  resource "funcsigs" do
    url "https://files.pythonhosted.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz"
    sha256 "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50"
  end

  resource "futures" do
    url "https://files.pythonhosted.org/packages/cc/26/b61e3a4eb50653e8a7339d84eeaa46d1e93b92951978873c220ae64d0733/futures-3.1.1.tar.gz"
    sha256 "51ecb45f0add83c806c68e4b06106f90db260585b25ef2abfcda0bd95c0132fd"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/4e/13/774faf38b445d0b3a844b65747175b2e0500164b7c28d78e34987a5bfe06/ipaddress-1.0.18.tar.gz"
    sha256 "5d8534c8e185f2d8a1fda1ef73f2c8f4b23264e8e30063feeb9511d492a413e1"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/45/13/3db24895497345fb44c4248c08b16da34a9eb02643cea2754b21b5ed08b0/iso8601-0.1.12.tar.gz"
    sha256 "49c4b20e1f38aa5cf109ddcd39647ac419f928512c869dc01d5c7098eddede82"
  end

  resource "kerberos" do
    url "https://files.pythonhosted.org/packages/46/73/1e7520780a50c9470aeba2b3c020981201c8662b618fb2889a3e3dc2aeed/kerberos-1.2.5.tar.gz"
    sha256 "b32ae66b1da2938a2ae68f83d67ce41b5c5e3b6c731407104cd209ba426dadfe"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/19/05/00048afb5697ac54c0aad757ec8679f471040683e772039ef2977ab00a32/keystoneauth1-3.2.0.tar.gz"
    sha256 "768036ee66372df2ad56716b8be4965cef9a59a01647992919516defb282e365"
  end

  resource "mega.py" do
    url "https://files.pythonhosted.org/packages/13/d2/cbbc5d21f2281fb59e27085c98b33bc93616be314b6fda5ad5d1955136ac/mega.py-0.9.18.tar.gz"
    sha256 "f3e15912ce2e5de18e31e7abef8a819a5546c184aa09586bfdaa42968cc827bf"
  end

  resource "monotonic" do
    url "https://files.pythonhosted.org/packages/96/b3/3e9fa0bdf132a971571cbf0e3f0c8b38834f4f7af8ca9523794f4f5895e0/monotonic-1.3.tar.gz"
    sha256 "2b469e2d7dd403f7f7f79227fe5ad551ee1e76f8bb300ae935209884b93c7c1b"
  end

  resource "msgpack-python" do
    url "https://files.pythonhosted.org/packages/21/27/8a1d82041c7a2a51fcc73675875a5f9ea06c2663e02fcfeb708be1d081a0/msgpack-python-0.4.8.tar.gz"
    sha256 "1a2b19df0f03519ec7f19f826afb935b202d8979b0856c6fb3dc28955799f886"
  end

  resource "ndg-httpsclient" do
    url "https://files.pythonhosted.org/packages/25/4c/28c412126f0394dbb3d8005465357581f087fc7ec100b0e83838a90009b7/ndg_httpsclient-0.4.3.tar.gz"
    sha256 "7bfd8c5cfcbc241a93ca6a4e45f952650f5c7ecf7c49b1dbcf5f4d390240be0b"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/0c/13/7cbb180b52201c07c796243eeff4c256b053656da5cfe3916c3f5b57b3a0/netaddr-0.7.19.tar.gz"
    sha256 "38aeec7cdd035081d3a4c306394b19d677623bf76fa0913f6695127c7753aefd"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/72/01/ba076082628901bca750bf53b322a8ff10c1d757dc29196a8e6082711c9d/netifaces-0.10.6.tar.gz"
    sha256 "0c4da523f36d36f1ef92ee183f2512f3ceb9a9d2a45f7d19cda5a42c6689ebe0"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/fa/2e/25f25e6c69d97cf921f0a8f7d520e0ef336dd3deca0142c0b634b0236a90/oauthlib-2.0.2.tar.gz"
    sha256 "b3b9b47f2a263fe249b5b48c4e25a5bce882ff20a0ac34d553ce43cff55b53ac"
  end

  resource "oslo.config" do
    url "https://files.pythonhosted.org/packages/ff/86/51b3b2a094129fc70723d64d0784b4a6e5f4be97749e314ec394d2e8ec26/oslo.config-4.11.0.tar.gz"
    sha256 "1be8aaba466a3449fdb21ee8f7025b0d3d252c8c7568b8d5d05ceff58617cd05"
  end

  resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/37/6b/1a9ff9451a1de4b9b140d05b0bf7db2fa551d099aaa7a630e26c41806d68/oslo.i18n-3.17.0.tar.gz"
    sha256 "168b8c06f03599ac8172eb87112b5054e46bf421db03c367c059e3110d98ad31"
  end

  resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/e6/e8/00de1a1786b397ec82c971a0c650b8961d6d2011332b05edad7323128b19/oslo.serialization-2.20.0.tar.gz"
    sha256 "fca6fbb350d560aab8a4fdc9a1128dac3b1d38b2fc9bf5ad22136ae090854802"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/19/ea/3743c0405e50d9d18ac57c74830526a18474a7024d4d677c2580983769ea/oslo.utils-3.28.0.tar.gz"
    sha256 "46abd731d8cfdb682eb5b1d22a2da3c549d79f889bd3db998eac4b64a955769f"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/83/78/4569a543ef2cb304e9b82387f555021c13a845d0ad1e2bb59272ade67669/paramiko-2.3.1.tar.gz"
    sha256 "fa6b4f5c9d88f27c60fd9578146ff24e99d4b9f63391ff1343305bfd766c4660"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/d5/d6/f2bf137d71e4f213b575faa9eb426a8775732432edb67588a8ee836ecb80/pbr-3.1.1.tar.gz"
    sha256 "05f61c71aaefc02d8e37c0a3eeb9815ff526ea28b3b76324769e6158d7f95be1"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e8/13/d0b0599099d6cd23663043a2a0bb7c61e58c6ba359b2656e6fb000ef5b98/pexpect-4.2.1.tar.gz"
    sha256 "3d132465a75b57aa818341c6521392a06cc660feb3988d7f1074f39bd23c9a92"
  end

  resource "positional" do
    url "https://files.pythonhosted.org/packages/24/7e/3b1450db76eb48a54ea661a43ae00950275e11840042c5217bd3b47b478e/positional-1.2.1.tar.gz"
    sha256 "cf48ea169f6c39486d5efa0ce7126a97bed979a52af6261cf255a41f9a74453a"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/51/83/5d07dc35534640b06f9d9f1a1d2bc2513fb9cc7595a1b0e28ae5477056ce/ptyprocess-0.5.2.tar.gz"
    sha256 "e64193f0047ad603b71f202332ab5527c5e52aa7c8b609704fc28c0dc20c4365"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/b0/9e/7088f6165c40c46416aff434eb806c1d64ad6ec6dbc201f5ad4d0484704e/pyOpenSSL-17.2.0.tar.gz"
    sha256 "5d617ce36b07c51f330aa63b83bf7f25c40a0e95958876d54d1982f8c91b4834"
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

  resource "pycryptopp" do
    url "https://files.pythonhosted.org/packages/7c/e2/7e035d306c7516c471802d7cd7b6c1e403e582489bc5c14706854a187a24/pycryptopp-0.7.1.869544967005693312591928092448767568728501330214.tar.gz"
    sha256 "08ad57a1a39b7ed23c173692281da0b8d49d98ad3dcc09f8cca6d901e142699f"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz"
    sha256 "0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/54/bb/f1db86504f7a49e1d9b9301531181b00a1c7325dc85a29160ee3eaa73a54/python-dateutil-2.6.1.tar.gz"
    sha256 "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/a4/a8/b8a83375ee028a0bd28acfcbb9bba20ab27ae2e7e513553e0bc1b901a4e4/python-keystoneclient-3.13.0.tar.gz"
    sha256 "f897eaa6b251a12e5d23130e8435fb5d2ead6f7ea1d1d20faf2ccc1c76c51c90"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/9a/a7/fa2e2def232d0c8b32677399f0381e3e6e602ce577e138fff57771a0b9e7/python-swiftclient-3.4.0.tar.gz"
    sha256 "54f7ae339bd076e295dd576ec98e55ba71205ee7e62964b27c8ec80c9351067d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/80/14/ad120c720f86c547ba8988010d5186102030591f71f7099f23921ca47fe5/requests-oauthlib-0.8.0.tar.gz"
    sha256 "883ac416757eada6d3d07054ec7092ac21c7f35cb1d2cf82faf205637081f468"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/4b/f6/8f0a24e50454494b0736fe02e6617e7436f2b30148b8f062462177e2ca2d/rfc3986-1.1.0.tar.gz"
    sha256 "8458571c4c57e1cf23593ad860bb601b6a604df6217f829c2bc70dc4b5af941b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/08/58/e21f4691e8e75a290bdbfa366f06b9403c653642ef31f879e07f6f9ad7db/stevedore-1.25.0.tar.gz"
    sha256 "c8a373b90487b7a1b52ebaa3ca5059315bf68d9ebe15b2203c2fa675bd7e1e7e"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/ca/38/16ba8d542e609997fdcd0214628421c971f8c395084085354b11ff4ac9c3/typing-3.6.2.tar.gz"
    sha256 "d514bd84b284dd3e844f0305ac07511f097e325171f6cc4a20878d11ad771849"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/a0/47/66897906448185fcb77fc3c2b1bc20ed0ecca81a0f2f88eda3fc5a34fc3d/wrapt-1.10.11.tar.gz"
    sha256 "d4d560d479f2c21e1b5443bbd15fe7ec4b37fe7e53d335d3b9b0a7b1226fe3c6"
  end

  def install
    virtualenv_install_with_resources
    inreplace Dir[bin/"*"], %r{^#!/usr/bin/env python.*$},
                            "#!#{libexec}/bin/python"
    man1.install Dir[libexec/"share/man/man1/*"]
  end

  test do
    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS
    system Formula["gnupg"].opt_bin/"gpg", "--batch", "--gen-key", "batch.gpg"
    begin
      (testpath/"test/hello.txt").write "Hello!"
      (testpath/"command.sh").write <<~EOS
        #!/usr/bin/expect -f
        set timeout -1
        spawn #{bin}/duplicity #{testpath} "file://test"
        expect -exact "Local and Remote metadata are synchronized, no sync needed."
        expect -exact "Last full backup date: none"
        expect -exact "GnuPG passphrase:"
        send -- "brew\n"
        expect -exact "Retype passphrase to confirm:"
        send -- "brew\n"
        expect -exact "No signatures found, switching to full backup."
        expect eof
      EOS
      chmod 0555, testpath/"command.sh"
      system "./command.sh"
      assert_match "duplicity-full-signatures", Dir["test/*"].to_s

      # Ensure requests[security] is activated
      script = "import requests as r; r.get('https://mozilla-modern.badssl.com')"
      system libexec/"bin/python", "-c", script
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
      system Formula["gnupg"].opt_bin/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end
  end
end
