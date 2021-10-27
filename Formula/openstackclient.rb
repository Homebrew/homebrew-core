class Openstackclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for OpenStack"
  homepage "https://openstack.org"
  url "https://files.pythonhosted.org/packages/56/5b/5850ca55b17f63741f71f7b59cf3621e538390fb05a20fcf1225c3ec205a/python-openstackclient-5.6.0.tar.gz"
  sha256 "0abc6666378c5a7db83ec83515a8524fb6246a919236110169cc5c216ac997ea"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f53f4f87d36ac23076aa8c0f1f2fc316353701f0c15205571c6b231fda9ab1fb"
    sha256 cellar: :any,                 arm64_big_sur:  "415b02ee764eafb672868037245cd7a5ac9395a255eb8aca89552e10e07cf21c"
    sha256 cellar: :any,                 monterey:       "0c6192eb86ef2c9c47a03a8c7722afc9a4e6e86260b26248f55bd56ed58de60b"
    sha256 cellar: :any,                 big_sur:        "953f1b08d0d5a62c2f6f1d7c453304e4f72882694e21bdd09fd662d261f818cc"
    sha256 cellar: :any,                 catalina:       "19ba1bd67e9060f8fa1c1528f943aabdde4e29d978978513547ca7690392dfc3"
    sha256 cellar: :any,                 mojave:         "25b434146cf86bfcc3cf5745ad331ec5df7aca3e130fa07b688a853b78aa67b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19599b31e56cbde386d34b387e5f20198889ba623394e5f7e95f0190c60f4c30"
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
    url "https://files.pythonhosted.org/packages/31/5c/df2c032dab2a5b3913f47fba5daa565324e67d1a75b6be05ddc0d10e82bf/cmd2-2.2.0.tar.gz"
    sha256 "34cd12424d9e2835eff125146af3d9f4a4c2931c6bc5a3cea9790bd4f55756d9"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
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
    url "https://files.pythonhosted.org/packages/45/66/a943f702763c879e2754b46089a136ee1e58f0f720c58fa640c00281d3fd/iso8601-0.1.16.tar.gz"
    sha256 "36532f77cc800594e8f16641edae7f1baf7932f05d8e508545b95fc53c6dc85b"
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
    url "https://files.pythonhosted.org/packages/6b/35/400557d3df63269a4c010cbd4865910b3c1718fbfe8d83210b216cd3efcf/jsonpointer-2.1.tar.gz"
    sha256 "5a34b698db1eb79ceac454159d3f7c12a451a91f6334a4f638454327b7a89962"
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
    url "https://files.pythonhosted.org/packages/49/8b/200b710df1cfcfd2ec0aaacb4249b5865cc5ad6be0355c240f1a3e90bc4a/oslo.context-3.3.1.tar.gz"
    sha256 "f578ea38569cf0a677e2167178196b21a54175471358c4320ddfd5c97c52f4d1"
  end

  resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/7c/d8/a56cdadc3eb21f399327c45662e96479cb73beee0d602769b7847e857e7d/oslo.i18n-5.1.0.tar.gz"
    sha256 "6bf111a6357d5449640852de4640eae4159b5562bbba4c90febb0034abc095d0"
  end

  resource "oslo.log" do
    url "https://files.pythonhosted.org/packages/c6/25/27d09d4ca0138f154f7f3ded780ed884eeb9941b9351b3f14a6a4e6c0b29/oslo.log-4.6.0.tar.gz"
    sha256 "dad5d7ff1290f01132b356d36a1bb79f98a3929d5005cce73e849ed31b385ba7"
  end

  resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/d0/47/d99242e79519e7667fa12b287dc7e352aefc63f6a1739feac90999b8295e/oslo.serialization-4.2.0.tar.gz"
    sha256 "3007e1b017ad3754cce54def894054cbcd05887e85928556657434b0fc7e4d83"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/81/18/1ff06ea155e0902c329bcc096c4649b49b3d45d4e70b248704c180cbf27c/oslo.utils-4.10.0.tar.gz"
    sha256 "9646e6570ed08a79f21b03acfb60d32a3ac453d76304f8759b1211a59ce372cb"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/86/aef78bab3afd461faecf9955a6501c4999933a48394e90f03cd512aad844/packaging-21.0.tar.gz"
    sha256 "7dc96269f53a4ccec5c0670940a4281106dd0bb343f47b7471f779df49c2fbe7"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/35/8c/69ed04ae31ad498c9bdea55766ed4c0c72de596e75ac0d70b58aa25e0acf/pbr-5.6.0.tar.gz"
    sha256 "42df03e7797b796625b1029c0400279c7c34fd7df24a7d7818a1abb5b38710dd"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/81/ba/ead3c121d6e59ea4e31bba0976b28ff0369210c66901e84fad20878299e2/prettytable-2.2.1.tar.gz"
    sha256 "6d465005573a5c058d4ca343449a5b28c21252b86afcdfa168cdc6a440f0b24c"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
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
    url "https://files.pythonhosted.org/packages/f9/57/328653fd8a631d81b2d71261e471a102d5b64a95c1b1dda1a55b053bf0db/stevedore-3.4.0.tar.gz"
    sha256 "59b58edb7f57b11897f150475e7bc0c39c5381f0b8e3fa9f5c20ce6c89ec4aa1"
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
    url "https://files.pythonhosted.org/packages/57/f0/b9c4beb5be22485ff0f09427dcc4e483dbf3a34fd5afb4f93cd6c68b2fac/wrapt-1.13.2.tar.gz"
    sha256 "dca56cc5963a5fd7c2aa8607017753f534ee514e09103a6c55d2db70b50e7447"
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
