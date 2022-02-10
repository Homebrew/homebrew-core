class Openstackclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for OpenStack"
  homepage "https://openstack.org"
  url "https://files.pythonhosted.org/packages/33/fb/1b529a396e56e258bc6bfb49c0d1be3792aea7f6e0570c908bc0641df2ed/python-openstackclient-5.7.0.tar.gz"
  sha256 "c65e3d51018f193cce2daf3d0fd69daa36003bdb2b85df6b07b973e4c39e2f92"
  license "Apache-2.0"
  revision 2

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
    url "https://files.pythonhosted.org/packages/b9/bf/db4efe85bfc10ed5598999a10dd2dd2da6d2daafb8a26c0005fcb31201e9/autopage-0.4.0.tar.gz"
    sha256 "18f511d8ef2e4d3cc22a986d345eab0e03f95b9fa80b74ca63b7fb001551dc42"
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
    url "https://files.pythonhosted.org/packages/68/e4/e014e7360fc6d1ccc507fe0b563b4646d00e0d4f9beec4975026dd15850b/charset-normalizer-2.0.9.tar.gz"
    sha256 "b0b883e8e874edfdece9c28f314e3dd5badf067342e42fb162203335ae61aa2c"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/57/1b/b7d2103c3e703e955a88716a82a0462736c741d09e378ffb1586e1629341/cliff-3.10.0.tar.gz"
    sha256 "c68aac08d0d25853234a38fdbf1f33503849af3d5d677a4d0aacd42b0be6a4a1"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/3e/56/82be7e9c7f2de572e2c618f5c5be6ada5038978e4732f37f5d47fe0d3170/cmd2-2.3.3.tar.gz"
    sha256 "750d7eb04d55c3bc2a413e191bc177856f388102de47d11f2210a35266543640"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/f9/4b/1cf8e281f7ae4046a59e5e39dd7471d46db9f61bb564fddbff9084c4334f/cryptography-36.0.1.tar.gz"
    sha256 "53e5c1dc3d7a953de055d77bef2ff607ceef7a2aac0353b5d630ab67f7423638"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/23/6f/9fc10962c01ff8935df8a41f16776a1cce5f4c2aea4300a6f752d4c0fd7b/debtcollector-2.3.0.tar.gz"
    sha256 "c7a9fac814ab5904e23905516b18356cc907e7d27c05da58d37103f001967846"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/92/3c/34f8448b61809968052882b830f7d8d9a8e1c07048f70deb039ae599f73c/decorator-5.1.0.tar.gz"
    sha256 "e59913af105b9860aa2c8d3272d9de5a56a4e608db9a2f167a8480b323d529a7"
  end

  resource "dogpile.cache" do
    url "https://files.pythonhosted.org/packages/a4/5a/2735b2db3b704f4fa134360842560456e7aea509c4519ada9a0333b6c236/dogpile.cache-1.1.4.tar.gz"
    sha256 "ea09bebf24bb7c028caf98963785fe9ad0bd397305849a3303bc5380d468d813"
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
    url "https://files.pythonhosted.org/packages/f7/28/47ef88c3501db04187fd1905976ebec3c9dc2e09c6cc414a8412f805ce89/keystoneauth1-4.4.0.tar.gz"
    sha256 "34662a6be67ab29424aabe6f99a8d7eb6b88d293109a07e60fea123ebffb314f"
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
    url "https://files.pythonhosted.org/packages/ca/9f/8ba3627e2ebebb663aaa8874e3c218cbb3ec9509624665823fa8acc1edf6/osc-lib-2.4.2.tar.gz"
    sha256 "d6b530e3e50646840a6a5ef134e00f285cc4a04232c163f28585226ed40cc968"
  end

  resource "oslo.config" do
    url "https://files.pythonhosted.org/packages/5a/97/44d9370a7d73f38e79d5bf0c6fef82c526d9ac580d2aabacedf177430dad/oslo.config-8.7.1.tar.gz"
    sha256 "a0c346d778cdc8870ab945e438bea251b5f45fae05d6d99dfe4953cca2277b60"
  end

  resource "oslo.context" do
    url "https://files.pythonhosted.org/packages/7d/ef/b04cc84662647dc1b564c8f4c31758dde607431905e175565b4bafe80c5d/oslo.context-3.4.0.tar.gz"
    sha256 "970f96361c5de9a5dc86d48a648289d77118180ca13ba5eeb307137736ffa953"
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
    url "https://files.pythonhosted.org/packages/d0/47/d99242e79519e7667fa12b287dc7e352aefc63f6a1739feac90999b8295e/oslo.serialization-4.2.0.tar.gz"
    sha256 "3007e1b017ad3754cce54def894054cbcd05887e85928556657434b0fc7e4d83"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/c0/91/e8c7f3dd7c3f765a91d3dbc4dafb35858ed0bc0bbff44ec84479bd06e55a/oslo.utils-4.12.0.tar.gz"
    sha256 "37aa1ee2c6cd8f3933912dd4323cbf7cd2d141e6dedb3debb764e491a9c9cf4d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/f5/0c/3fa7b1f9006e4d454a49b48eac995167cf8617e19375c6963a6b048af0d0/pbr-5.8.0.tar.gz"
    sha256 "672d8ebee84921862110f23fcec2acea191ef58543d34dfe9ef3d9f13c31cddf"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/e4/35/21bf22e21b29102bbe81730caf498dfb3e1eed2642ac71f323472ead673a/prettytable-2.5.0.tar.gz"
    sha256 "f7da57ba63d55116d65e5acb147bfdfa60dceccabf0d607d6817ee2888a05f2c"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/ab/61/1a1613e3dcca483a7aa9d446cb4614e6425eb853b90db131c305bd9674cb/pyparsing-3.0.6.tar.gz"
    sha256 "d9bdec0013ef1eb5a84ab39a3b3868911598afa494f5faa038647101504e2b81"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "python-cinderclient" do
    url "https://files.pythonhosted.org/packages/60/c2/e4c0cb70454ae4f835a321095fcab5494458c36fe090306e143444d1d8ab/python-cinderclient-8.2.0.tar.gz"
    sha256 "7b2f08a2d1cc05d2c1f84f02fadb2208678b1acb501acfe2de33720078ec7b9f"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-heatclient" do
    url "https://files.pythonhosted.org/packages/b3/48/a1400b21fe151a4cac4d664cdbf043255e164dbf97600dab79838e6c8815/python-heatclient-2.5.0.tar.gz"
    sha256 "b610748eb3f18f6bd762e0808accdf872308289a77c3b19ed2d8b9f306393a42"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/6d/56/6e3ddf108853f98f79946be61e296ee14dfb45142c72f49d31000f7da320/python-keystoneclient-4.3.0.tar.gz"
    sha256 "fd09b7790ce53c20dc94318ec4d76e1cf71908aed59baeb4c7a61c17afd3aad5"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/f8/c2/8c9b6ee2f950c816d646ae06bb6cb11845b9d6bb5f17ff6946f7f5afbfac/python-neutronclient-7.7.0.tar.gz"
    sha256 "9190174b1b848ff9d7fff1a131f76c045dc90f59dc03448ae27c4a89f925fffc"
  end

  resource "python-novaclient" do
    url "https://files.pythonhosted.org/packages/12/2f/bdb696db04834170a5322e8cf3f9b8152be24a74d16437e70f49c9ec90cc/python-novaclient-17.6.0.tar.gz"
    sha256 "c910c2085310da635fb343585f1070712ff0f9cb3c8f79d44ca3d632c4f230f5"
  end

  resource "python-octaviaclient" do
    url "https://files.pythonhosted.org/packages/6d/86/477ffbbf306ad38473f6819f5343a261e706033c52e00ec2dda41bd3e57f/python-octaviaclient-2.4.0.tar.gz"
    sha256 "ee3ef8b30c884141689aee70e75d4fc9695e601dad6e48e2e4338636fe86c7a0"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/20/e6/3a06a6a6209162394dd347d47431ddd22e8be30536ba1e15c69a9f524fac/python-swiftclient-3.13.0.tar.gz"
    sha256 "b200dcfbc6842bd4cac29efd0ea9ef34d3b8625957472ba7aa3ae0242437e2cc"
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
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "requestsexceptions" do
    url "https://files.pythonhosted.org/packages/82/ed/61b9652d3256503c99b0b8f145d9c8aa24c514caff6efc229989505937c1/requestsexceptions-1.4.0.tar.gz"
    sha256 "b095cbc77618f066d459a02b137b020c37da9f46d9b057704019c9f77dba3065"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/79/30/5b1b6c28c105629cc12b33bdcbb0b11b5bb1880c6cfbd955f9e792921aa8/rfc3986-1.5.0.tar.gz"
    sha256 "270aaf10d87d0d4e095063c65bf3ddbc6ee3d0b226328ce21e036f946e421835"
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
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
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
