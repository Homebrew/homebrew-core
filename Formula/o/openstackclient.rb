class Openstackclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for OpenStack"
  homepage "https://openstack.org"
  url "https://files.pythonhosted.org/packages/6e/6e/7c48e37608b4af54a5e8471ccf33ae93cee10360c2e37601c860d0f6e5ee/python_openstackclient-9.0.0.tar.gz"
  sha256 "8cdca0a274ef5e423f31a07c7117432e4ce5b72d95e3eba5b06e1c831eb3018e"
  license "Apache-2.0"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dab0184bda693f2da1063e2325eee418d50136e32618091c85fa5f4a70698f9a"
    sha256 cellar: :any,                 arm64_sequoia: "a03a627ec0ad03679e5292bb31d86c01297d806587e72962ccbb0d31a7f7eccb"
    sha256 cellar: :any,                 arm64_sonoma:  "f5de67cbbcf9ee0c110932e8e36210ff4b26eed975ab85f6b5a1d5b2cd1749fc"
    sha256 cellar: :any,                 sonoma:        "b526eb6e7bc1216f2dc2a81e8794ced40d38b168c8ccc91ce9979c606f9b3349"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58017ba1cd92851c8ea8a636db6e69fca07a2bfe14f4c5d4a359f3e48d2ca768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f4a00cec9d1d0c9c29fad910d562641be439e7d66df98cc198594fad49337ff"
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
                                     python-octaviaclient],
                exclude_packages: %w[certifi cryptography gnureadline rpds-py]

  resource "pyinotify" do
    on_linux do
      url "https://files.pythonhosted.org/packages/e3/c0/fd5b18dde17c1249658521f69598f3252f11d9d7a980c5be8619970646e1/pyinotify-0.9.6.tar.gz"
      sha256 "9c998a5d7606ca835065cdabc013ae6c66eb9ea76a00a1e3bc6e0cfe2b4f71f4"
    end
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "autopage" do
    url "https://files.pythonhosted.org/packages/75/76/9078d8db91f29af9ac5a359757f63f2d0fa869aba704d5ef0f836db62ea1/autopage-0.6.0.tar.gz"
    sha256 "42d07de90de63e83762828028bfd56d19906a18f7c951ef6eef3e9ad48a3071d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/7b/60/e3bec1881450851b087e301bedc3daa9377a4d45f1c26aa90b0b235e38aa/charset_normalizer-3.4.6.tar.gz"
    sha256 "1ae6b62897110aa7c79ea2f5dd38d1abca6db663687c0b1ad9aed6f6bae3d9d6"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/c2/ff/58b550ed138f67d2a8aa280021beeeccde5b09fe1b2725202d6f22478470/cliff-4.13.2.tar.gz"
    sha256 "e949b585b9b64549de87388cefd49e87dd63095ce2b9f3b98f9123d7cd94be1a"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/70/39/c0c85040ea9b9465ec345ec9ae89416aef9a8672e74bc23c5cc1a2142ea0/cmd2-3.4.0.tar.gz"
    sha256 "fd43ef7540609469f055858146f2c592ca4c58e3c336b5efbc5502459ab0bdb2"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/ad/57/1bbe02be744995408d944cf46b8c818cf072873064b1cd3c79c11618b216/debtcollector-3.1.0.tar.gz"
    sha256 "278a45608cf16e79c0ae10851d869185c6b78f86610df8f27a451a18c1fec732"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/43/fa/6d96a0978d19e17b68d634497769987b16c8f4cd0a7a05048bec693caa6b/decorator-5.2.1.tar.gz"
    sha256 "65f266143752f734b0a7cc83c46f4618af75b8c5911b00ccb61d0ac9b6da0360"
  end

  resource "dogpile-cache" do
    url "https://files.pythonhosted.org/packages/e7/c8/301ff89746e76745b937606df4753c032787c59ecb37dd4d4250bddc8929/dogpile_cache-1.5.0.tar.gz"
    sha256 "849c5573c9a38f155cd4173103c702b637ede0361c12e864876877d0cd125eec"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
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
    url "https://files.pythonhosted.org/packages/f3/bc/d99872ca0bc8bf5f248b50e3d7386dedec5278f8dd989a2a981d329a8069/keystoneauth1-5.13.1.tar.gz"
    sha256 "e011e47ac3f3c671ffae33505c095548650cc19dab7f6af3b2ea5bd18c98f0c9"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/4d/f2/bfb55a6236ed8725a96b0aa3acbd0ec17588e6a2c3b62a93eb513ed8783f/msgpack-1.1.2.tar.gz"
    sha256 "3b60763c1373dd60f398488069bcdc703cd08a711477b5d480eecc9f9626f47e"
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
    url "https://files.pythonhosted.org/packages/97/32/5f614212ccc23323755dd83fc0c23600666161a4d3e81dce9bdcf8048aab/openstacksdk-4.10.0.tar.gz"
    sha256 "5dde9ae3f1e2411a87ff57b2d78da53fac8eae9e5bac8e5870927cb62ddfc033"
  end

  resource "os-service-types" do
    url "https://files.pythonhosted.org/packages/51/62/31e39aa8f2ac5bff0b061ce053f0610c9fe659e12aeca20bfb26d1665024/os_service_types-1.8.2.tar.gz"
    sha256 "ab7648d7232849943196e1bb00a30e2e25e600fa3b57bb241d15b7f521b5b575"
  end

  resource "osc-lib" do
    url "https://files.pythonhosted.org/packages/20/08/a59bd83e6850d5a27606de1a9fc0b80a2e9b7452ca90ed0ecdaa581a91e6/osc_lib-4.4.0.tar.gz"
    sha256 "6a615d744f03fba513d92eb4760a9cd5baa96e3d8530611fe53b217062bf317e"
  end

  resource "osc-placement" do
    url "https://files.pythonhosted.org/packages/c5/0d/edc245910116e89e6e04a6a94c1a56ed68aceecee52445feb853966c536b/osc_placement-4.8.0.tar.gz"
    sha256 "4501fd70623864a46ed9a7348e936fd0100e52e1d2439399386056e9121f8ba2"
  end

  resource "oslo-config" do
    url "https://files.pythonhosted.org/packages/cc/a6/aaf41cba43f8934d9c5db35f49fd8aa083279831f11974bea0816c593891/oslo_config-10.3.0.tar.gz"
    sha256 "c405a40a8b05aa97bb5c24bb0b849981a7a5b7d56304df40632722312c58eaca"
  end

  resource "oslo-context" do
    url "https://files.pythonhosted.org/packages/f7/a6/6b895cd19414f3e0db4029225bf95cde8d6ad36eb75be2d69fdcf6fe427d/oslo_context-6.3.0.tar.gz"
    sha256 "e504f8df02c5cce7fc984f867fbdfaaa1d4d4b9b88978e291f6e5cb89df5a3e0"
  end

  resource "oslo-i18n" do
    url "https://files.pythonhosted.org/packages/4f/4e/0ed2248dfc4c8e993064b3b7419835fc1f1adbab6917f41a011157ed50d5/oslo_i18n-6.7.2.tar.gz"
    sha256 "b1241ad3eee216e9dc9acb4336fce0bd79c4c286751ee70dfa42ff2f9763d34f"
  end

  resource "oslo-log" do
    url "https://files.pythonhosted.org/packages/12/2e/d4f083ddf4fda98c2c5bd3fa2814f22fed59039bfdba73b7240fd332a798/oslo_log-8.1.0.tar.gz"
    sha256 "4b7a2c869474a1d57f84ea5a4d03d8578b04a8023c0fa5511663e77a936a0f7b"
  end

  resource "oslo-serialization" do
    url "https://files.pythonhosted.org/packages/2d/66/ec1b215f2a5005e43803d904ad537734cfabf499dd89f95988e2173e5867/oslo_serialization-5.9.1.tar.gz"
    sha256 "086ab78a15f33f02e647bdb3ca36632480d94cf661cf1fb118adebdeee5d4be7"
  end

  resource "oslo-utils" do
    url "https://files.pythonhosted.org/packages/d2/a5/6e9fb7904250e786f4afb137a23a2ec27098136efb8e72a5414cc66ae566/oslo_utils-10.0.0.tar.gz"
    sha256 "bb46713e760d94446a084f5e94c1cf273935369308ad88ee5b53917923d9c393"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/5e/ab/1de9a4f730edde1bdbbc2b8d19f8fa326f036b4f18b2f72cfbea7dc53c26/pbr-7.0.3.tar.gz"
    sha256 "b46004ec30a5324672683ec848aed9e8fc500b0d261d40a3229c2d2bbfcedc29"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/19/56/8d4c30c8a1d07013911a8fdbd8f89440ef9f08d07a1b50ab8ca8be5a20f9/platformdirs-4.9.4.tar.gz"
    sha256 "1ec356301b7dc906d83f371c8f487070e99d3ccf9e501686456394622a01a934"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/79/45/b0847d88d6cfeb4413566738c8bbf1e1995fad3d42515327ff32cc1eb578/prettytable-3.17.0.tar.gz"
    sha256 "59f2590776527f3c9e8cf9fe7b66dd215837cca96a9c39567414cbc632e8ddb0"
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
    url "https://files.pythonhosted.org/packages/8e/11/a62e1d33b373da2b2c2cd9eb508147871c80f12b1cacde3c5d314922afdd/pyopenssl-26.0.0.tar.gz"
    sha256 "f293934e52936f2e3413b89c6ce36df66a0b34ae1ea3a053b8c5020ff2f513fc"
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
    url "https://files.pythonhosted.org/packages/60/51/1c23cd8fea7731deeb11ed75dc4a968794c629336277afb97bdcfcfa019d/python_barbicanclient-7.3.0.tar.gz"
    sha256 "f3930b7b30bce774c77b85f49dbb36bdce7cb783b3b6c6779244775e4e113da6"
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
    url "https://files.pythonhosted.org/packages/ac/5d/71731cf4f9225594442bc08ee438e7534d2e50344ecca4972385a9ea9e39/python_glanceclient-4.11.0.tar.gz"
    sha256 "5ce2118bfe7462934805916617e537bc5b00fd4cab3fb7bb88a4f9253970562d"
  end

  resource "python-heatclient" do
    url "https://files.pythonhosted.org/packages/6f/cf/5db78500380117c9ef3fb882cb8e5d0d23e9f72fee12a4b5a930ab034ff5/python_heatclient-5.1.0.tar.gz"
    sha256 "ecb4a7133461d05370bfe484185fcebd6e95d7ee2e28846966d7136232fbda6d"
  end

  resource "python-ironicclient" do
    url "https://files.pythonhosted.org/packages/35/42/5c41c9b0705e3f3ae500dc14d8466d9d68a979c47ccc733882221ee9be16/python_ironicclient-6.0.0.tar.gz"
    sha256 "6b96e715ec8766ec54fc54e02d23fc55aabd54b0ea10ae987559ad832952458f"
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
    url "https://files.pythonhosted.org/packages/0c/44/ae5a599edefc03848274f37be30e3725ad6aa85f1c3dbd8e8427f8c14e6f/python_manilaclient-6.0.0.tar.gz"
    sha256 "110c2c6f067315713e28a0c7d92c650ba1bca05bdd5e8d9b2b86c928965fad5c"
  end

  resource "python-mistralclient" do
    url "https://files.pythonhosted.org/packages/7e/fd/0436cfa55e34c336165f69798f79abfa0c218b6816fdd47f34fb101da5b0/python_mistralclient-6.2.0.tar.gz"
    sha256 "6169ef9ddf3f473628060545125c6ccfd7ea088e109af48c14acc5ba82459f8b"
  end

  resource "python-octaviaclient" do
    url "https://files.pythonhosted.org/packages/40/08/77aba1966d6f485fb7d94b60f0126bd7cbbfcfa96785fb3ad1f4986a0ffc/python_octaviaclient-3.13.0.tar.gz"
    sha256 "22ad537573140eaac4df757eca1f07ef260f216d3535511ae9c3ea14fab862fe"
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
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
  end

  resource "requestsexceptions" do
    url "https://files.pythonhosted.org/packages/82/ed/61b9652d3256503c99b0b8f145d9c8aa24c514caff6efc229989505937c1/requestsexceptions-1.4.0.tar.gz"
    sha256 "b095cbc77618f066d459a02b137b020c37da9f46d9b057704019c9f77dba3065"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/85/40/1520d68bfa07ab5a6f065a186815fb6610c86fe957bc065754e47f7b0840/rfc3986-2.0.0.tar.gz"
    sha256 "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
  end

  resource "rich-argparse" do
    url "https://files.pythonhosted.org/packages/4c/f7/1c65e0245d4c7009a87ac92908294a66e7e7635eccf76a68550f40c6df80/rich_argparse-1.7.2.tar.gz"
    sha256 "64fd2e948fc96e8a1a06e0e72c111c2ce7f3af74126d75c0f5f63926e7289cd1"
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
    url "https://files.pythonhosted.org/packages/a2/6d/90764092216fa560f6587f83bb70113a8ba510ba436c6476a2b47359057c/stevedore-5.7.0.tar.gz"
    sha256 "31dd6fe6b3cbe921e21dcefabc9a5f1cf848cf538a1f27543721b8ca09948aa3"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "warlock" do
    url "https://files.pythonhosted.org/packages/29/c2/3ba4daeddd47f1cfdbc703048cbee27bcbc50535261a2bbe36412565f3c9/warlock-2.1.0.tar.gz"
    sha256 "82319ba017341e7fcdc81efc2be9dd2f8237a0da07c71476b5425651b317b1c9"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/35/a2/8e3becb46433538a38726c948d3399905a4c7cabd0df578ede5dc51f0ec2/wcwidth-0.6.0.tar.gz"
    sha256 "cdc4e4262d6ef9a1a57e018384cbeb1208d8abbc64176027e2c2455c81313159"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/2e/64/925f213fdcbb9baeb1530449ac71a4d57fc361c053d06bf78d0c5c7cd80c/wrapt-2.1.2.tar.gz"
    sha256 "3996a67eecc2c68fd47b4e3c564405a5777367adfd9b8abb58387b63ee83b21e"
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
    ]
    openstack_subcommands.each do |subcommand|
      output = shell_output("#{bin}/openstack #{subcommand} 2>&1", 1)
      assert_match "Missing value auth-url required", output
    end
  end
end
