class Openstackclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for OpenStack"
  homepage "https://openstack.org"
  url "https://files.pythonhosted.org/packages/26/b5/79ea3fa081717d0e2d6413431e76d902b9515e4a7dba72b036966bad71a0/python_openstackclient-8.3.0.tar.gz"
  sha256 "cc7b32e45f0b8eed9215e0218aea02526619a5e7b0682b2781769134afd76ff8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dfbf79e0d8da28ef0d761e6c67b02755df6d48995d9dda13e86ece643082c09d"
    sha256 cellar: :any,                 arm64_sequoia: "09ca4d317366bf1f0de5bee3dbc884339b7e518f283a4297907f92cc4c3e8fe7"
    sha256 cellar: :any,                 arm64_sonoma:  "4246ac6a6d016fba533bb8d310bdf3d67c2a2a185c333aaf3f421c5dd1b849e9"
    sha256 cellar: :any,                 sonoma:        "d544afa760ed4c8f4af80d0adb280c5134e847d215441090dbd9abf7d6870e29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24857180778e98d9b7715be861e8dd8cc36c47658dcd14022f9b7245cdd24086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "300391774c862eb5ee1558d86f15fee654a7bb5b796aa099e0232d7d2c843af7"
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
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "autopage" do
    url "https://files.pythonhosted.org/packages/9f/9e/559b0cfdba9f3ed6744d8cbcdbda58880d3695c43c053a31773cefcedde3/autopage-0.5.2.tar.gz"
    sha256 "826996d74c5aa9f4b6916195547312ac6384bac3810b8517063f293248257b72"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/26/a4/21798803bcc0c096f6d6d8977a02f6b04b6d9681fcb50d876ae7c65417f6/cliff-4.13.1.tar.gz"
    sha256 "b79cc0b2c19f6c6e78c82bd923e06785035d77cb0d2a1a483229f0a2836f0ca7"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/c7/f7/224338332fd867dcef9004a7d576b3909b5b27a6686d42a1cfa31ee6d1a1/cmd2-3.1.0.tar.gz"
    sha256 "cce3aece018b0b1055988adaa2b687ac9c1df38bfd2abfc29dbeb51a9707de33"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/31/e2/a45b5a620145937529c840df5e499c267997e85de40df27d54424a158d3c/debtcollector-3.0.0.tar.gz"
    sha256 "2a8917d25b0e1f1d0d365d3c1c6ecfc7a522b1e9716e8a1a4a915126f7ccea6f"
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
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
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
    url "https://files.pythonhosted.org/packages/6a/0a/eebeb1fa92507ea94016a2a790b93c2ae41a7e18778f85471dc54475ed25/jsonpointer-3.0.0.tar.gz"
    sha256 "2b2d729f2091522d61c3b31f82e11870f60b68f43fbc705cb76bf4b832af59ef"
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
    url "https://files.pythonhosted.org/packages/e5/16/b96df223ca7ea4bfa78034b205e0eaf4875bfecb2f119f375fc5232d2061/keystoneauth1-5.12.0.tar.gz"
    sha256 "dd113c2f3dcb418d9f761c73b8cd43a96ddfa8a612b51c576822381f39ca4ae8"
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
    url "https://files.pythonhosted.org/packages/6d/c9/c6f5ab81bae667d4fe42a58df29f4c2db6ad8377cfd0e9baa729e4fa3ebb/multipart-1.3.0.tar.gz"
    sha256 "a46bd6b0eb4c1ba865beb88ddd886012a3da709b6e7b86084fc37e99087e5cf1"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/54/90/188b2a69654f27b221fba92fda7217778208532c962509e959a9cee5229d/netaddr-1.3.0.tar.gz"
    sha256 "5c3c3d9895b551b763779ba7db7a03487dc1f8e3b385af819af341ae9ef6e48a"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/46/24/1167097740136e302c74043c1c6feecf8d757b052d7b457960e0dc60fa03/openstacksdk-4.8.0.tar.gz"
    sha256 "4dc038e1c17d893005f3a0a8951456afd9d148f3f65d448f94adcceb278d7f31"
  end

  resource "os-client-config" do
    url "https://files.pythonhosted.org/packages/50/cd/352f6f18d1fb90780b95fdc3a668a279bd41d89905d70ee06076b529077c/os_client_config-2.3.0.tar.gz"
    sha256 "e16a260f2fd500af14f157b9b7b7d69292ce83b0f8a461ec68ce6a8a42967cbd"
  end

  resource "os-service-types" do
    url "https://files.pythonhosted.org/packages/51/62/31e39aa8f2ac5bff0b061ce053f0610c9fe659e12aeca20bfb26d1665024/os_service_types-1.8.2.tar.gz"
    sha256 "ab7648d7232849943196e1bb00a30e2e25e600fa3b57bb241d15b7f521b5b575"
  end

  resource "osc-lib" do
    url "https://files.pythonhosted.org/packages/9a/ea/d2916e572035de9602437b0ff5b3969504371e87d06880fa9e1624d7bc16/osc_lib-4.3.0.tar.gz"
    sha256 "4f7f682c0e7df187aecba5bbbb5ee64796a2da03d23cba981245bdc27f6f8b97"
  end

  resource "osc-placement" do
    url "https://files.pythonhosted.org/packages/7d/d8/7ff585ba924327284eb0f9d16d22f63eb9b9aace9872d90166d865841336/osc_placement-4.7.0.tar.gz"
    sha256 "3efb10ee5823288fc4d9afaed75baae836b86c69aa8d233f3e48757fe30936a6"
  end

  resource "oslo-config" do
    url "https://files.pythonhosted.org/packages/25/b4/91cc92f141ed1bb9c9e46a84c6407074f391cfd0997b25c649cd725761ff/oslo_config-10.2.0.tar.gz"
    sha256 "6d282113f2fb2ee4d40c8becdb4ac39917c3f447c3bb355abf47f0d6181edffc"
  end

  resource "oslo-context" do
    url "https://files.pythonhosted.org/packages/17/56/07d71967a0b0ed3e4409df64b9aaa023ffc2cf3452e042bcd6559e329da9/oslo_context-6.2.0.tar.gz"
    sha256 "465c67da4d92dc2960deec148dee469d7ae7736af869581e2e3b73ce2cfa27a8"
  end

  resource "oslo-i18n" do
    url "https://files.pythonhosted.org/packages/4d/58/9d4a11a838f174180606f71a8eeeb0a443e98e28798d87c150be732c0d32/oslo_i18n-6.7.1.tar.gz"
    sha256 "7dc879089056fe287a6fb46fa2e73ad88f8d4b989bd63f00486f494435b24ced"
  end

  resource "oslo-log" do
    url "https://files.pythonhosted.org/packages/d9/95/b16153fa2fa16f25b496be7a23b07774e25b9169473c57c1fc41bb693693/oslo_log-8.0.0.tar.gz"
    sha256 "d3e0c67a509fca99e9b76eaedcb2fa8c5a1140659de8a50d5a4df6a3fa933227"
  end

  resource "oslo-serialization" do
    url "https://files.pythonhosted.org/packages/de/da/c7568b0d6e1e0d442178240bc22c1701a69d9592b1e132e1292769704529/oslo_serialization-5.9.0.tar.gz"
    sha256 "5dd15a7f2ffaed25e8d3c295ee305d3b864b04e4ae3d705ad9e628d5ab8a82f8"
  end

  resource "oslo-utils" do
    url "https://files.pythonhosted.org/packages/12/fe/22b08a1234826f3baace1d46494f764625a6e6753b8e4b3809aa93ae35b3/oslo_utils-9.2.0.tar.gz"
    sha256 "1f42006de6b9291a0305025f5ccdb8907120d88ed7ebc3784a1472a3328048ab"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/5e/ab/1de9a4f730edde1bdbbc2b8d19f8fa326f036b4f18b2f72cfbea7dc53c26/pbr-7.0.3.tar.gz"
    sha256 "b46004ec30a5324672683ec848aed9e8fc500b0d261d40a3229c2d2bbfcedc29"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/86/0248f086a84f01b37aaec0fa567b397df1a119f73c16f6c7a9aac73ea309/platformdirs-4.5.1.tar.gz"
    sha256 "61d5cdcc6065745cdd94f0f878977f8de9437be93de97c1c12f853c9c0cdcbda"
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
    url "https://files.pythonhosted.org/packages/73/cb/09e5184fb5fc0358d110fc3ca7f6b1d033800734d34cac10f4136cfac10e/psutil-7.2.1.tar.gz"
    sha256 "f7583aec590485b43ca601dd9cea0dcd65bd7bb21d30ef4ddbf4ea6b5ed1bdd3"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/80/be/97b83a464498a79103036bc74d1038df4a7ef0e402cfaf4d5e113fb14759/pyopenssl-25.3.0.tar.gz"
    sha256 "c981cb0a3fd84e8602d7afc209522773b94c1c2446a3c710a75b06fe1beae329"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/33/c1/1d9de9aeaa1b89b0186e5fe23294ff6517fce1bc69149185577cd31016b2/pyparsing-3.3.1.tar.gz"
    sha256 "47fad0f17ac1e2cad3de3b458570fbc9b03560aa029ed5e16ee5554da9a2251c"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "python-barbicanclient" do
    url "https://files.pythonhosted.org/packages/b9/2e/cca8be3d14fceea564115ffc1e7e1a219620127f5050c31edd2c12347f35/python_barbicanclient-7.2.0.tar.gz"
    sha256 "4b085b01597442e620658017aeddc6df313a9b0a6c629d13c463b9dc39bf1579"
  end

  resource "python-cinderclient" do
    url "https://files.pythonhosted.org/packages/56/9d/a0e1283639bcd98ac8f7a991c1ba2c6efd82ed0747246e993da1eca192b9/python_cinderclient-9.8.0.tar.gz"
    sha256 "bd3ee9f9487c5e79957f018a6b3f2dece7059dad8f6155d83dd4b6eb9447a11d"
  end

  resource "python-cloudkittyclient" do
    url "https://files.pythonhosted.org/packages/3e/0e/38540fa99bce5ebdd4a15268d66ce347cc4bf21f904ed7a5d7dbefae8b90/python_cloudkittyclient-5.4.0.tar.gz"
    sha256 "94f2cf00387b873907cad710216df0bfeaface3186fd5da1cfe0b1502f9a2183"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-designateclient" do
    url "https://files.pythonhosted.org/packages/31/03/96a90b0a83c8e033a8d8d679e457acad18439f5de4a8a1b4a826ff02c412/python_designateclient-6.3.0.tar.gz"
    sha256 "9aabf25e5ff69b15fb6209f9851c507d9499e63c6926245672ff0e495986e778"
  end

  resource "python-glanceclient" do
    url "https://files.pythonhosted.org/packages/fc/96/e0e2ea7258cb3825be4aa0c19372a182b5c17788660d9985090fe81f6ae5/python_glanceclient-4.10.0.tar.gz"
    sha256 "ff6c2d42a1767c5cfa3cd1d22a3732d38ab113d471ad22c4ee64a1bd3941b103"
  end

  resource "python-heatclient" do
    url "https://files.pythonhosted.org/packages/6b/38/1a6a0def362dae922e559c1dfcb553c3be8b3b859fd0943a12a697d9271f/python_heatclient-4.3.0.tar.gz"
    sha256 "8ada7ceb77f25f0dbe3ae2e3328a30461adb94ffbf36b0c2aabc2cce483b75f0"
  end

  resource "python-ironicclient" do
    url "https://files.pythonhosted.org/packages/59/be/311283b658a03e92132fecd9c512b0b9a09cf5845485b00111211d2a0377/python_ironicclient-5.14.0.tar.gz"
    sha256 "a0718beb15a496b6f949fa18fd68e02946362c32a9feaa19f02a924666689585"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/94/29/3775d7a722924a72208753a8aa5ddb0a58de24f5a5dd287cc9a0f66038e4/python_keystoneclient-5.7.0.tar.gz"
    sha256 "8ce7bf1c8cddca6d7140fc76918b44eddf1d64040a60cb8ff7059136104d4ceb"
  end

  resource "python-magnumclient" do
    url "https://files.pythonhosted.org/packages/4f/39/b0ea864817d58a1bfdb371602e3bd8243a781c6d7f0f57a95b60e4556799/python_magnumclient-4.9.0.tar.gz"
    sha256 "35a02326271860e8072e33891f0fa1596509ab91319fed129b5c565f17bb8ec9"
  end

  resource "python-manilaclient" do
    url "https://files.pythonhosted.org/packages/18/de/2749f6509268abe3798d7c1248db9cfef3a40ae0a525b619c7b62c130aa6/python_manilaclient-5.7.1.tar.gz"
    sha256 "05d154567bd25fbca2b474a53ff1b30f68f3bc5f2f87d078415550aea6305bd4"
  end

  resource "python-mistralclient" do
    url "https://files.pythonhosted.org/packages/38/d3/fa818a383d029a7e96baf80a84be3da9d7f6456c79ee227e08ac53d7deea/python_mistralclient-6.1.0.tar.gz"
    sha256 "0327bdf768e0ad895a2ffc93f2c4dca0a6e81a13e0f0abf643d07ac519c02cc0"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/6b/fb/05dc03d2aa2c2f4dad3a1ae043022c8382235813dd3af5971d7fc583af81/python_neutronclient-11.7.0.tar.gz"
    sha256 "6f4970bd60f415289c01bddf381f17503e188427597682caae0a2d253a6eb533"
  end

  resource "python-octaviaclient" do
    url "https://files.pythonhosted.org/packages/1f/e3/a4c11c5fa401d99320494eaa2687104c8164916a3d9084570f5ffa28642f/python_octaviaclient-3.12.0.tar.gz"
    sha256 "e5badfc64a49428bac11c5e5d187abcd80e3adf9745f2595d115cf4f3d78e98e"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/36/33/be8b0b894f92f45877cd314a9cf6478001af77a53179adf833a296e792ff/python_swiftclient-4.9.0.tar.gz"
    sha256 "9e207b82ec31786f10db8fef6e205681c24997a0b600d28a194f9d15a90ed772"
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
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
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
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "rich-argparse" do
    url "https://files.pythonhosted.org/packages/4c/f7/1c65e0245d4c7009a87ac92908294a66e7e7635eccf76a68550f40c6df80/rich_argparse-1.7.2.tar.gz"
    sha256 "64fd2e948fc96e8a1a06e0e72c111c2ce7f3af74126d75c0f5f63926e7289cd1"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/96/5b/496f8abebd10c3301129abba7ddafd46c71d799a70c44ab080323987c4c9/stevedore-5.6.0.tar.gz"
    sha256 "f22d15c6ead40c5bbfa9ca54aa7e7b4a07d59b36ae03ed12ced1a54cf0b51945"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/5e/a7/c202b344c5ca7daf398f3b8a477eeb205cf3b6f32e7ec3a6bac0629ca975/tzdata-2025.3.tar.gz"
    sha256 "de39c2ca5dc7b0344f2eba86f49d614019d29f060fc4ebc8a417896a620b56a7"
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
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/49/2a/6de8a50cb435b7f42c46126cf1a54b2aab81784e74c8595c8e025e8f36d3/wrapt-2.0.1.tar.gz"
    sha256 "9c9c635e78497cacb81e84f8b11b23e0aacac7a136e73b8e5b2109a1d9fc468f"
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
