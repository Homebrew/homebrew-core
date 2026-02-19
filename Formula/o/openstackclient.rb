class Openstackclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for OpenStack"
  homepage "https://openstack.org"
  url "https://files.pythonhosted.org/packages/6e/6e/7c48e37608b4af54a5e8471ccf33ae93cee10360c2e37601c860d0f6e5ee/python_openstackclient-9.0.0.tar.gz"
  sha256 "8cdca0a274ef5e423f31a07c7117432e4ce5b72d95e3eba5b06e1c831eb3018e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6b7f00bbd7ded49bb010be4b9273d6341227182c4bc7d96496949aa18c4a5273"
    sha256 cellar: :any,                 arm64_sequoia: "791d12ee5e5e4d595e9d996107bcd7b0be2d0be9a66c81b3f587e7b5911ddff8"
    sha256 cellar: :any,                 arm64_sonoma:  "017e40b8631487ddf55b2da2819de807235bc68001671433a26ebc3fadee112e"
    sha256 cellar: :any,                 sonoma:        "684e10a92399142eda33b6f7db902bed716aa5af9cb1b221601601c9f4ae11a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a54a8e3986605ef200f5d129783239700c9434a8ba456b055b0721a977aa1474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d280a1eff4afcf76a1e35c14e90f7c5d63370ae97a0bebafb63bf79248ef259"
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
    url "https://files.pythonhosted.org/packages/75/76/9078d8db91f29af9ac5a359757f63f2d0fa869aba704d5ef0f836db62ea1/autopage-0.6.0.tar.gz"
    sha256 "42d07de90de63e83762828028bfd56d19906a18f7c951ef6eef3e9ad48a3071d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/c2/ff/58b550ed138f67d2a8aa280021beeeccde5b09fe1b2725202d6f22478470/cliff-4.13.2.tar.gz"
    sha256 "e949b585b9b64549de87388cefd49e87dd63095ce2b9f3b98f9123d7cd94be1a"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/ad/97/81e6f73e1de0f4b77f4a560ed8c54c5971499ab92e955eab3b6e080201a5/cmd2-3.2.0.tar.gz"
    sha256 "d6f295c0c363e788439d5a35941573eca5953bba5acfa07f99e7e493ea9c01be"
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
    url "https://files.pythonhosted.org/packages/e5/2b/5a08163c8e878811f11dc8c78c041c2384cd424c71f75fb7a6b19969047f/keystoneauth1-5.13.0.tar.gz"
    sha256 "57c9ca407207899b50d8ff1ca8abb4a4e7427461bfc1877eb8519c3989ce63ec"
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
    url "https://files.pythonhosted.org/packages/7d/d8/7ff585ba924327284eb0f9d16d22f63eb9b9aace9872d90166d865841336/osc_placement-4.7.0.tar.gz"
    sha256 "3efb10ee5823288fc4d9afaed75baae836b86c69aa8d233f3e48757fe30936a6"
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
    url "https://files.pythonhosted.org/packages/d9/95/b16153fa2fa16f25b496be7a23b07774e25b9169473c57c1fc41bb693693/oslo_log-8.0.0.tar.gz"
    sha256 "d3e0c67a509fca99e9b76eaedcb2fa8c5a1140659de8a50d5a4df6a3fa933227"
  end

  resource "oslo-serialization" do
    url "https://files.pythonhosted.org/packages/2d/66/ec1b215f2a5005e43803d904ad537734cfabf499dd89f95988e2173e5867/oslo_serialization-5.9.1.tar.gz"
    sha256 "086ab78a15f33f02e647bdb3ca36632480d94cf661cf1fb118adebdeee5d4be7"
  end

  resource "oslo-utils" do
    url "https://files.pythonhosted.org/packages/12/fe/22b08a1234826f3baace1d46494f764625a6e6753b8e4b3809aa93ae35b3/oslo_utils-9.2.0.tar.gz"
    sha256 "1f42006de6b9291a0305025f5ccdb8907120d88ed7ebc3784a1472a3328048ab"
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
    url "https://files.pythonhosted.org/packages/1b/04/fea538adf7dbbd6d186f551d595961e564a3b6715bdf276b477460858672/platformdirs-4.9.2.tar.gz"
    sha256 "9a33809944b9db043ad67ca0db94b14bf452cc6aeaac46a88ea55b26e2e9d291"
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
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/80/be/97b83a464498a79103036bc74d1038df4a7ef0e402cfaf4d5e113fb14759/pyopenssl-25.3.0.tar.gz"
    sha256 "c981cb0a3fd84e8602d7afc209522773b94c1c2446a3c710a75b06fe1beae329"
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
    url "https://files.pythonhosted.org/packages/b9/2e/cca8be3d14fceea564115ffc1e7e1a219620127f5050c31edd2c12347f35/python_barbicanclient-7.2.0.tar.gz"
    sha256 "4b085b01597442e620658017aeddc6df313a9b0a6c629d13c463b9dc39bf1579"
  end

  resource "python-cinderclient" do
    url "https://files.pythonhosted.org/packages/56/9d/a0e1283639bcd98ac8f7a991c1ba2c6efd82ed0747246e993da1eca192b9/python_cinderclient-9.8.0.tar.gz"
    sha256 "bd3ee9f9487c5e79957f018a6b3f2dece7059dad8f6155d83dd4b6eb9447a11d"
  end

  resource "python-cloudkittyclient" do
    url "https://files.pythonhosted.org/packages/c7/19/01cecdccafa92c5f31ec94a53e9929455d9eda6a1d958da22fa2a329eae3/python_cloudkittyclient-6.0.0.tar.gz"
    sha256 "d345685a98aee9be15f3d1f6e0837efdc63d8b6024ca31f74619418a1190c3ac"
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
    url "https://files.pythonhosted.org/packages/e2/5b/964b5e714c28676171c9f58c857dd1f71d260813643c20cdf4cef17f3f91/python_heatclient-5.0.0.tar.gz"
    sha256 "ab70ad1be6d13e8f6034797a2894aeb43537dc4294ba7ffb0b4a417b56a1a71e"
  end

  resource "python-ironicclient" do
    url "https://files.pythonhosted.org/packages/bd/4d/203fddca56c094e0120d9d2a30a51d9210385c434e2a29055e45e0b1756a/python_ironicclient-5.15.0.tar.gz"
    sha256 "d62b238643cb36a7e844a6c2831836cc8e4f2b65828987d27b702cf3ac83b24d"
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
    url "https://files.pythonhosted.org/packages/74/99/a4cab2acbb884f80e558b0771e97e21e939c5dfb460f488d19df485e8298/rich-14.3.2.tar.gz"
    sha256 "e712f11c1a562a11843306f5ed999475f09ac31ffb64281f73ab29ffdda8b3b8"
  end

  resource "rich-argparse" do
    url "https://files.pythonhosted.org/packages/4c/f7/1c65e0245d4c7009a87ac92908294a66e7e7635eccf76a68550f40c6df80/rich_argparse-1.7.2.tar.gz"
    sha256 "64fd2e948fc96e8a1a06e0e72c111c2ce7f3af74126d75c0f5f63926e7289cd1"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/82/f3/748f4d6f65d1756b9ae577f329c951cda23fb900e4de9f70900ced962085/setuptools-82.0.0.tar.gz"
    sha256 "22e0a2d69474c6ae4feb01951cb69d515ed23728cf96d05513d36e42b62b37cb"
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
    url "https://files.pythonhosted.org/packages/35/a2/8e3becb46433538a38726c948d3399905a4c7cabd0df578ede5dc51f0ec2/wcwidth-0.6.0.tar.gz"
    sha256 "cdc4e4262d6ef9a1a57e018384cbeb1208d8abbc64176027e2c2455c81313159"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/f7/37/ae31f40bec90de2f88d9597d0b5281e23ffe85b893a47ca5d9c05c63a4f6/wrapt-2.1.1.tar.gz"
    sha256 "5fdcb09bf6db023d88f312bd0767594b414655d58090fc1c46b3414415f67fac"
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
