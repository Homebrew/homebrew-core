class Openstackclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for OpenStack"
  homepage "https://openstack.org"
  url "https://files.pythonhosted.org/packages/84/bb/597fc8c39fe593e43089b7eb035b40f5df44c73e4afad3fb8a6163d51010/python_openstackclient-10.1.0.tar.gz"
  sha256 "e5557041c40d2daf5dfe591af2f9375aa057db87b1b5630fc96e1c600763295e"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d07c4f9b0b711168ec9bf0d4975ee062026bfe321b6a79b66235e134b7b92e06"
    sha256 cellar: :any, arm64_sequoia: "389c5dbb1bcda0bbbc17b6843749ed4f60ad9bec4ca656e7507efd73c8844641"
    sha256 cellar: :any, arm64_sonoma:  "9cac3dc9b24703edf1d8f9d29f714db52e5d5b1eff4c25ddd51918cb43c57448"
    sha256 cellar: :any, sonoma:        "3a5b29594e60aae0355ed9c4b0cb4d9d55827df9d5bdc69ec4992db6ff799154"
    sha256 cellar: :any, arm64_linux:   "ad535e4048cfbefad598c80f580d35ee561aa90526ae9654ddabab1f1886780e"
    sha256 cellar: :any, x86_64_linux:  "3097b88e6822e224cc40902f7a163cfc0e2dfcc14d7d7591a9d2370ce9f511ce"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  pypi_packages extra_packages:   %w[keystoneauth-websso osc-placement python-barbicanclient
                                     python-cloudkittyclient python-designateclient
                                     python-glanceclient python-heatclient python-ironicclient
                                     python-magnumclient python-manilaclient python-mistralclient
                                     python-neutronclient python-octaviaclient],
                exclude_packages: %w[certifi cryptography gnureadline rpds-py]

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "autopage" do
    url "https://files.pythonhosted.org/packages/75/76/9078d8db91f29af9ac5a359757f63f2d0fa869aba704d5ef0f836db62ea1/autopage-0.6.0.tar.gz"
    sha256 "42d07de90de63e83762828028bfd56d19906a18f7c951ef6eef3e9ad48a3071d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/c2/3b/f0314dfc0c24b2bce7c6e99ef51fd116babe804e02c8d575ed87a66ac412/cliff-4.14.0.tar.gz"
    sha256 "66f2fbb0e18c348e44794014cfed92bf6522ef997e0c096df199dad195182f8a"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/78/a0/174d34e025915056cd0e1eb566a78056bf65570716af35b90b3150c41d7e/cmd2-4.0.0.tar.gz"
    sha256 "97956c491be8ae2c5239ba1e7658b52804f0e54b401b15cae80c6b85c9dce74f"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/ad/57/1bbe02be744995408d944cf46b8c818cf072873064b1cd3c79c11618b216/debtcollector-3.1.0.tar.gz"
    sha256 "278a45608cf16e79c0ae10851d869185c6b78f86610df8f27a451a18c1fec732"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/60/8b/32f9823da46cde7df2087faa08cd98d01b908f8dcab982cdba9c84e85355/decorator-5.3.1.tar.gz"
    sha256 "4cbcdd55a6efadb9dbea26b858f4fb3264567b52d69ca0d25b721b553f60ea82"
  end

  resource "dogpile-cache" do
    url "https://files.pythonhosted.org/packages/e7/c8/301ff89746e76745b937606df4753c032787c59ecb37dd4d4250bddc8929/dogpile_cache-1.5.0.tar.gz"
    sha256 "849c5573c9a38f155cd4173103c702b637ede0361c12e864876877d0cd125eec"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/b9/f3/ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15/iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpath-rw" do
    url "https://files.pythonhosted.org/packages/71/7c/45001b1f19af8c4478489fbae4fc657b21c4c669d7a5a036a86882581d85/jsonpath-rw-1.4.0.tar.gz"
    sha256 "05c471281c45ae113f6103d1268ec7a4831a2e96aa80de45edc89b11fac4fbec"
  end

  resource "jsonpath-rw-ext" do
    url "https://files.pythonhosted.org/packages/d5/f0/5d865b2543be45e3ab7a8c2ae8dfa5c3e56cfdd48f19d4455eb02f370386/jsonpath-rw-ext-1.2.2.tar.gz"
    sha256 "a9e44e803b6d87d135b09d1e5af0db4d4cf97ba62711a80aa51c8c721980a994"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/18/c7/af399a2e7a67fd18d63c40c5e62d3af4e67b836a2107468b6a5ea24c4304/jsonpointer-3.1.1.tar.gz"
    sha256 "0b801c7db33a904024f6004d526dcc53bbb8a4a0f4e32bfd10beadf60adf1900"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "keystoneauth-websso" do
    url "https://files.pythonhosted.org/packages/59/87/6362ba7b9e48926aa0d81733af3b604ac2063a32a86594ea69ea3743e496/keystoneauth_websso-0.2.5.tar.gz"
    sha256 "a30289dd4ae70ba56387bb8defe8da6e3eb7f9e6d289692d3cb5b0c7460b071c"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/02/d9/a01a3898657626cbcca9fa0e8fa58facb4632e172bdac622d47950f7e12a/keystoneauth1-5.14.0.tar.gz"
    sha256 "7b942084d3db27dd285c13253cdfee10b05be0436db1c01e15dc744902197a7f"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/31/f9/c0a1c127f9049db9155afc316952ea571720dd01833ff5e4d7e8e6352dbb/msgpack-1.2.1.tar.gz"
    sha256 "04c721c2c7448767e9e3f2520a475663d8ee0f09c31890f6d2bd70fd636a9647"
  end

  resource "multipart" do
    url "https://files.pythonhosted.org/packages/8e/d6/9c4f366d6f9bb8f8fb5eae3acac471335c39510c42b537fd515213d7d8c3/multipart-1.3.1.tar.gz"
    sha256 "211d7cfc1a7a43e75c4d24ee0e8e0f4f61d522f1a21575303ae85333dea687bf"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/54/90/188b2a69654f27b221fba92fda7217778208532c962509e959a9cee5229d/netaddr-1.3.0.tar.gz"
    sha256 "5c3c3d9895b551b763779ba7db7a03487dc1f8e3b385af819af341ae9ef6e48a"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/b8/43/49b126e9ccfa19647d2f0aff26321caded607522d29c3d9495d44f4b9471/openstacksdk-4.16.0.tar.gz"
    sha256 "466640c6d2b813b782d4ad58a4f2960633e8e58f147ec0baa2019454de190d30"
  end

  resource "os-service-types" do
    url "https://files.pythonhosted.org/packages/51/62/31e39aa8f2ac5bff0b061ce053f0610c9fe659e12aeca20bfb26d1665024/os_service_types-1.8.2.tar.gz"
    sha256 "ab7648d7232849943196e1bb00a30e2e25e600fa3b57bb241d15b7f521b5b575"
  end

  resource "osc-lib" do
    url "https://files.pythonhosted.org/packages/16/f9/e9815fb7ea7c559b033c1c458da8f05e704571bd625526d60f90c9f02f20/osc_lib-4.6.0.tar.gz"
    sha256 "b2588feb50c4192ebacf51f95c51278eb709c8217b36cb72c667958bbfeece3e"
  end

  resource "osc-placement" do
    url "https://files.pythonhosted.org/packages/c5/0d/edc245910116e89e6e04a6a94c1a56ed68aceecee52445feb853966c536b/osc_placement-4.8.0.tar.gz"
    sha256 "4501fd70623864a46ed9a7348e936fd0100e52e1d2439399386056e9121f8ba2"
  end

  resource "oslo-config" do
    url "https://files.pythonhosted.org/packages/5d/12/7aa270611a106994d79610157c348216971d6e5a91300acdc1cae9a64081/oslo_config-10.5.0.tar.gz"
    sha256 "8eea3356c93828c2d61bea1eb19b8cd7860a3edaff4ad2678d774dd353730dfa"
  end

  resource "oslo-context" do
    url "https://files.pythonhosted.org/packages/14/64/558ab39b213b337dce5ba92b1b1bd4da414fae42624cca5a15be0d6385ee/oslo_context-6.4.0.tar.gz"
    sha256 "4d77f78b347be240e6555e4a371904b5e9800c9bd79738c7e6488892cd79b1b3"
  end

  resource "oslo-i18n" do
    url "https://files.pythonhosted.org/packages/5f/26/85800d24c3aa7650bbd5fa0398aca78a84e8a8693f9c6a852148a196ddac/oslo_i18n-6.8.0.tar.gz"
    sha256 "a0b4c64c1396869d7144dca60ad97c7eb028f78f61f91c7007531238051997df"
  end

  resource "oslo-log" do
    url "https://files.pythonhosted.org/packages/4e/2a/7ede39e4d046e17156a8dcfea3d1f8d9cb8065543c992380401b7e6db10a/oslo_log-8.2.0.tar.gz"
    sha256 "12b3f6574429cd9675e3c70496f6e0c2e48217f5126c5ff0a0c188ac575bc970"
  end

  resource "oslo-serialization" do
    url "https://files.pythonhosted.org/packages/9d/e3/dc90d134ace403337f37d52e7468f53755e6a0bcc7f1d60c131b195df2ed/oslo_serialization-5.10.0.tar.gz"
    sha256 "79a71cde2651afd5dc7f065a56e4a100a4d4127ef1b17f798a6d09cea24976b6"
  end

  resource "oslo-utils" do
    url "https://files.pythonhosted.org/packages/61/16/8cb5305abd34606bd9a5ee1c6fbe5db97981d323c8454f1d872c1781dcc8/oslo_utils-10.1.1.tar.gz"
    sha256 "c8ac3ee295303cc5776c4d8e1d4ef10078ece60ede4931177e4f07aca58f81ab"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/5e/ab/1de9a4f730edde1bdbbc2b8d19f8fa326f036b4f18b2f72cfbea7dc53c26/pbr-7.0.3.tar.gz"
    sha256 "b46004ec30a5324672683ec848aed9e8fc500b0d261d40a3229c2d2bbfcedc29"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/79/45/b0847d88d6cfeb4413566738c8bbf1e1995fad3d42515327ff32cc1eb578/prettytable-3.17.0.tar.gz"
    sha256 "59f2590776527f3c9e8cf9fe7b66dd215837cca96a9c39567414cbc632e8ddb0"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/74/b7/da07bae88f5a9506b4def6f2f4903cf4c3b8831e560dba8fa18ca08f758f/pyopenssl-26.3.0.tar.gz"
    sha256 "589de7fae1c9ea670d18422ed00fc04da787bbde8e1454aea872aa57b49ad341"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "python-barbicanclient" do
    url "https://files.pythonhosted.org/packages/bd/07/e92b123707fa05f5ed2d4622e234b1a99710490fad24dc1f2a61a5cc975a/python_barbicanclient-7.4.0.tar.gz"
    sha256 "f1903940b4bd411bfbd78788944c91e2220de08276e4b5cf41a722d827990fe2"
  end

  resource "python-cinderclient" do
    url "https://files.pythonhosted.org/packages/71/35/f597e287af7c5a7245ab8c873295e4befa395555438ce75369a364577ca5/python_cinderclient-9.9.0.tar.gz"
    sha256 "697e4d12c249f39b41ecf4fa6fcb8c38cbf2d6b2d84d6f515ed567b82dcd0bd1"
  end

  resource "python-cloudkittyclient" do
    url "https://files.pythonhosted.org/packages/20/e8/a326ea9ad1750c2030c80131040338aaf51002e25cf9d604d98076175f4e/python_cloudkittyclient-6.1.0.tar.gz"
    sha256 "df5760f0af9bc5aaf2caa27addd37c46f71c2716e32a61d43c1937318e6ef837"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-designateclient" do
    url "https://files.pythonhosted.org/packages/83/c1/4365fa9fcff907eeae80e6b5da64336d1f98288c999bfacc9bdbeb4d59f2/python_designateclient-6.4.0.tar.gz"
    sha256 "bb49cf1a090e01288d93b966643333833e3417040c06f463ffe3c9e66b10ad48"
  end

  resource "python-glanceclient" do
    url "https://files.pythonhosted.org/packages/ed/32/35d09ba5bfa88180627a6c835caaa883653056f31e7e5da015804af50d1e/python_glanceclient-4.12.0.tar.gz"
    sha256 "390556573c8736409adaa3c8ba800e0d9fc1b12e2fb6d6939b8dfe999468f50f"
  end

  resource "python-heatclient" do
    url "https://files.pythonhosted.org/packages/8b/62/c2256b6a549792cb8d99b89aedbcb39ef3246e4a1d1657e235f3b527a872/python_heatclient-5.2.0.tar.gz"
    sha256 "0ba1a9526d696b004582e065cfb09f00bfd43989203db29dee559a3bf39e2c0e"
  end

  resource "python-ironicclient" do
    url "https://files.pythonhosted.org/packages/55/97/8297507baea80115f2123c25bb516acc300b2c703a4e69adf8961940f911/python_ironicclient-6.1.0.tar.gz"
    sha256 "10bdbce434311a24188f36b5e29a6f6ab1cdae2155de23081ff4089c8e11872e"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/97/ef/c8c68219a2bf9f296ad18cb0b9804c45adfdceee72d51684225488746262/python_keystoneclient-5.8.0.tar.gz"
    sha256 "3ca87c67c404298ce862310b569f545a58acf75cd5685094c82f35320b3a355d"
  end

  resource "python-magnumclient" do
    url "https://files.pythonhosted.org/packages/eb/07/52990320ce680c92cf88b2f3ba774db63efee3e33560ae310dbc3a9b88b7/python_magnumclient-4.10.0.tar.gz"
    sha256 "3cfdbb10fc6ff4dcb7094a87c8d4790478fe396759933edccd926559ce57feaf"
  end

  resource "python-manilaclient" do
    url "https://files.pythonhosted.org/packages/9b/14/c4a07dd2ab6563b75a2837e54dbf76536917891f06c975c78d83cd13dedd/python_manilaclient-6.1.0.tar.gz"
    sha256 "5322a7e03c7b1a94471ca6d61e64302681a9edb3af954a51a73420f337a460e4"
  end

  resource "python-mistralclient" do
    url "https://files.pythonhosted.org/packages/7e/fd/0436cfa55e34c336165f69798f79abfa0c218b6816fdd47f34fb101da5b0/python_mistralclient-6.2.0.tar.gz"
    sha256 "6169ef9ddf3f473628060545125c6ccfd7ea088e109af48c14acc5ba82459f8b"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/b4/d3/187305d38d3ee04e02f58573c32d7698099f77bf1c8647cb3e1127c4903a/python_neutronclient-12.0.0.tar.gz"
    sha256 "f9ea3631101aa5ab833c26c30d27b48afac70a9333bb66c2fa1fb8072b8f93d6"
  end

  resource "python-octaviaclient" do
    url "https://files.pythonhosted.org/packages/8e/fc/442482ea01e471338658fe60df5338b65d7615347c5459f4f8a24cf1b99f/python_octaviaclient-3.14.0.tar.gz"
    sha256 "0ac663436b9204cdc288d5ab95dca18797b528f55cd54adbdbc217371367388f"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/4f/d4/1db31bea9052c16f0215409f1749cae991bdb0b8d1eb4c3abfb61a9a0bf0/python_swiftclient-4.10.0.tar.gz"
    sha256 "981891abc7fb355b266e823df3ecb80e5c267c57934fb5094bb102ddaf7e51be"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/85/40/1520d68bfa07ab5a6f065a186815fb6610c86fe957bc065754e47f7b0840/rfc3986-2.0.0.tar.gz"
    sha256 "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rich-argparse" do
    url "https://files.pythonhosted.org/packages/6a/e5/1064c43203a357d668cd42435f7a15fe6af51512d85b2104fecb937aa861/rich_argparse-1.8.0.tar.gz"
    sha256 "679df3d832fa94ad6e4bdb07ded088cd7ea2dddc58ae9b2b46346a40b06cbc0c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/e9/88/35e4d27d9177d7df76d060e0a18f69c6c5794c96960c94042e20a12c8ba2/stevedore-5.8.0.tar.gz"
    sha256 "b49867b32ca3016e94100e68dbf26e72aa7b8708d0a3f73c08aeb220370ac715"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "warlock" do
    url "https://files.pythonhosted.org/packages/29/c2/3ba4daeddd47f1cfdbc703048cbee27bcbc50535261a2bbe36412565f3c9/warlock-2.1.0.tar.gz"
    sha256 "82319ba017341e7fcdc81efc2be9dd2f8237a0da07c71476b5425651b317b1c9"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/49/b4/51fe890511f0f242d07cb1ebe6a5b6db417262b9d2568b460347c57d95cc/wcwidth-0.8.1.tar.gz"
    sha256 "faf5b4a5366a72dc49cad48cdf21f52bdf63bdda995178e483ba247ff79089b9"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/2d/9f/06263fcd8ad6c405f05a3905fd7a84dd3176eb5ad46e44bccc0cd16348bb/wrapt-2.2.1.tar.gz"
    sha256 "6744f504375775d7609c82c8d3d94af1c9a6f05586984536905908ba905277b9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"openstack", "-h"
    openstack_subcommands = [
      "server list",
      "resource provider list", # osc-placement
      "stack list", # python-heatclient
      "loadbalancer list", # python-octaviaclient
      "rating summary get", # python-cloudkittyclient
      "zone list", # python-designateclient
      "secret list", # python-barbicanclient
      "share list", # python-manilaclient
      "workflow list", # python-mistralclient
      "coe cluster list", # python-magnumclient
      "baremetal node list", # python-ironicclient
      "vpn ike policy list", # python-neutronclient
    ]
    openstack_subcommands.each do |subcommand|
      output = shell_output("#{bin}/openstack #{subcommand} 2>&1", 1)
      assert_match "Missing value auth-url required", output
    end
  end
end
