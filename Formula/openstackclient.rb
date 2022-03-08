class Openstackclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for OpenStack"
  homepage "https://openstack.org"
  url "https://files.pythonhosted.org/packages/f9/d8/474a7371757b553e61ae5d4fe14c4443e84a20cc4c84db91565e79d3d45d/python-openstackclient-5.8.0.tar.gz"
  sha256 "334852df8897b95f0581ec12ee287de8c7a9289a208a18f0a8b38777019fd986"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3142e6bfb7853ea37d9e6c4d783f86b0272bfc07aaf6272498c378b3cd86b13d"
    sha256 cellar: :any,                 arm64_big_sur:  "f394c8cb25bd5f7e8a2133070fe0360014a9fca6071fd3f14b549a1c6a0553ef"
    sha256 cellar: :any,                 monterey:       "3ae3a46761a805244df971336ec88fe8eebdbf43a00304cfb73b3a8751500298"
    sha256 cellar: :any,                 big_sur:        "8533d8b17f5587d2a5e591272bc886b5465f0725de2fa452ffa924d48559d832"
    sha256 cellar: :any,                 catalina:       "71a5703de0aed1e9e736ac53f74b39c29e9bc948bd312f281db86a2c01b54815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47445586d5359121f807cc7a8778a317a88457586d7ef913dad3c3ade0117c22"
  end

  depends_on "rust" => :build
  depends_on "python@3.10"
  depends_on "six"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

  resource "autopage" do
    url "https://files.pythonhosted.org/packages/d1/1c/aaaf5bcb9f37e3d17e040a83de5a35c6cb29fc9ce45412cc8224a570fe30/autopage-0.5.0.tar.gz"
    sha256 "5305b43cc0798170d7124e5a2feecf969e45f4a0baf75cb351138114eaf76b83"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/17/e6/ec9aa6ac3d00c383a5731cc97ed7c619d3996232c977bb8326bcbb6c687e/Babel-2.9.1.tar.gz"
    sha256 "bc0c176f9f6a994582230df350aa6e05ba2ebe4b3ac317eab29d9be5d2768da0"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/71/33/0115d1f56dce6bc9f4f4b394347c52a7182109026d2c25d8837047e3edee/cliff-3.10.1.tar.gz"
    sha256 "045aee3f3c64471965d7ad507ce8474a4e2f20815fbb5405a770f8596a2a00a0"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/7b/d9/87486a680f7961105ca5f49d0701187447ec6620538f512bc3942e976e6f/cmd2-2.4.0.tar.gz"
    sha256 "090909ab6c8ecee40813cec759e61dd6e70c8227a1a8e96082f5f2b0d394bc77"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/f9/4b/1cf8e281f7ae4046a59e5e39dd7471d46db9f61bb564fddbff9084c4334f/cryptography-36.0.1.tar.gz"
    sha256 "53e5c1dc3d7a953de055d77bef2ff607ceef7a2aac0353b5d630ab67f7423638"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/76/0d/60e6c88b5b139f11b4fff730a3f32962f415edc61cc0aa76db81060cd32b/debtcollector-2.4.0.tar.gz"
    sha256 "1bc03e2d9017de480c41cf3e5a0d8cc95f1b0c8f1339281b4eca8a22acf76a23"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "dogpile.cache" do
    url "https://files.pythonhosted.org/packages/0e/94/73c2d93c9e3293115e5b831da50d6dcb20959a424309e2ddcc485238e0ce/dogpile.cache-1.1.5.tar.gz"
    sha256 "0f01bdc329329a8289af9705ff40fadb1f82a28c336f3174e12142b70d31c756"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/28/97/d2d3d96952c77e7593e0f4a634656fb384f7282327f7fef74b726b3b4c1c/iso8601-1.0.2.tar.gz"
    sha256 "27f503220e6845d9db954fb212b95b0362d8b7e6c1b2326a87061c3de93594b1"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/21/67/83452af2a6db7c4596d1e2ecaa841b9a900980103013b867f2865e5e1cf0/jsonpatch-1.32.tar.gz"
    sha256 "b6ddfe6c3db30d81a96aaeceb6baf916094ffa23d7dd5fa2c13e13f8b6e600c2"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/29/7f/e6b5930e6dd1f461ad412dfc40bc94e5235011f6bbf73cafa8074617c203/jsonpointer-2.2.tar.gz"
    sha256 "f09f8deecaaa5aea65b5eb4f67ca4e54e1a61f7a11c75085e360fe6feb6a48bf"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/18/4d/e6f986e9c12c1c817abcc1080bf7db56faf5ac86a7607a11a3c9cf722fa3/keystoneauth1-4.5.0.tar.gz"
    sha256 "49b3488966a43eeb0200ea511b997e6403c25d563a984c6330e82a0ebfc4540c"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/61/3c/2206f39880d38ca7ad8ac1b28d2d5ca81632d163b2d68ef90e46409ca057/msgpack-1.0.3.tar.gz"
    sha256 "51fdc7fb93615286428ee7758cecc2f374d5ff363bdd884c7ea622a7a327a81e"
  end

  resource "munch" do
    url "https://files.pythonhosted.org/packages/43/a1/ec48010724eedfe2add68eb7592a0d238590e14e08b95a4ffb3c7b2f0808/munch-2.5.0.tar.gz"
    sha256 "2d735f6f24d4dba3417fa448cae40c6e896ec1fdab6cdb5e6510999758a4dbd2"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/c3/3b/fe5bda7a3e927d9008c897cf1a0858a9ba9924a6b4750ec1824c9e617587/netaddr-0.8.0.tar.gz"
    sha256 "d6cc57c7a07b1d9d2e917aa8b36ae8ce61c35ba3fcd1b83ca31c5a0ee2b5a243"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/a6/91/86a6eac449ddfae239e93ffc1918cf33fd9bab35c04d1e963b311e347a73/netifaces-0.11.0.tar.gz"
    sha256 "043a79146eb2907edf439899f262b3dfe41717d34124298ed281139a8b93ca32"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/88/48/06ff537795ca78dd51c15d0dbfba6b2fd538f02b9b2715ba264e09d7d4e6/openstacksdk-0.61.0.tar.gz"
    sha256 "3eed308871230f0c53a8f58b6c5a358b184080c6b2c6bc69ab088eea057aa127"
  end

  resource "os-client-config" do
    url "https://files.pythonhosted.org/packages/58/be/ba2e4d71dd57653c8fefe8577ade06bf5f87826e835b3c7d5bb513225227/os-client-config-2.1.0.tar.gz"
    sha256 "abc38a351f8c006d34f7ee5f3f648de5e3ecf6455cc5d76cfd889d291cdf3f4e"
  end

  resource "os-service-types" do
    url "https://files.pythonhosted.org/packages/58/3f/09e93eb484b69d2a0d31361962fb667591a850630c8ce47bb177324910ec/os-service-types-1.7.0.tar.gz"
    sha256 "31800299a82239363995b91f1ebf9106ac7758542a1e4ef6dc737a5932878c6c"
  end

  resource "osc-lib" do
    url "https://files.pythonhosted.org/packages/68/17/03e208f95d40f88e2fda8d60c62698eeb1ac54b19c9cafcd921d806c669a/osc-lib-2.5.0.tar.gz"
    sha256 "d8f8a450fab2a1294e0aef8cdc9a255a1bcc5b58e1b2f6098e35e6db1e13e9d1"
  end

  resource "oslo.config" do
    url "https://files.pythonhosted.org/packages/52/c0/e7e93ba68b601cf14dacac5a8ae33fe225a9ef2b9f53c284e51b4eb608bb/oslo.config-8.8.0.tar.gz"
    sha256 "96933d3011dae15608a11616bfb00d947e22da3cb09b6ff37ddd7576abd4764c"
  end

  resource "oslo.context" do
    url "https://files.pythonhosted.org/packages/da/0c/04ebb9679c3c198073081c0406b85bde525671329218c7efa929f447f258/oslo.context-4.1.0.tar.gz"
    sha256 "75a9a722a552fba8a89e8a01028fa82a6190ab317a9591bb83303a2210a79144"
  end

  resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/7c/d8/a56cdadc3eb21f399327c45662e96479cb73beee0d602769b7847e857e7d/oslo.i18n-5.1.0.tar.gz"
    sha256 "6bf111a6357d5449640852de4640eae4159b5562bbba4c90febb0034abc095d0"
  end

  resource "oslo.log" do
    url "https://files.pythonhosted.org/packages/d1/70/d714ee27781b6f54f9db6b6831748f567160f10f92f7cec0e2f12b2e6794/oslo.log-4.6.1.tar.gz"
    sha256 "c609614fbe8352054c6e45e6a94baae8b6dccf0fdea5b0dd83fcd61499ec9636"
  end

  resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/e8/3d/142b294299ace8a470ad47a90fe152fc21ab8b4e7f9c88dfcb9679d53ff6/oslo.serialization-4.3.0.tar.gz"
    sha256 "3aa472f434aee8bbcc0725312b7f409aa1fa54bbc134904124cf49b0e86b9115"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/95/ba/25f7e518be08d92a12dd1c6de56a5606860f17f15c1b2e20e6d390b65052/oslo.utils-4.12.2.tar.gz"
    sha256 "41fd2c4ff6d2e8da38aadb5a5bf24258a8650e0e0a698a6b239d48b8e4177c3b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/51/da/eb358ed53257a864bf9deafba25bc3d6b8d41b0db46da4e7317500b1c9a5/pbr-5.8.1.tar.gz"
    sha256 "66bc5a34912f408bb3925bf21231cb6f59206267b7f63f3503ef865c1a292e25"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/cb/7d/7e6bc4bd4abc49e9f4f5c4773bb43d1615e4b476d108d1b527318b9c6521/prettytable-3.2.0.tar.gz"
    sha256 "ae7d96c64100543dc61662b40a28f3b03c0f94a503ed121c6fca2782c5816f81"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/d6/60/9bed18f43275b34198eb9720d4c1238c68b3755620d20df0afd89424d32b/pyparsing-3.0.7.tar.gz"
    sha256 "18ee9022775d270c55187733956460083db60b37d0d0fb357445f3094eed3eea"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "python-cinderclient" do
    url "https://files.pythonhosted.org/packages/54/05/2ae3d26e8e29cb041c557dc38111687120b47053b31d51af2c1a2bfea23a/python-cinderclient-8.3.0.tar.gz"
    sha256 "e00103875029dc85cbb59131d00ccc8534f692956acde32b5a3cc5af4c24580b"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-heatclient" do
    url "https://files.pythonhosted.org/packages/5c/d0/cea722a2e3c7f6f2ef7d3af6e1b043a8ce39f8f1ced21583af0e84a07a59/python-heatclient-2.5.1.tar.gz"
    sha256 "de5ed7cb12a6d7c0403350e136c0a6470719476db8fbc9bf8d0d581ebc0b1c2b"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/ee/a7/4f371e8f4fd063799ad5cef8789360e5a3b94f197e956ef46a4b9fb6e988/python-keystoneclient-4.4.0.tar.gz"
    sha256 "fc17ca9a1aa493104b496ba347f12507f271b5b6e819f4de4aef6574918aa071"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/43/50/f9aa3ce530b1ba59f442042c9d57b5395853b9d336fffcb8d89fd25065de/python-neutronclient-7.8.0.tar.gz"
    sha256 "9bc66b2952912c2ba298d4c8492db897a5eafcb0ecf757e37baa691b70b47b4e"
  end

  resource "python-novaclient" do
    url "https://files.pythonhosted.org/packages/ca/26/581411d8acc539e59ffff1dc7d59e512e374340aae1bdf9c491ae8a853e1/python-novaclient-17.7.0.tar.gz"
    sha256 "4ebc27f4ce06c155b8e991a44463b9358596e6856cf171c9af8dc7568d868bed"
  end

  resource "python-octaviaclient" do
    url "https://files.pythonhosted.org/packages/cb/db/2b36b092d5d5c9fa9da338464787f914a0983321b0ef4f93a6493f493975/python-octaviaclient-2.5.0.tar.gz"
    sha256 "4b871ddb39cafc9c25ca0196404ea60f9d70c348249494ed49600616b0117aa4"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/b4/d2/46d10a8735ce210d905f6a541125d3b77baca4cf455d6b25de70224678b7/python-swiftclient-3.13.1.tar.gz"
    sha256 "2d26c90b6392f6befa7fbb16fcda7be44aa26e2ae8a5bee2705d1d1c813833f0"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/e3/8e/1cde9d002f48a940b9d9d38820aaf444b229450c0854bdf15305ce4a3d1a/pytz-2021.3.tar.gz"
    sha256 "acad2d8b20a1af07d4e4c9d2e9285c5ed9104354062f275f3fcd88dcef4f1326"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "requestsexceptions" do
    url "https://files.pythonhosted.org/packages/82/ed/61b9652d3256503c99b0b8f145d9c8aa24c514caff6efc229989505937c1/requestsexceptions-1.4.0.tar.gz"
    sha256 "b095cbc77618f066d459a02b137b020c37da9f46d9b057704019c9f77dba3065"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/85/40/1520d68bfa07ab5a6f065a186815fb6610c86fe957bc065754e47f7b0840/rfc3986-2.0.0.tar.gz"
    sha256 "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/7a/47/c7cc3d4ed15f09917838a2fb4e1759eafb6d2f37ebf7043af984d8b36cf7/simplejson-3.17.6.tar.gz"
    sha256 "cf98038d2abf63a1ada5730e91e84c642ba6c225b0198c3684151b1f80c5f8a6"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/67/73/cd693fde78c3b2397d49ad2c6cdb082eb0b6a606188876d61f53bae16293/stevedore-3.5.0.tar.gz"
    sha256 "f40253887d8712eaa2bb0ea3830374416736dc8ec0e22f5a65092c1174c44335"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b0/b1/7bbf5181f8e3258efae31702f5eab87d8a74a72a0aa78bc8c08c1466e243/urllib3-1.26.8.tar.gz"
    sha256 "0e7c33d9a63e7ddfcb86780aac87befc2fbddf46c58dbb487e0855f7ceec283c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/eb/f6/d81ccf43ac2a3c80ddb6647653ac8b53ce2d65796029369923be06b815b8/wrapt-1.13.3.tar.gz"
    sha256 "1fea9cd438686e6682271d36f3481a9f3636195578bab9ca3382e2f5f01fc185"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"openstack", "-h"
    openstack_subcommands = [
      "server list",
      "stack list",
      "loadbalancer list",
    ]
    openstack_subcommands.each do |subcommand|
      output = shell_output("#{bin}/openstack #{subcommand} 2>&1", 1)
      assert_match "Missing value auth-url required", output
    end
  end
end
