class Openstackclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for OpenStack"
  homepage "https://openstack.org"
  url "https://files.pythonhosted.org/packages/c7/f4/5dbae048f5dfbf4ce2814ae10781bce661724090cf7ea4ae84415bae6fc9/python-openstackclient-6.5.0.tar.gz"
  sha256 "12fc19347f6b19bfe2c36f11c7a1841f415a2ee7f18b959413c2121997b84951"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bff9fb70c5bfe3f1b15a0bfadbdac6f7eab3bc0a175c4ed7b0cf52ac797bacff"
    sha256 cellar: :any,                 arm64_ventura:  "b3ad561ea4de8a310a4dc8d6140527bea25664dca737c3c71c2d655c6bb16c50"
    sha256 cellar: :any,                 arm64_monterey: "46bf309885ba5495568ac257d8df06841baf9dc055da8934edbdba1d6b1b967a"
    sha256 cellar: :any,                 sonoma:         "ec7a9e501146ecaf63b0289bae3f5c73702d46950bf653f5e6e6a90f51d4cb07"
    sha256 cellar: :any,                 ventura:        "1e8a21a915107f67347eb180b0fd9500004bff5f5cfc87b2c63123baf778b34f"
    sha256 cellar: :any,                 monterey:       "08cf5846540c63e286e35a9d8b9dd89319b3b8dcffa58a3a62e6b5fde4afffee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8b5c5357c85cf4c7b2303256c7c4244cf5a073d48c23149e2f0fd45bafebabf"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-packaging"
  depends_on "python-pyparsing"
  depends_on "python-pytz"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

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
    url "https://files.pythonhosted.org/packages/7f/a3/f4b583e5639cf778cf7f6f915532729b1cf10175f09344dbda115c08c2ea/cliff-4.5.0.tar.gz"
    sha256 "61beeac238530beb3ae19eefb421b8b290b97dcc9efee01fc32fe62fb75a31d9"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/13/04/b85213575a7bf31cbf1d699cc7d5500d8ca8e52cbd1f3569a753a5376d5c/cmd2-2.4.3.tar.gz"
    sha256 "71873c11f72bd19e2b1db578214716f0d4f7c8fa250093c601265a9a717dee52"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/c8/7d/904f64535d04f754c20a02a296de0bf3fb02be8ff5274155e41c89ae211a/debtcollector-2.5.0.tar.gz"
    sha256 "dc9d1ad3f745c43f4bbedbca30f9ffe8905a8c028c9926e61077847d5ea257ab"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "dogpile-cache" do
    url "https://files.pythonhosted.org/packages/26/31/03bb01f10fc326388c5637747aa0f63a29a740061ff187c871913b75e273/dogpile.cache-1.3.0.tar.gz"
    sha256 "0a387f1932c071ee8fd971d2ff51f8aba1106c559439a51b8c74a207f40e215d"
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
    url "https://files.pythonhosted.org/packages/1e/84/6e64fe61d8dd7efffe81f0e43524e4f198b46420b114f7e4b5a7af4bfad1/keystoneauth1-5.5.0.tar.gz"
    sha256 "82722ca35946b2e102f89b42ae3fee8500314081e83477c2564096c167606457"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/c2/d5/5662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1/msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/af/96/f4878091248450bbdebfbd01bf1d95821bd47eb38e756815a0431baa6b07/netaddr-0.10.1.tar.gz"
    sha256 "f4da4222ca8c3f43c8e18a8263e5426c750a3a837fdfeccf74c68d0408eaa3bf"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/a6/91/86a6eac449ddfae239e93ffc1918cf33fd9bab35c04d1e963b311e347a73/netifaces-0.11.0.tar.gz"
    sha256 "043a79146eb2907edf439899f262b3dfe41717d34124298ed281139a8b93ca32"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/74/64/34f060db0dd07a71b4f8894ed271d52b0902d258c9cc0cb9636116d821f2/openstacksdk-2.1.0.tar.gz"
    sha256 "76c9b740a2cd625fcc6e9241614eef2a0934cb72354a5c587168f8fadef2e674"
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
    url "https://files.pythonhosted.org/packages/6e/6d/da26fd5fb1fd7ea45143e652b2ecaf61fd7bc3f0b894e020c0f2532f54f8/osc-lib-3.0.0.tar.gz"
    sha256 "06b5184a52b14aaee1d15a060635a0e343da84025f344ab36a2793e1254faaec"
  end

  resource "oslo-config" do
    url "https://files.pythonhosted.org/packages/14/7e/9cde8c7efbf82e29289e512409fadf3081a7ff99033f1b16ebed34082a36/oslo.config-9.3.0.tar.gz"
    sha256 "a4b1e526135d67c0e9b14d3ed299c6ec8a3887f92afcb26f4f3ea918504a3554"
  end

  resource "oslo-context" do
    url "https://files.pythonhosted.org/packages/bd/aa/6ffc977bc9503318d8992530b249113092aaa83961490991b24783829f5a/oslo.context-5.3.0.tar.gz"
    sha256 "c5107141c628b6ae56d4feb6322b9c4a70092fd6a181e91fabeade94a09e4e38"
  end

  resource "oslo-i18n" do
    url "https://files.pythonhosted.org/packages/a4/24/c4c441628dee6f6a34b8a433fb1e12853f066f9d0a0c7b7cf88cb8547b10/oslo.i18n-6.2.0.tar.gz"
    sha256 "70f8a4ce9871291bc609d07e31e6e5032666556992ff1ae53e78f2ed2a5abe82"
  end

  resource "oslo-log" do
    url "https://files.pythonhosted.org/packages/2b/d5/b3b9a02d09eb0b7c9d05958908b881e23182dac95d448377eb564598e52f/oslo.log-5.4.0.tar.gz"
    sha256 "2eb355b58570f25811da76fa81453b875c7c944a19a23d2c305b4a4dfebbd223"
  end

  resource "oslo-serialization" do
    url "https://files.pythonhosted.org/packages/08/13/29681b1a7841eca09c4f8a3d40c38e0e8e2cefb5a7a639fe59d68926be3b/oslo.serialization-5.3.0.tar.gz"
    sha256 "228898f4f33b7deabc74289b32bbd302a659c39cf6dda9048510f930fc4f76ed"
  end

  resource "oslo-utils" do
    url "https://files.pythonhosted.org/packages/05/28/e610cf99a3d2fd56b13a8fc56dec7ff3c9c7c1244698374ae12945ba2034/oslo.utils-7.0.0.tar.gz"
    sha256 "5263c00980cfab74f6635ef61d0fc91e6bd4a8dd0e78a77897ed6e447c8c6731"
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
    url "https://files.pythonhosted.org/packages/e1/c0/5e9c4d2a643a00a6f67578ef35485173de273a4567279e4f0c200c01386b/prettytable-3.9.0.tar.gz"
    sha256 "f4ed94803c23073a90620b201965e5dc0bccf1760b7a7eaf3158cab8aaffdf34"
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
    url "https://files.pythonhosted.org/packages/b7/0a/e3bdcc977e6db3bf32a3f42172f583adfa7c3604091a03d512333e0161fe/rpds_py-0.17.1.tar.gz"
    sha256 "0210b2668f24c078307260bf88bdac9d6f1093635df5123789bfee4d8d7fc8e7"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/79/79/3ccb95bb4154952532f280f7a41979fbfb0fbbaee4d609810ecb01650afa/simplejson-3.19.2.tar.gz"
    sha256 "9eb442a2442ce417801c912df68e1f6ccfcd41577ae7274953ab3ad24ef7d82c"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/ac/d6/77387d3fc81f07bc8877e6f29507bd7943569093583b0a07b28cfa286780/stevedore-5.1.0.tar.gz"
    sha256 "a54534acf9b89bc7ed264807013b505bf07f74dbe4bcfa37d32bd063870b087c"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/4d/60/acd18ca928cc20eace3497b616b6adb8ce1abc810dd4b1a22bc6bdefac92/tzdata-2023.4.tar.gz"
    sha256 "dd54c94f294765522c77399649b4fefd95522479a664a0cec87f41bebc6148c9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/cc/abf6746cc90bc52df4ba730f301b89b3b844d6dc133cb89a01cfe2511eb9/urllib3-2.2.0.tar.gz"
    sha256 "051d961ad0c62a94e50ecf1af379c3aba230c66c710493493560c0c223c49f20"
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
