class Openstackclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for OpenStack"
  homepage "https://openstack.org"
  url "https://files.pythonhosted.org/packages/33/fb/1b529a396e56e258bc6bfb49c0d1be3792aea7f6e0570c908bc0641df2ed/python-openstackclient-5.7.0.tar.gz"
  sha256 "c65e3d51018f193cce2daf3d0fd69daa36003bdb2b85df6b07b973e4c39e2f92"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8ddf40fc38f28ad64030d53bcda4253077d4282d1a4ba1f470e837e3b7a0e79f"
    sha256 cellar: :any,                 arm64_big_sur:  "cc77d419943f40f25367a41948b3569baba7f1bf8b49ea28b370c9ea3d1e2a72"
    sha256 cellar: :any,                 monterey:       "39969d6bd0c471b69a7305a26f662d9f78fe94364a292d4e6d169b203af22f91"
    sha256 cellar: :any,                 big_sur:        "20e40b2d403120c027d833bcf208d63978b329b163f35d34c8eb69d796a98c5b"
    sha256 cellar: :any,                 catalina:       "b5cb9933f22cc7eb1e2c9d0f9f1f1adacc6d51a88a1e1d0180be716138027735"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15407bed1e7c6f4c790a8c5fcf5f44ac667c6ea5ed28cffbfbac031af14de389"
  end

  depends_on "rust" => :build
  depends_on "python@3.10"
  depends_on "six"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
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
    url "https://files.pythonhosted.org/packages/9f/c5/334c019f92c26e59637bb42bd14a190428874b2b2de75a355da394cf16c1/charset-normalizer-2.0.7.tar.gz"
    sha256 "e019de665e2bcf9c2b64e2e5aa025fa991da8720daa3c1138cadd2fd1856aed0"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/a4/c3/b9c47664219610a890edeb74d0c47e304e4324d2e1e283705d9a4e8eda3a/cliff-3.9.0.tar.gz"
    sha256 "95363e9b43e2ec9599e33b5aea27a6953beda2d0673557916fa4f5796857daa3"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/87/06/2cf7c7f48e3aa22cecb072bb503dc8d46177420b163275b2903e872b52e7/cmd2-2.3.0.tar.gz"
    sha256 "2493ab8e5baab3d1a0325ea50920674a63de41bee4c63a634ac5cb42bfd63c1b"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/10/91/90b8d4cd611ac2aa526290ae4b4285aa5ea57ee191c63c2f3d04170d7683/cryptography-35.0.0.tar.gz"
    sha256 "9933f28f70d0517686bd7de36166dda42094eac49415459d9bdf5e7df3e0086d"
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
    url "https://files.pythonhosted.org/packages/f9/bd/425a807d88c83768f282010a65031223f37c41e7f485bdd92ba00d1832e1/iso8601-1.0.0.tar.gz"
    sha256 "79ec9749f8bf35ffae77f835e80e96d2f95affa0f79d3d7b25c0fa7e06207a8b"
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
    url "https://files.pythonhosted.org/packages/59/04/87fc6708659c2ed3b0b6d4954f270b6e931def707b227c4554f99bd5401e/msgpack-1.0.2.tar.gz"
    sha256 "fae04496f5bc150eefad4e9571d1a76c55d021325dcd484ce45065ebbdd00984"
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
    url "https://files.pythonhosted.org/packages/c3/23/30cd6b7e710980234be264270a60b0b26ed9eca88119d23cd50de404dd1d/openstacksdk-0.59.0.tar.gz"
    sha256 "3df760cd272398abfac8cebe62eeb82cbc497bb25d4dd707576f74a8ce9abf0d"
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
    url "https://files.pythonhosted.org/packages/8d/c9/92456ecd15f1d391c1674ff461a913b6d8e59d6b0decb30af57848d62e3b/oslo.utils-4.11.0.tar.gz"
    sha256 "6ea03d3c5c917c98a2ecb27a7c923e424027592fc0f26886fb4f7eaf24c983f2"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/4d/34/523195b783e799fd401ad4bbc40d787926dd4c61838441df08bf42297792/packaging-21.2.tar.gz"
    sha256 "096d689d78ca690e4cd8a89568ba06d07ca097e3306a4381635073ca91479966"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/69/7e/e420b9b6b06f9597827571e871f9492512701497971a4cf3f4638c03bc7a/pbr-5.7.0.tar.gz"
    sha256 "4651ca1445e80f2781827305de3d76b3ce53195f2227762684eb08f17bc473b7"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/ea/36/a96f1d0f434e1658b3fde011df028efdc3d38bde563339f0fc9e8beadc59/prettytable-2.4.0.tar.gz"
    sha256 "18e56447f636b447096977d468849c1e2d3cfa0af8e7b5acfcf83a64790c0aca"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "python-cinderclient" do
    url "https://files.pythonhosted.org/packages/1c/40/3973554e3b377153ec9498f4d55e6da0f0ee403487b28991e93cf5af1b65/python-cinderclient-8.1.0.tar.gz"
    sha256 "b57b432b2ac9161c2482a569a023211d2d3d0ada81c4da62c8f6e47f0b2bf82d"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-heatclient" do
    url "https://files.pythonhosted.org/packages/b1/68/3b8e2c058a6484b89eac6930947892789c1e0120f4fe9b8d95f850f59f6f/python-heatclient-2.4.0.tar.gz"
    sha256 "b53529eb73f08c384181a580efaa42293cc35e0e1ecc4b0bc14a5c7b202019bb"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/6d/56/6e3ddf108853f98f79946be61e296ee14dfb45142c72f49d31000f7da320/python-keystoneclient-4.3.0.tar.gz"
    sha256 "fd09b7790ce53c20dc94318ec4d76e1cf71908aed59baeb4c7a61c17afd3aad5"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/38/b3/98adb8796d95eb1603c3d765dcdfdfaaab74f7b433d3c0899fba42190469/python-neutronclient-7.6.0.tar.gz"
    sha256 "667807fdafc0096026872707971bb3d4221406eed8c14057f04cc6a3837bde22"
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
    url "https://files.pythonhosted.org/packages/5b/02/d20b866dabd7cecae658b7179691948abcf8d28f156b90a63b16c5729693/python-swiftclient-3.12.0.tar.gz"
    sha256 "313b444a14d0f9b628cbf3e8c52f2c4271658f9e8a33d4222851c2e4f0f7b7a0"
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
    url "https://files.pythonhosted.org/packages/01/52/41c71718f941c9a5abebfaa24e3c14e3c0229327b7ebd21348989845ed8f/simplejson-3.17.5.tar.gz"
    sha256 "91cfb43fb91ff6d1e4258be04eee84b51a4ef40a28d899679b9ea2556322fb50"
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
