class Openstackclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for OpenStack"
  homepage "https://openstack.org"
  url "https://files.pythonhosted.org/packages/c7/f4/5dbae048f5dfbf4ce2814ae10781bce661724090cf7ea4ae84415bae6fc9/python-openstackclient-6.5.0.tar.gz"
  sha256 "12fc19347f6b19bfe2c36f11c7a1841f415a2ee7f18b959413c2121997b84951"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "f458f2c093fd6bfe46f54f134dd161cb8b414b4292b98029ca61e07970d5f85b"
    sha256 cellar: :any,                 arm64_ventura:  "9f12223489912db8583154a42479f96215d20c9c24e09f3715f8b7b908e1e21a"
    sha256 cellar: :any,                 arm64_monterey: "3d0367dc89d423a2df6981b23c5fe29bd169d835e6d40249565178f9a903c650"
    sha256 cellar: :any,                 sonoma:         "b4d2fa3e135ec64600a396794f02922cc124778fd2f42a51edf934de4fa84e35"
    sha256 cellar: :any,                 ventura:        "2d871daa651f71c54a6e1f7e463ed0f3d1eb6989a6e5567720136aa3e0cb5f45"
    sha256 cellar: :any,                 monterey:       "cb7569a299c23a2cb83e67cc54e54edc23a008dec86c2756e2d81f5fc8adb068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c6dda3e4888041b4c111e2d8c0c7d4c85f6b9fbd21b5bd39d852b2975a57616"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python-cryptography"
  depends_on "python@3.12"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "autopage" do
    url "https://files.pythonhosted.org/packages/9f/9e/559b0cfdba9f3ed6744d8cbcdbda58880d3695c43c053a31773cefcedde3/autopage-0.5.2.tar.gz"
    sha256 "826996d74c5aa9f4b6916195547312ac6384bac3810b8517063f293248257b72"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/f6/e6/51643f6e211a4b5eb46b839ef37f2fad6b8b926899bb19bbd2c7c1f01498/cliff-4.6.0.tar.gz"
    sha256 "2f38ce8bd1ea4958d66f15b066ac47e65d61f600b9319b921e12e9e9cbcd99d0"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/13/04/b85213575a7bf31cbf1d699cc7d5500d8ca8e52cbd1f3569a753a5376d5c/cmd2-2.4.3.tar.gz"
    sha256 "71873c11f72bd19e2b1db578214716f0d4f7c8fa250093c601265a9a717dee52"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/31/e2/a45b5a620145937529c840df5e499c267997e85de40df27d54424a158d3c/debtcollector-3.0.0.tar.gz"
    sha256 "2a8917d25b0e1f1d0d365d3c1c6ecfc7a522b1e9716e8a1a4a915126f7ccea6f"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "dogpile-cache" do
    url "https://files.pythonhosted.org/packages/94/c9/99a8cc80eace8877845b08bbccc43147afdc9830f604cbd9f8619bfb0409/dogpile.cache-1.3.2.tar.gz"
    sha256 "4f71dc0333ad351c9c6f704f5ba2a37bf51c6eed0437d1adf56e075959afe63b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/b9/f3/ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15/iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/8f/5e/67d3ab449818b629a0ffe554bb7eb5c030a71f7af5d80fbf670d7ebe62bc/jsonpointer-2.4.tar.gz"
    sha256 "585cee82b70211fa9e6043b7bb89db6e1aa49524340dde8ad6b63206ea689d88"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/4d/c5/3f6165d3df419ea7b0990b3abed4ff348946a826caf0e7c990b65ff7b9be/jsonschema-4.21.1.tar.gz"
    sha256 "85727c00279f5fa6bedbe6238d2aa6403bedd8b4864ab11207d07df3cc1b2ee5"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/f8/b9/cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4b/jsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/b8/5a/90d7ae409bdefb9e7cd8e6024e29c33e051e3b20765a12fd88fb963769fe/keystoneauth1-5.6.0.tar.gz"
    sha256 "ecb7f34759ebe103db372ab0953c0b821929ddd497f332aa6b3ef6caacffed88"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/c2/d5/5662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1/msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/54/e6/0308695af3bd001c7ce503b3a8628a001841fe1def19374c06d4bce9089b/netaddr-1.2.1.tar.gz"
    sha256 "6eb8fedf0412c6d294d06885c110de945cf4d22d2b510d0404f4e06950857987"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/a6/91/86a6eac449ddfae239e93ffc1918cf33fd9bab35c04d1e963b311e347a73/netifaces-0.11.0.tar.gz"
    sha256 "043a79146eb2907edf439899f262b3dfe41717d34124298ed281139a8b93ca32"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/2e/5e/e5410863ea1fd45107ce23c169acebab54b5e7f6f61af9a7afee49bfec22/openstacksdk-3.0.0.tar.gz"
    sha256 "b0c7f9a025d5da92ad4c762941e6acc4cb53930a07ff739a9aebcc5e5a724ae6"
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
    url "https://files.pythonhosted.org/packages/73/f9/558baa104f8da7d952fe8dc9def38efd2bfc0291e04a4c4e458e4edf17df/osc-lib-3.0.1.tar.gz"
    sha256 "660aa523c5bec9f817671c4b43ac7d4b74f6a1c7f61b38c2ee35fd9384222456"
  end

  resource "oslo-config" do
    url "https://files.pythonhosted.org/packages/9f/79/d75e9a6234883adc93838602263d394ffaff6b8d315127c98afd596083f6/oslo.config-9.4.0.tar.gz"
    sha256 "35b11a661b608edb50305dad91e4e30819d90ef794b7d7dba5bd8b2ef2eb8c0d"
  end

  resource "oslo-context" do
    url "https://files.pythonhosted.org/packages/bf/7c/8d43182976b8273a3b49f39526b28da02fcc178cba367f5df7c29c79ef70/oslo.context-5.4.0.tar.gz"
    sha256 "e96491bbdd6b51e72a3a8c546a129b84d239e8e9e0b5210c8ba7c0a0a5629919"
  end

  resource "oslo-i18n" do
    url "https://files.pythonhosted.org/packages/c1/d6/7c48b3444e08a0ef7555747a11cddcadf32437cf3ba45b7722b3ab7b1ae0/oslo.i18n-6.3.0.tar.gz"
    sha256 "64a251edef8bf1bb1d4e6f78d377e149d4f15c1a9245de77f172016da6267444"
  end

  resource "oslo-log" do
    url "https://files.pythonhosted.org/packages/b5/9b/21cb487426ec7e39807a1996ae16325e62230de49f514638bf376ac15a72/oslo.log-5.5.0.tar.gz"
    sha256 "4cedd1669c7de28d8e66b67a5f6d6c6fe83928535fa87cd69bf6611b59f567e7"
  end

  resource "oslo-serialization" do
    url "https://files.pythonhosted.org/packages/21/ff/78cc62d4282cf26d322eedf7409a39f7cd5f8c1a83329dc0a65bfa545bd4/oslo.serialization-5.4.0.tar.gz"
    sha256 "315cb3465e99c685cb091b90365cb701bee7140e204ba3e5fc2d8a20b4ec6e76"
  end

  resource "oslo-utils" do
    url "https://files.pythonhosted.org/packages/1d/82/a81644eea01b60fa3fa32e9d376dd2730da82161be8f68d8805c9f05ec23/oslo.utils-7.1.0.tar.gz"
    sha256 "5e42f3394d1f1f976e8994ac4a0918966d2f7eaf7c77380dd612c4a4148dd98e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/8d/c2/ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24/pbr-6.0.0.tar.gz"
    sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/96/dc/c1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8/platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/19/d3/7cb826e085a254888d8afb4ae3f8d43859b13149ac8450b221120d4964c9/prettytable-3.10.0.tar.gz"
    sha256 "9665594d137fb08a1117518c25551e0ede1687197cf353a4fdc78d27e1073568"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/37/fe/65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44b/pyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "python-cinderclient" do
    url "https://files.pythonhosted.org/packages/92/b7/ed31992f6a680eda4096379d16d7ce49cb9d7647a299f22882dc35472b4f/python-cinderclient-9.4.0.tar.gz"
    sha256 "a53e6470a516627b59d22505222a0c85794be1a7f2774e87796105bd47ee9695"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-designateclient" do
    url "https://files.pythonhosted.org/packages/63/2e/ea881304a62ed94d3b27c4ef78ebf6ff0ba3e1bbbfe24ff917380b7d0de9/python-designateclient-6.0.0.tar.gz"
    sha256 "523ebbffa874d3a710dfc99c46e7fef71e8d0a35ae838f245512f8750dc574f4"
  end

  resource "python-heatclient" do
    url "https://files.pythonhosted.org/packages/fd/76/63a9d7e7ae02762fed9797d827cd209a3c510746e00aec96685486267bf2/python-heatclient-3.4.0.tar.gz"
    sha256 "8207e10c95b6aa7d28e168b971d3ec129a076fd9a265baf805af2680b912b6f2"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/b1/7c/8eeff2659a281a9eaf66bf1c754268cdea71510ef4d2a757fcf5ce312a11/python-keystoneclient-5.3.0.tar.gz"
    sha256 "bc5e7719f4156425dec77d75c3a79918e3d0b519378a16d8d7efa8849e4c2a79"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/1e/2d/c58cc8c8831fc433d415f3d30f5a84a5da0ade1e16e20fee962d4e4fa7b8/python-neutronclient-11.1.0.tar.gz"
    sha256 "f0a5cd6e3d8ce5a26fb0f88a932148a7a304148f6d8c68bc58e9ba1cc38d7798"
  end

  resource "python-novaclient" do
    url "https://files.pythonhosted.org/packages/c4/c6/4ee6c69bfc7a9e9dde92d946594735f638dcf4959e6e8da1b1d920b3f0d9/python-novaclient-18.4.0.tar.gz"
    sha256 "6b6b6ae2c11eb1c108e3af55eaa7211b0fc9199935a229a6ba3e0de514c12b50"
  end

  resource "python-octaviaclient" do
    url "https://files.pythonhosted.org/packages/ed/2d/5bfd38460b8857c0485075fac757d6546a4c080d003934a38c802465a07a/python-octaviaclient-3.6.0.tar.gz"
    sha256 "96488ab87bb4566f2d36a4a17eff97d57d9875e0966a9ae296aeaafbc23788d2"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/12/69/e6c03ad881aa63d9c1aada4613e463b0af384df406d358e502d2aeaf277a/python-swiftclient-4.4.0.tar.gz"
    sha256 "a77d97ab0e4012c678732e575bdfeed282b3489b9175e82c46a47ac8491eee84"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/21/c5/b99dd501aa72b30a5a87d488d7aa76ec05bdf0e2c7439bc82deb9448dd9a/referencing-0.33.0.tar.gz"
    sha256 "c775fedf74bc0f9189c2a3be1c12fd03e8c23f4d371dce795df44e06c5b412f7"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requestsexceptions" do
    url "https://files.pythonhosted.org/packages/82/ed/61b9652d3256503c99b0b8f145d9c8aa24c514caff6efc229989505937c1/requestsexceptions-1.4.0.tar.gz"
    sha256 "b095cbc77618f066d459a02b137b020c37da9f46d9b057704019c9f77dba3065"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/85/40/1520d68bfa07ab5a6f065a186815fb6610c86fe957bc065754e47f7b0840/rfc3986-2.0.0.tar.gz"
    sha256 "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/55/ba/ce7b9f0fc5323f20ffdf85f682e51bee8dc03e9b54503939ebb63d1d0d5e/rpds_py-0.18.0.tar.gz"
    sha256 "42821446ee7a76f5d9f71f9e33a4fb2ffd724bb3e7f93386150b61a43115788d"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/79/79/3ccb95bb4154952532f280f7a41979fbfb0fbbaee4d609810ecb01650afa/simplejson-3.19.2.tar.gz"
    sha256 "9eb442a2442ce417801c912df68e1f6ccfcd41577ae7274953ab3ad24ef7d82c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/e7/c1/b210bf1071c96ecfcd24c2eeb4c828a2a24bf74b38af13896d02203b1eec/stevedore-5.2.0.tar.gz"
    sha256 "46b93ca40e1114cea93d738a6c1e365396981bb6bb78c27045b7587c9473544d"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/74/5b/e025d02cb3b66b7b76093404392d4b44343c69101cc85f4d180dd5784717/tzdata-2024.1.tar.gz"
    sha256 "2674120f8d891909751c38abcdfd386ac0a5a1127954fbc332af6b5ceae07efd"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
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
