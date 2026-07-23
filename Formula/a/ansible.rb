class Ansible < Formula
  include Language::Python::Virtualenv

  desc "Automate deployment, configuration, and upgrading"
  homepage "https://www.ansible.com/"
  url "https://files.pythonhosted.org/packages/0d/8a/2800da95cacaabeda411db5bf54b97d1d953a03b5befc03a8a9486659ccb/ansible-14.2.0.tar.gz"
  sha256 "1c8f18399027d26b0175270cb63bad99f9be16efe79600242c914eaa49941025"
  license "GPL-3.0-or-later"
  compatibility_version 4
  head "https://github.com/ansible/ansible.git", branch: "devel"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "792ce5fe62450c46dfde6653788eb697f4e9bdf0d8a0578c91b3375c6898cdf7"
    sha256 cellar: :any, arm64_sequoia: "f8fb1c92cfb2532007182ef45d5ea7f5f551bdd4bc022704a72546c477f3dc33"
    sha256 cellar: :any, arm64_sonoma:  "f19fd4c791b31016fb6bdf83abf90c4c89baa03425bd03dc372c807df5ba3f23"
    sha256 cellar: :any, sonoma:        "687ea8b576b1a02d0d0ff16255cfd56f157232bfb68d5b109042eb2d6a563fe2"
    sha256 cellar: :any, arm64_linux:   "58f7f3e979d3c40ee7fc7b50396197c17fa175ff40ef9a6d6c0f179ab34eae35"
    sha256 cellar: :any, x86_64_linux:  "8a9e9fb56248ba89d1bd7df24bb5550079635ccc020aa39c8491e0e571638d0d"
  end

  # `pkgconf` and `rust` are for bcrypt
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libsodium" # for pynacl
  depends_on "libssh"
  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tree" # for ansible-role-init

  uses_from_macos "krb5"
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"
  uses_from_macos "openldap" # for python-ldap

  pypi_packages exclude_packages: %w[certifi cryptography gnureadline],
                extra_packages:   %w[ansible-pylibssh apache-libcloud boto3 dnspython docker
                                     fqdn junos-eznc jxmlease kerberos ntc-templates openshift
                                     passlib pexpect proxmoxer pynetbox pysphere3 python-consul
                                     python-ldap python-neutronclient pytz pywinrm requests-credssp
                                     shade zabbix-api]

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/ce/f4/eec0465c2f67b2664688d0240b3212d5196fd89e741df67ddb81f8d35658/aiohappyeyeballs-2.7.1.tar.gz"
    sha256 "065665c041c42a5938ed220bdcd7230f22527fbec085e1853d2402c8a3615d9d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/82/78/8ea7308cac6934de8c74a14f3d5f65d1c89287426688be79538d0e5c013d/aiohttp-3.14.1.tar.gz"
    sha256 "307f2cff90a764d329e77040603fa032db89c5c24fdad50c4c15334cba744035"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "ansible-core" do
    url "https://files.pythonhosted.org/packages/a1/6d/14fbdae14e7d02fd8349e6a52a76c144a1f92a2df3236c46bd7030cafdce/ansible_core-2.21.2.tar.gz"
    sha256 "c6139e662eda1bfb5af16029f12afa5edfc7f95f8cd44281b1bdb434a6d9dc70"
  end

  resource "ansible-pylibssh" do
    url "https://files.pythonhosted.org/packages/56/a9/1437294eb6e093c538262688d97979cc92407c033da92997d6e09348a248/ansible_pylibssh-1.4.0.tar.gz"
    sha256 "a48b5e6db21062bc6258548e6a3e4363043d40128f0e6b796774a59b6a7dbe82"
  end

  resource "apache-libcloud" do
    url "https://files.pythonhosted.org/packages/f0/ed/555a1869de19413efc270078632a8f9a049828ab65f2cc09fd61e6ba3f15/apache_libcloud-3.9.1.tar.gz"
    sha256 "b65eaa5ac32b28a0f9555e6a223dba39e73b99b682cd849624587ce7bc251661"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "autopage" do
    url "https://files.pythonhosted.org/packages/75/76/9078d8db91f29af9ac5a359757f63f2d0fa869aba704d5ef0f836db62ea1/autopage-0.6.0.tar.gz"
    sha256 "42d07de90de63e83762828028bfd56d19906a18f7c951ef6eef3e9ad48a3071d"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d4/36/3329e2518d70ad8e2e5817d5a4cac6bba05a47767ec416c7d020a965f408/bcrypt-5.0.0.tar.gz"
    sha256 "f748f7c2d6fd375cc93d3fba7ef4a9e3a092421b8dbf34d8d4dc06be9492dfdd"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/eb/76/8c2b062b9a9f27db8d78c3183213efd2cb31493b9a81853025da5254652e/boto3-1.43.47.tar.gz"
    sha256 "09a8ce4abab4391bf08315e2dcc449b4b33e97ce7654ee9398d9fe4ef73a33da"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/76/2c/279bf51f68e85a12323996aa4a7f2a163da84dad949ee751caa318928ce1/botocore-1.43.47.tar.gz"
    sha256 "9e04d8da7f9cff8a911b14284829f78b74e1ce785444833199837decb5ecc17a"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/a5/44/53a224fb1378ac399b0a9a673075b3a7b7dc9a7814b738ebcf35f3a83056/cliff-4.15.0.tar.gz"
    sha256 "eca699f6b390c755e6ed1816a76cdfc1abf5f5ef7d1cee19f3833667a3a1fe39"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/9b/cd/3bbf233808b4045b105c072deea014599bbbae9205eec8e643674d2dc0f6/cmd2-4.1.1.tar.gz"
    sha256 "8a70157dacbbbc11290c18cb3453f0c8ab1dba742572d247a06f4bb519a16472"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/ad/57/1bbe02be744995408d944cf46b8c818cf072873064b1cd3c79c11618b216/debtcollector-3.1.0.tar.gz"
    sha256 "278a45608cf16e79c0ae10851d869185c6b78f86610df8f27a451a18c1fec732"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/60/8b/32f9823da46cde7df2087faa08cd98d01b908f8dcab982cdba9c84e85355/decorator-5.3.1.tar.gz"
    sha256 "4cbcdd55a6efadb9dbea26b858f4fb3264567b52d69ca0d25b721b553f60ea82"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/88/7f/731ff914b0255d3d065f45fd4e626d4b8c95dbcbaada049f337a6ac16410/docker-7.2.0.tar.gz"
    sha256 "cebb93773d334f778e023a7ee352a8d6e13ab1bd3b863a4d4a59dec897df43ac"
  end

  resource "dogpile-cache" do
    url "https://files.pythonhosted.org/packages/e7/c8/301ff89746e76745b937606df4753c032787c59ecb37dd4d4250bddc8929/dogpile_cache-1.5.0.tar.gz"
    sha256 "849c5573c9a38f155cd4173103c702b637ede0361c12e864876877d0cd125eec"
  end

  resource "durationpy" do
    url "https://files.pythonhosted.org/packages/9d/a4/e44218c2b394e31a6dd0d6b095c4e1f32d0be54c2a4b250032d717647bab/durationpy-0.10.tar.gz"
    sha256 "1fa6893409a6e739c9c72334fc65cca1f355dbdd93405d30f726deb5bde42fba"
  end

  resource "fqdn" do
    url "https://files.pythonhosted.org/packages/30/3e/a80a8c077fd798951169626cde3e239adeba7dab75deb3555716415bd9b0/fqdn-1.5.1.tar.gz"
    sha256 "105ed3677e767fb5ca086a0c1f4bb66ebc3c100be518f0e0d755d9eae164d89f"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/33/f6/227c48c5fe47fa178ccf1fda8f047d16c97ba926567b661e9ce2045c600c/invoke-3.0.3.tar.gz"
    sha256 "437b6a622223824380bfb4e64f612711a6b648c795f565efc8625af66fb57f0c"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/b9/f3/ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15/iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/18/c7/af399a2e7a67fd18d63c40c5e62d3af4e67b836a2107468b6a5ea24c4304/jsonpointer-3.1.1.tar.gz"
    sha256 "0b801c7db33a904024f6004d526dcc53bbb8a4a0f4e32bfd10beadf60adf1900"
  end

  resource "junos-eznc" do
    url "https://files.pythonhosted.org/packages/34/66/aeab71e5844ff25b771c509b19f8c85e0e5d1c34851b52135de3e9609b9c/junos_eznc-2.8.2.tar.gz"
    sha256 "bb0426e74bce4544405723a9047341ede91b29cd9b61f1be9e633a55c470fffc"
  end

  resource "jxmlease" do
    url "https://files.pythonhosted.org/packages/8d/6a/b2944628e019c753894552c1499bf60e2cef9efea138756c5d66f0d5eb98/jxmlease-1.0.3.tar.gz"
    sha256 "612c1575d8a87026dea096bb75acec7302dd69040fa23d9116e71e30d5e0839e"
  end

  resource "kerberos" do
    url "https://files.pythonhosted.org/packages/39/cd/f98699a6e806b9d974ea1d3376b91f09edcb90415adbf31e3b56ee99ba64/kerberos-1.3.1.tar.gz"
    sha256 "cdd046142a4e0060f96a00eb13d82a5d9ebc0f2d7934393ed559bac773460a2c"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/22/f5/627b01cde69d0ece2fd552b8c7c34af06acf13a0a77d1829ff0b46a3b45f/keystoneauth1-5.15.0.tar.gz"
    sha256 "ce2cacdfd028e65bd23ff403d6572ebfab3b006d6d2dde3aa85c263675a9fbb5"
  end

  resource "kubernetes" do
    url "https://files.pythonhosted.org/packages/ca/57/b07b96353f902aa1bdbe00e878e3a12a137977d03a962479785576aa8ec9/kubernetes-36.0.3.tar.gz"
    sha256 "36993ed25ce59b789c9341473a228fcf268504a2fec7c2b2b1531d73072e5ce7"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/05/3b/aab6728cae887456f409b4d75e8a01856e4f04bd510de38052a47768b680/lxml-6.1.1.tar.gz"
    sha256 "ba96ae44888e0185281e937633a743ea90d5a196c6000f82565ebb0580012d40"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/31/f9/c0a1c127f9049db9155afc316952ea571720dd01833ff5e4d7e8e6352dbb/msgpack-1.2.1.tar.gz"
    sha256 "04c721c2c7448767e9e3f2520a475663d8ee0f09c31890f6d2bd70fd636a9647"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
  end

  resource "ncclient" do
    url "https://files.pythonhosted.org/packages/c2/fb/29dbb4987f81d7932d8018079bf3e6d1d5cce320d7c2c90e84d3c7dba40c/ncclient-0.7.0.tar.gz"
    sha256 "318e8e3e72b1d2a766f3665cabef33436fd25b607da5f15657a199c648a68435"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/54/90/188b2a69654f27b221fba92fda7217778208532c962509e959a9cee5229d/netaddr-1.3.0.tar.gz"
    sha256 "5c3c3d9895b551b763779ba7db7a03487dc1f8e3b385af819af341ae9ef6e48a"
  end

  resource "ntc-templates" do
    url "https://files.pythonhosted.org/packages/0f/a2/9b858ed73ee715235e3f040c271db065d0182d8e48686c42a5f409ce112e/ntc_templates-9.2.0.tar.gz"
    sha256 "79fef745d12b6dbdc1f7c00665327790adc91fd981199b0a9adb04f4b365cd97"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "openshift" do
    url "https://files.pythonhosted.org/packages/55/f6/9e2e4935b59726bff3d53da35afba3904fe9ed693efedd6b7bbddff6cc78/openshift-0.13.2.tar.gz"
    sha256 "f55789fce56fcbf7e2cd9377a68c4a99ab406074d3324b9abcca98477d101471"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/48/1d/0238c57f7eb64170be6ff1703c3f87afa44a648f0672c91de7f66a58a11e/openstacksdk-4.17.0.tar.gz"
    sha256 "827e1ade488db6116f59af1da6c97dbdfeeb879d3fc96bca99b19351f15df8ba"
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
    url "https://files.pythonhosted.org/packages/eb/80/37ac2a46cc3ea9348ea670fd76dad72888726191f5875278a3d85034a9d8/osc_lib-4.7.0.tar.gz"
    sha256 "5b896de12ed69fb1111d2971467d403b838d414fc27df2024fc50e8652a53f2b"
  end

  resource "oslo-config" do
    url "https://files.pythonhosted.org/packages/5d/12/7aa270611a106994d79610157c348216971d6e5a91300acdc1cae9a64081/oslo_config-10.5.0.tar.gz"
    sha256 "8eea3356c93828c2d61bea1eb19b8cd7860a3edaff4ad2678d774dd353730dfa"
  end

  resource "oslo-context" do
    url "https://files.pythonhosted.org/packages/5b/6b/71f00290f6fb7302178422d3478093aacf972ab3e6e0f4b9a91026f533f8/oslo_context-6.5.0.tar.gz"
    sha256 "7e1fb03c6a97167959f37d930300154e0ee837ecdb85798c2bbe8878b56caaaf"
  end

  resource "oslo-i18n" do
    url "https://files.pythonhosted.org/packages/5e/69/72b03bb4d33f51a157c02d5297227bae48b9c359103856942b8774b608df/oslo_i18n-6.9.0.tar.gz"
    sha256 "574bcf21873b185068bcec951de1ec093158ffdff05a8055fd18ddcb69f69e65"
  end

  resource "oslo-log" do
    url "https://files.pythonhosted.org/packages/05/c5/f7ac6a80bd298630574fc77bd33603960781b9502115992536e9c1be1ec5/oslo_log-8.3.0.tar.gz"
    sha256 "8cdd7f082ab51e29453b9cc9fe6faf7eada6ffc2173e4df5d4424ba94191d2a5"
  end

  resource "oslo-serialization" do
    url "https://files.pythonhosted.org/packages/af/f5/2611fb291898fa5f3b41c68e916cb060305cb718a043fdbff25026491fc4/oslo_serialization-5.11.0.tar.gz"
    sha256 "8326e85a80856c1068007423fcf6fe29dd2fe57a32f5d87fff0120b555b4b67c"
  end

  resource "oslo-utils" do
    url "https://files.pythonhosted.org/packages/61/16/8cb5305abd34606bd9a5ee1c6fbe5db97981d323c8454f1d872c1781dcc8/oslo_utils-10.1.1.tar.gz"
    sha256 "c8ac3ee295303cc5776c4d8e1d4ef10078ece60ede4931177e4f07aca58f81ab"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/62/93/dcc25d52f49022ae6175d15e6bd751f1acc99b98bc61fc55e5155a7be2e7/paramiko-5.0.0.tar.gz"
    sha256 "36763b5b95c2a0dcfdf1abc48e48156ee425b21efe2f0e787c2dd5a95c0e5e79"
  end

  resource "passlib" do
    url "https://files.pythonhosted.org/packages/b6/06/9da9ee59a67fae7761aab3ccc84fa4f3f33f125b370f1ccdb915bf967c11/passlib-1.7.4.tar.gz"
    sha256 "defd50f72b65c5402ab2c573830a6978e5f202ad0d984793c8dde2c4152ebe04"

    # bcrypt no longer truncates long passwords: https://github.com/pyca/bcrypt/commit/d50ab05b2bece07d5c8d6a4179064fc714fd9126
    # And breaks unmaintained passlib: https://foss.heptapod.net/python-libs/passlib/-/issues/196
    # See also https://github.com/ansible/ansible/issues/85919
    patch do
      file "Patches/ansible/passlib-1.7.4.patch"
      type :unofficial
      resolves "https://foss.heptapod.net/python-libs/passlib/-/issues/196"
    end
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/5e/ab/1de9a4f730edde1bdbbc2b8d19f8fa326f036b4f18b2f72cfbea7dc53c26/pbr-7.0.3.tar.gz"
    sha256 "b46004ec30a5324672683ec848aed9e8fc500b0d261d40a3229c2d2bbfcedc29"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/42/92/cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149d/pexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/81/74/ba08d81e668ccfe8658d7520a307e63c19862c08eb4ccb26f356c5239a7a/prettytable-3.18.0.tar.gz"
    sha256 "439217116152244369caf3d9f1caf2f9fe29b03bd79e88d2928c8e718c95d680"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/ec/44/c87281c333769159c50594f22610f77398a47ccbfbbf23074e744e86f87c/propcache-0.5.2.tar.gz"
    sha256 "01c4fc7480cd0598bb4b57022df55b9ca296da7fc5a8760bd8451a7e63a7d427"
  end

  resource "proxmoxer" do
    url "https://files.pythonhosted.org/packages/22/2e/5481ad9cc91eff6e585eabac5be94879bc2297b8b615c7427bce610d1447/proxmoxer-2.3.0.tar.gz"
    sha256 "0b0b2067187af1fc6d4257a46ac68c8fd79cc25d2813637cdae7a9a98fbfd11f"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/9a/23310166d960def5897e91fe20e5b724601b02a22e84ba1f94232c0b7f67/pyasn1-0.6.4.tar.gz"
    sha256 "9c447d8431c947fe4c8febc4ed9e760bc29011a5b01e5c74b67025bd9fb8ce81"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "pynetbox" do
    url "https://files.pythonhosted.org/packages/0e/83/2fa04ce44f3b8b5f6090d9cfd6a4b0a8f6945aa304e2c69901cfe53a36d0/pynetbox-7.8.0.tar.gz"
    sha256 "c359e9b9ed599d145a987c755dbe786da967caf236e3afe1e94a154cf5aeab5c"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "pysphere3" do
    url "https://files.pythonhosted.org/packages/fa/1e/16cf889e0e38380678631a4afebeeb840cb29f54f11413356770efe29240/pysphere3-0.1.8.tar.gz"
    sha256 "c8efe92e7802b59ef67e09fb20b008fc1bd0d253ba97ba689aa892b125283ae1"
  end

  resource "pyspnego" do
    url "https://files.pythonhosted.org/packages/7d/84/58577bd1b14293650879de0579ec263a1d8350f1d6d227226cf776b5a6a6/pyspnego-0.12.1.tar.gz"
    sha256 "ff4fb6df38202a012ea2a0f43091ae9680878443f0ea61c9ea0e2e8152a4b810"
  end

  resource "python-consul" do
    url "https://files.pythonhosted.org/packages/7f/06/c12ff73cb1059c453603ba5378521e079c3f0ab0f0660c410627daca64b7/python-consul-1.1.0.tar.gz"
    sha256 "168f1fa53948047effe4f14d53fc1dab50192e2a2cf7855703f126f469ea11f4"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/97/ef/c8c68219a2bf9f296ad18cb0b9804c45adfdceee72d51684225488746262/python_keystoneclient-5.8.0.tar.gz"
    sha256 "3ca87c67c404298ce862310b569f545a58acf75cd5685094c82f35320b3a355d"
  end

  resource "python-ldap" do
    url "https://files.pythonhosted.org/packages/b2/f4/60edeb794bbc9ed0ff2149bbaeec605f3ed331766459d195832ecbd0ba2d/python_ldap-3.4.7.tar.gz"
    sha256 "bacd9fb680d20263d8570ade1cf234d90d281149a8beb4f079dd8f33f7613dc8"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/27/c4/e4eb2270cc288875f63339e32be98ac47bcb86e7913232149a9d483e7dbc/python_neutronclient-13.0.0.tar.gz"
    sha256 "c5fd856adf3dc02cc5f31f9a76f4591d50af48cdfaad25b6e99b1291b543f95a"
  end

  resource "python-string-utils" do
    url "https://files.pythonhosted.org/packages/10/91/8c883b83c7d039ca7e6c8f8a7e154a27fdeddd98d14c10c5ee8fe425b6c0/python-string-utils-1.0.0.tar.gz"
    sha256 "dcf9060b03f07647c0a603408dc8b03f807f3b54a05c6e19eb14460256fac0cb"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/ff/46/dd499ec9038423421951e4fad73051febaa13d2df82b4064f87af8b8c0c3/pytz-2026.2.tar.gz"
    sha256 "0e60b47b29f21574376f218fe21abc009894a2321ea16c6754f3cad6eb7cdd6a"
  end

  resource "pywinrm" do
    url "https://files.pythonhosted.org/packages/5a/2f/d835c342c4b11e28beaccef74982e7669986c84bf19654c39f53c8b8243c/pywinrm-0.5.0.tar.gz"
    sha256 "5428eb1e494af7954546cd4ff15c9ef1a30a75e05b25a39fd606cef22201e9f1"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-credssp" do
    url "https://files.pythonhosted.org/packages/bc/c3/de13b8598287440ab1df7eba97b93278d309dffb920f0163a09e089b71ec/requests-credssp-2.0.0.tar.gz"
    sha256 "229afe2f6e1c9fabef64fc2bdf2a10e794ca6c4a0c00a687d53fbfaf7b8ee71d"
  end

  resource "requests-ntlm" do
    url "https://files.pythonhosted.org/packages/15/74/5d4e1815107e9d78c44c3ad04740b00efd1189e5a9ec11e5275b60864e54/requests_ntlm-1.3.0.tar.gz"
    sha256 "b29cc2462623dffdf9b88c43e180ccb735b4007228a542220e882c58ae56c668"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/1d/14/4669927e06631070edb968c78fdb6ce8992e27c9ab2cde4b3993e22ac7af/resolvelib-1.2.1.tar.gz"
    sha256 "7d08a2022f6e16ce405d60b68c390f054efcfd0477d4b9bd019cc941c28fad1c"
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

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/65/da/4bef7ce7bb989b222aa4785a413896dbec53306dfc59c6ce7d16a7ffbd6a/s3transfer-0.19.1.tar.gz"
    sha256 "d3d6371dc3f1e5c5427b2b457bcf13bcf87bec334c95aed18642eae61f6926f3"
  end

  resource "scp" do
    url "https://files.pythonhosted.org/packages/7f/e1/34634a89f100fcf4f014aca65621e701c5b9053cec62b6386866e3f015d5/scp-0.16.0.tar.gz"
    sha256 "1763a4b8ac424ea0c304f58b95a4a4a51d503a834ed77b4e89f1a32b30cbe662"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/34/26/f5d29e25ffdb535afef2d35cdb55b325298f96debd670da4c325e08d70f4/setuptools-83.0.0.tar.gz"
    sha256 "025bccbbf0fa05b6192bc64ae1e7b16e001fd6d6d4d5de03c97b1c1ade523bef"
  end

  resource "shade" do
    url "https://files.pythonhosted.org/packages/b0/a6/a83f14eca6f7223319d9d564030bd322ca52c910c34943f38a59ad2a6549/shade-1.33.0.tar.gz"
    sha256 "36f6936da93723f34bf99d00bae24aa4cc36125d597392ead8319720035d21e8"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/d7/dd/04d56c2a5232358df41f3d0f0e31833d378b6c8ed7803a6b1b7867b0eba6/stevedore-5.9.0.tar.gz"
    sha256 "abbd0af7a38a8bbb1d6adea2e35b17609cf004eaac323e88a8d8963640dd2b3c"
  end

  resource "textfsm" do
    url "https://files.pythonhosted.org/packages/9e/87/2a93c2ced2a11fb26cfec3623894a9127b9b67ae3cfdd1778afa5cff576f/textfsm-2.1.0.tar.gz"
    sha256 "45c18ff2b7c90163dfdff7e20d3f482514cc7aac26bc2547744e79dfa761e458"
  end

  resource "transitions" do
    url "https://files.pythonhosted.org/packages/4f/83/9e90f3494057d73c9e6bd8de8488af7c9fa714666ccc2db30fe07d147818/transitions-0.9.3.tar.gz"
    sha256 "881fb75bb1654ed55d86060bb067f2c716f8e155f57bb73fd444e53713aafec8"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/34/74/c6428f875774288bec1396f5bfcbc2d925700a4dad61727fd5f2b12f249d/wcwidth-0.8.2.tar.gz"
    sha256 "91fbef97204b96a3d4d421609b80340b760cf33e26da123ff243d76b1fda8dda"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/2c/41/aa4bf9664e4cda14c3b39865b12251e8e7d239f4cd0e3cc1b6c2ccde25c1/websocket_client-1.9.0.tar.gz"
    sha256 "9e813624b6eb619999a97dc7958469217c3176312b3a16a4bd1bc7e08a46ec98"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/fe/a4/282c8e64300a59fc834518a54bf0afabb4ff9218b5fa76958b450459a844/wrapt-2.2.2.tar.gz"
    sha256 "0788e321027c999bf221b667bd4a54aaefd1a36283749a860ac3eb77daed0302"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/19/70/80f3b7c10d2630aa66414bf23d210386700aa390547278c789afa994fd7e/xmltodict-1.0.4.tar.gz"
    sha256 "6d94c9f834dd9e44514162799d344d815a3a4faec913717a9ecbfa5be1bb8e61"
  end

  resource "yamlloader" do
    url "https://files.pythonhosted.org/packages/e7/e6/81677e777ca8a3588012f74e215050e3001e39d253076beb1c3306fc9460/yamlloader-1.6.0.tar.gz"
    sha256 "918232976c9910d079ef74b3266ff9ef674228609aa56e67718b3992940a823f"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/79/12/1e8f37460ea0f7eb59c221fdaf0ed75e7ac43e97f8093b9c6f411df50a78/yarl-1.24.2.tar.gz"
    sha256 "9ac374123c6fd7abf64d1fec93962b0bd4ee2c19751755a762a72dd96c0378f8"
  end

  resource "zabbix-api" do
    url "https://files.pythonhosted.org/packages/4a/ce/893d6ab7e978d0c00d9154c0cf385016b862438da069302e7ceac0f6c429/zabbix-api-0.5.6.tar.gz"
    sha256 "627ad26769b6831130239182afcb195f64fbf494626bc9eb4b2ac8170de5b775"
  end

  def install
    venv = virtualenv_install_with_resources without: "ansible-core"
    venv.pip_install_and_link resource("ansible-core")
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    (testpath/"playbook.yml").write <<~YAML
      ---
      - hosts: all
        gather_facts: False
        tasks:
        - name: ping
          ping:
    YAML
    python3 = "python#{Language::Python.major_minor_version libexec/"bin/python"}"
    (testpath/"hosts.ini").write [
      "localhost ansible_connection=local",
      " ansible_python_interpreter=#{which(python3)}",
      "\n",
    ].join
    system bin/"ansible-playbook", testpath/"playbook.yml", "-i", testpath/"hosts.ini"

    # Ensure requests[security] is activated
    script = "import requests as r; r.get('https://mozilla-modern.badssl.com')"
    system libexec/"bin/python", "-c", script

    # Ensure ansible-vault can encrypt/decrypt files.
    (testpath/"vault-password.txt").write("12345678")
    (testpath/"vault-test-file.txt").write <<~EOS
      ---
      content:
        hello: world
    EOS
    system bin/"ansible-vault", "encrypt",
           "--vault-password-file", testpath/"vault-password.txt",
           testpath/"vault-test-file.txt"
    system bin/"ansible-vault", "decrypt",
           "--vault-password-file", testpath/"vault-password.txt",
           testpath/"vault-test-file.txt"

    # Check ansible-test is happy with our python version
    mkdir "ansible_collections/community/general/" do
      output = shell_output("#{bin}/ansible-test sanity --list-tests 2>&1")
      assert_match "WARNING: All targets skipped.", output
    end
  end
end
