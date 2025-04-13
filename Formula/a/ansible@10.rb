class AnsibleAT10 < Formula
  include Language::Python::Virtualenv

  desc "Automate deployment, configuration, and upgrading"
  homepage "https://www.ansible.com/"
  url "https://files.pythonhosted.org/packages/d4/64/29fdff6fe7682342adb54802c1cd90b2272d382e1743089af88f90a1d986/ansible-10.7.0.tar.gz"
  sha256 "59d29e3de1080e740dfa974517d455217601b16d16880314d9be26145c68dc22"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url "https://pypi.org/rss/project/ansible/releases.xml"
    regex(/^v?(10(?:\.\d+)+)$/i)
    strategy :xml do |xml, regex|
      xml.get_elements("//item/title").map { |item| item.text[regex, 1] }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eb35c6587563894c9c47c992eba095fd00c6ce48ff8a55cf21cdfcc24ce36d53"
    sha256 cellar: :any,                 arm64_sonoma:  "6fc1fd2c5a4873b4c1d235917d476f9fbb1ead387710486389bdf39a4325cbf6"
    sha256 cellar: :any,                 arm64_ventura: "7dcae55d5cb95c8a65fa6613021032ea72ac9eb4e046c781362d2df62fbf072a"
    sha256 cellar: :any,                 sonoma:        "666e98a3739b8fdcfb528a5dc00fdbd0bfeaeac66f98f8bfb3b1bfb45f8050fe"
    sha256 cellar: :any,                 ventura:       "a61275ac9c5607c0d2beed46c00eab2c5f3ddf25336d5d9a055e992a77d083a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc37d9aebc2cbdd484c41913f475226c22643a2c31872795f50174b1b39d9ff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b032d1d41e0e0f5d7e4d2adf57d02b0adc09cf0ea032932fd548620a806e1ac"
  end

  keg_only :versioned_formula

  # https://docs.ansible.com/ansible/latest/reference_appendices/release_and_maintenance.html#ansible-community-package-release-cycle
  deprecate! date: "2025-05-19", because: :unmaintained

  # `pkgconf` and `rust` are for bcrypt
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libsodium" # for pynacl
  depends_on "libssh"
  depends_on "libyaml"
  depends_on "python@3.12" # ansible-core 2.17.6 only supports py3.12

  uses_from_macos "krb5"
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  # pyinotify is linux-only dependency
  resource "pyinotify" do
    on_linux do
      url "https://files.pythonhosted.org/packages/e3/c0/fd5b18dde17c1249658521f69598f3252f11d9d7a980c5be8619970646e1/pyinotify-0.9.6.tar.gz"
      sha256 "9c998a5d7606ca835065cdabc013ae6c66eb9ea76a00a1e3bc6e0cfe2b4f71f4"
    end
  end

  resource "ansible-core" do
    url "https://files.pythonhosted.org/packages/14/f2/0453c53a66145b10edf3aa64ee9fb18896a9ee93f7f741ef8ab6ddfa42b0/ansible_core-2.17.9.tar.gz"
    sha256 "c24cdc2bab19b910bbdb4a1074af5745e16c78c618f15829e7ddcf699f69a510"
  end

  resource "ansible-pylibssh" do
    url "https://files.pythonhosted.org/packages/93/50/38298568fbd517dcb7b08c06f4fbfc0481ab9eae1e4b01920495dacf672a/ansible-pylibssh-1.2.2.tar.gz"
    sha256 "753e570dcdceb6ab8e362e91cc0d5993beebc93d287b88178db55509f6423ab5"
  end

  resource "apache-libcloud" do
    url "https://files.pythonhosted.org/packages/1b/45/1a239d9789c75899df8ff53a6b198c1657328f3b333f1711194643d53868/apache-libcloud-3.8.0.tar.gz"
    sha256 "75bf4c0b123bc225e24ca95fca1c35be30b19e6bb85feea781404d43c4276c91"

    # Backport newer setuptools/wheel version
    patch do
      url "https://github.com/apache/libcloud/commit/a2114923adcaee6b022b43410db59df5d7e53c26.patch?full_index=1"
      sha256 "b2b07919f7edbc346a16cfe8571ddbfb232e2b33ed32be18bf85e9ac4ec24d30"
    end
  end

  resource "autopage" do
    url "https://files.pythonhosted.org/packages/9f/9e/559b0cfdba9f3ed6744d8cbcdbda58880d3695c43c053a31773cefcedde3/autopage-0.5.2.tar.gz"
    sha256 "826996d74c5aa9f4b6916195547312ac6384bac3810b8517063f293248257b72"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/bb/5d/6d7433e0f3cd46ce0b43cd65e1db465ea024dbb8216fb2404e919c2ad77b/bcrypt-4.3.0.tar.gz"
    sha256 "3a3fd2204178b6d2adcf09cb4f6426ffef54762577a7c9b54c159008cb288c18"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/6b/e6/40f8c1fb52c02adad1c104c4c4ac0488bf8f2b1397f24db07779322e420b/boto3-1.37.7.tar.gz"
    sha256 "ac2e022edcd6a94a2adbb21f0ad373a16557ec14a8910366bee0bbc7138fc72a"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/53/4b/096b2fac3ba92ace94f69f238eea9948af568b487c3898e9a8881bfe506b/botocore-1.37.7.tar.gz"
    sha256 "2faeac11766db912bc444669b04359080b7b83b2f57a3906c77c8105b70ce1e8"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/6c/81/3747dad6b14fa2cf53fcf10548cf5aea6913e96fab41a3c198676f8948a5/cachetools-5.5.2.tar.gz"
    sha256 "1a661caa9175d26759571b2e19580f9d6393969e5dfca11fdb1f947a23e640d4"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/62/74/c7fb720990b17da636064a7993506c230f7a913b752f0116ad2a2e39d621/cliff-4.9.1.tar.gz"
    sha256 "5b392198293c0b9225d459be8ba710cf8248f1ee33006bdeb3d92fb0012592b4"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/f7/2a/018fe937e25e1db0cafeb358c117644a58cdba24f5bbee69c003faf0b454/cmd2-2.5.11.tar.gz"
    sha256 "30a0d385021fbe4a4116672845e5695bbe56eb682f9096066776394f954a7429"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/31/e2/a45b5a620145937529c840df5e499c267997e85de40df27d54424a158d3c/debtcollector-3.0.0.tar.gz"
    sha256 "2a8917d25b0e1f1d0d365d3c1c6ecfc7a522b1e9716e8a1a4a915126f7ccea6f"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/43/fa/6d96a0978d19e17b68d634497769987b16c8f4cd0a7a05048bec693caa6b/decorator-5.2.1.tar.gz"
    sha256 "65f266143752f734b0a7cc83c46f4618af75b8c5911b00ccb61d0ac9b6da0360"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/b5/4a/263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829/dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "dogpile-cache" do
    url "https://files.pythonhosted.org/packages/cb/b7/2fa37f52b4f38bc8eb6d4923163dd822ca6f9e2f817378478a5de73b239e/dogpile_cache-1.3.4.tar.gz"
    sha256 "4f0295575f5fdd3f7e13c84ba8e36656971d1869a2081b4737ec99ede378a8c0"
  end

  resource "durationpy" do
    url "https://files.pythonhosted.org/packages/31/e9/f49c4e7fccb77fa5c43c2480e09a857a78b41e7331a75e128ed5df45c56b/durationpy-0.9.tar.gz"
    sha256 "fd3feb0a69a0057d582ef643c355c40d2fa1c942191f914d12203b1a01ac722a"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/a7/b2/4140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3ba/future-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/c6/eb/d504ba1daf190af6b204a9d4714d457462b486043744901a6eeea711f913/google_auth-2.38.0.tar.gz"
    sha256 "8285113607d3b80a3f1543b75962447ba8a09fe85783432a784fdeef6ac094c4"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
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
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/6a/0a/eebeb1fa92507ea94016a2a790b93c2ae41a7e18778f85471dc54475ed25/jsonpointer-3.0.0.tar.gz"
    sha256 "2b2d729f2091522d61c3b31f82e11870f60b68f43fbc705cb76bf4b832af59ef"
  end

  resource "junos-eznc" do
    url "https://files.pythonhosted.org/packages/ce/85/963a0e6c344775b3e993d50f4d6d65b2e9796ca1a4e53c1eba5901cad0a5/junos-eznc-2.7.3.tar.gz"
    sha256 "15a9aff9da4bf25dc3c7e54fdf98f3eff5dc4fe8edb79075f54039bcf7a71bd1"
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
    url "https://files.pythonhosted.org/packages/59/f8/39aa1ac0c7fb9e7c8849f17e663eac208262689b7b9db02861b5e1093500/keystoneauth1-5.10.0.tar.gz"
    sha256 "34b870dbbcf806cdb5aec98483b62820a6568d364eca7b1174ca6a8b5a9c77ed"
  end

  resource "kubernetes" do
    url "https://files.pythonhosted.org/packages/b7/e8/0598f0e8b4af37cd9b10d8b87386cf3173cb8045d834ab5f6ec347a758b3/kubernetes-32.0.1.tar.gz"
    sha256 "42f43d49abd437ada79a79a16bd48a604d3471a117a8347e87db693f2ba0ba28"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ef/f6/c15ca8e5646e937c148e147244817672cf920b56ac0bf2cc1512ae674be8/lxml-5.3.1.tar.gz"
    sha256 "106b7b5d2977b339f1e97efe2778e2ab20e99994cbb0ec5e55771ed0795920c8"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/cb/d0/7555686ae7ff5731205df1012ede15dd9d927f6227ea151e901c7406af4f/msgpack-1.1.0.tar.gz"
    sha256 "dd432ccc2c72b914e4cb77afce64aab761c1137cc698be3984eee260bcb2896e"
  end

  resource "ncclient" do
    url "https://files.pythonhosted.org/packages/6d/db/887f9002c3e6c8b838ec7027f9d8ac36337f44bcd146c922e3deee60e55e/ncclient-0.6.15.tar.gz"
    sha256 "6757cb41bc9160dfe47f22f5de8cf2f1adf22f27463fb50453cc415ab96773d8"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/54/90/188b2a69654f27b221fba92fda7217778208532c962509e959a9cee5229d/netaddr-1.3.0.tar.gz"
    sha256 "5c3c3d9895b551b763779ba7db7a03487dc1f8e3b385af819af341ae9ef6e48a"
  end

  resource "ntc-templates" do
    url "https://files.pythonhosted.org/packages/33/59/0d359a88a9d037bbf4383a123a692c22a10e281f2dd4a6ab7224b8f7908c/ntc_templates-7.7.0.tar.gz"
    sha256 "c7b9c2f8306ff6ff1133b5a1614f9627b520bc27c3c514c4e95bf27e221f2a2d"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "openshift" do
    url "https://files.pythonhosted.org/packages/55/f6/9e2e4935b59726bff3d53da35afba3904fe9ed693efedd6b7bbddff6cc78/openshift-0.13.2.tar.gz"
    sha256 "f55789fce56fcbf7e2cd9377a68c4a99ab406074d3324b9abcca98477d101471"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/c2/9e/dc50e3821ba3dda7e94071a25f8daa34575d92752e94e0d3e8583064856e/openstacksdk-4.4.0.tar.gz"
    sha256 "157437563d64f3f6feec1796fbd8552d56277332461778c4dbe76d1828fd31e0"
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
    url "https://files.pythonhosted.org/packages/dc/db/0a907d200719f755f00579f116526abea404a8a7961d8cd4019f1e1235ed/osc-lib-3.2.0.tar.gz"
    sha256 "5f706be145daf0e58068e3763ec56bde2f43ed229a738628e4c0fb1defb4ed9e"
  end

  resource "oslo-config" do
    url "https://files.pythonhosted.org/packages/3c/ac/aa17577d353a8c90b758a0edb1a94de7fffa24283c7f82cd2c485cb0a740/oslo_config-9.7.1.tar.gz"
    sha256 "5558b34bcc2b52f2208e80fcad955a4f7b2c41bb245b6451d43a621ad1263bbd"
  end

  resource "oslo-context" do
    url "https://files.pythonhosted.org/packages/a3/65/17722b5f616aa129cee9b5f4a34952ffac7845f7a2cb842472b27c990caa/oslo_context-5.7.1.tar.gz"
    sha256 "0c511fe153732aff0c1b3b44abd2f51008a83c707bb929bee01e1255ac964889"
  end

  resource "oslo-i18n" do
    url "https://files.pythonhosted.org/packages/cc/94/8ab2746a3251e805be8f7fd5243df44fe6289269ce9f7105bdbe418be90d/oslo_i18n-6.5.1.tar.gz"
    sha256 "ea856a70c5af7c76efb6590994231289deabe23be8477159d37901cef33b109d"
  end

  resource "oslo-log" do
    url "https://files.pythonhosted.org/packages/72/e9/ed065144ab6dec839fe7bafebfa803b775eb2149db33878ca5ff613f6b11/oslo_log-7.1.0.tar.gz"
    sha256 "9a2b3c18be6f59152dfe25f34deabe71343db7fb8248a633967fb6a04707629d"
  end

  resource "oslo-serialization" do
    url "https://files.pythonhosted.org/packages/a7/44/e7f2aaef66d7a02c74ce425f2bad8c4aaf11f39bb02fea98eeb7452a0910/oslo_serialization-5.7.0.tar.gz"
    sha256 "bdc4d3dd97b80639b3505e46d9aa439fc95028814177f30b91743e81366c3be7"
  end

  resource "oslo-utils" do
    url "https://files.pythonhosted.org/packages/f1/98/0c74172604f4ea9db117933fa9794e82a66438481a1e5a538584479c92f8/oslo_utils-8.2.0.tar.gz"
    sha256 "dcf78d14b968fb7b14263c77278b2b930a7861d3caa887d3a58b2890f6659835"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/7d/15/ad6ce226e8138315f2451c2aeea985bf35ee910afb477bae7477dc3a8f3b/paramiko-3.5.1.tar.gz"
    sha256 "b2c665bc45b2b215bd7d7f039901b14b067da00f3a11e6640995fd58f2664822"
  end

  resource "passlib" do
    url "https://files.pythonhosted.org/packages/b6/06/9da9ee59a67fae7761aab3ccc84fa4f3f33f125b370f1ccdb915bf967c11/passlib-1.7.4.tar.gz"
    sha256 "defd50f72b65c5402ab2c573830a6978e5f202ad0d984793c8dde2c4152ebe04"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/01/d2/510cc0d218e753ba62a1bc1434651db3cd797a9716a0a66cc714cb4f0935/pbr-6.1.1.tar.gz"
    sha256 "93ea72ce6989eb2eed99d0f75721474f69ad88128afdef5ac377eb797c4bf76b"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/42/92/cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149d/pexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/38/95/78080e58efbdde46cda8d4498737bf9687839ed4a9744b068cc730a073ed/prettytable-3.15.1.tar.gz"
    sha256 "f0edb38060cb9161b2417939bfd5cd9877da73388fb19d1e8bf7987e8558896e"
  end

  resource "proxmoxer" do
    url "https://files.pythonhosted.org/packages/6a/54/dc2919eed681ca31220a9021e35935a3995335069b520279b4d55b9df822/proxmoxer-2.2.0.tar.gz"
    sha256 "3ed63a58e5c0822841afdb3801f9d913a4996955c1c54f7319b5842ba2615006"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/1d/67/6afbf0d507f73c32d21084a79946bfcfca5fbc62a72057e9c23797a737c9/pyasn1_modules-0.4.1.tar.gz"
    sha256 "c28e2dbf9c06ad61c71a075c7e0f9fd0f1b0bb2d2ad4377f240d33ac2ab60a7c"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pynetbox" do
    url "https://files.pythonhosted.org/packages/1a/f9/e6c524e5ddc4c2788ab2f5ee1ab2d9afad49cad9c7cd3a372cf5b8433ed3/pynetbox-7.4.1.tar.gz"
    sha256 "3f82b5964ca77a608aef6cc2fc48a3961f7667fbbdbb60646655373e3dae00c3"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/8b/1a/3544f4f299a47911c2ab3710f534e52fea62a633c96806995da5d25be4b2/pyparsing-3.2.1.tar.gz"
    sha256 "61980854fd66de3a90028d679a954d5f2623e83144b5afe5ee86f43d762e5f0a"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/30/23/2f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60d/pyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
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
    url "https://files.pythonhosted.org/packages/6b/f8/53f1fc851dab776a183ffc9f29ebde244fbb467f5237f3ea809519fc4b2e/pyspnego-0.11.2.tar.gz"
    sha256 "994388d308fb06e4498365ce78d222bf4f3570b6df4ec95738431f61510c971b"
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
    url "https://files.pythonhosted.org/packages/91/d9/e6b430abdd77caccfc0f47005f7ff2125d143b16bd6f9aaa46ceaac75b90/python_keystoneclient-5.6.0.tar.gz"
    sha256 "721de2aec7710076389c674ee27b6712e97d86c7e0ff487b0b4409c8fcee10e7"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/62/f5/43ac046c8bc32068faccd4d0b79e44c08ec96b7104a0ac70974c2a17ac76/python-neutronclient-11.4.0.tar.gz"
    sha256 "8741219362e4bf9c2e43f2e6cae4d4991ed8f9df9063f43408a0b658b03d62e2"
  end

  resource "python-string-utils" do
    url "https://files.pythonhosted.org/packages/10/91/8c883b83c7d039ca7e6c8f8a7e154a27fdeddd98d14c10c5ee8fe425b6c0/python-string-utils-1.0.0.tar.gz"
    sha256 "dcf9060b03f07647c0a603408dc8b03f807f3b54a05c6e19eb14460256fac0cb"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/5f/57/df1c9157c8d5a05117e455d66fd7cf6dbc46974f832b1058ed4856785d8a/pytz-2025.1.tar.gz"
    sha256 "c2db42be2a2518b28e65f9207c4d05e6ff547d1efa4086469ef855e4ab70178e"
  end

  resource "pywinrm" do
    url "https://files.pythonhosted.org/packages/5a/2f/d835c342c4b11e28beaccef74982e7669986c84bf19654c39f53c8b8243c/pywinrm-0.5.0.tar.gz"
    sha256 "5428eb1e494af7954546cd4ff15c9ef1a30a75e05b25a39fd606cef22201e9f1"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
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

  resource "requestsexceptions" do
    url "https://files.pythonhosted.org/packages/82/ed/61b9652d3256503c99b0b8f145d9c8aa24c514caff6efc229989505937c1/requestsexceptions-1.4.0.tar.gz"
    sha256 "b095cbc77618f066d459a02b137b020c37da9f46d9b057704019c9f77dba3065"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/ce/10/f699366ce577423cbc3df3280063099054c23df70856465080798c6ebad6/resolvelib-1.0.1.tar.gz"
    sha256 "04ce76cbd63fded2078ce224785da6ecd42b9564b1390793f64ddecbe997b309"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/85/40/1520d68bfa07ab5a6f065a186815fb6610c86fe957bc065754e47f7b0840/rfc3986-2.0.0.tar.gz"
    sha256 "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/0f/ec/aa1a215e5c126fe5decbee2e107468f51d9ce190b9763cb649f76bb45938/s3transfer-0.11.4.tar.gz"
    sha256 "559f161658e1cf0a911f45940552c696735f5c74e64362e515f333ebed87d679"
  end

  resource "scp" do
    url "https://files.pythonhosted.org/packages/d6/1c/d213e1c6651d0bd37636b21b1ba9b895f276e8057f882c9f944931e4f002/scp-0.15.0.tar.gz"
    sha256 "f1b22e9932123ccf17eebf19e0953c6e9148f589f93d91b872941a696305c83f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/d1/53/43d99d7687e8cdef5ab5f9ec5eaf2c0423c2b35133a2b7e7bc276fc32b21/setuptools-75.8.2.tar.gz"
    sha256 "4880473a969e5f23f2a2be3646b2dfd84af9028716d398e46192f84bc36900d2"
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
    url "https://files.pythonhosted.org/packages/28/3f/13cacea96900bbd31bb05c6b74135f85d15564fc583802be56976c940470/stevedore-5.4.1.tar.gz"
    sha256 "3135b5ae50fe12816ef291baff420acb727fcd356106e3e9cbfa9e5985cd6f4b"
  end

  resource "textfsm" do
    url "https://files.pythonhosted.org/packages/b8/bf/c9147d29c5a3ff4c1c876e16ea02f6d4e4f35ba1bcbb2ac80a254924f0aa/textfsm-1.1.3.tar.gz"
    sha256 "577ef278a9237f5341ae9b682947cefa4a2c1b24dbe486f94f2c95addc6504b5"
  end

  resource "transitions" do
    url "https://files.pythonhosted.org/packages/4a/82/4dfbb3cf62501cb3e8d026cbeb2d5cdeaf5bfe916ea50d3a9435faa2b0e1/transitions-0.9.2.tar.gz"
    sha256 "2f8490dbdbd419366cef1516032ab06d07ccb5839ef54905e842a472692d4204"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/43/0f/fa4723f22942480be4ca9527bbde8d43f6c3f2fe8412f00e7f5f6746bc8b/tzdata-2025.1.tar.gz"
    sha256 "24894909e88cdb28bd1636c6887801df64cb485bd593f2fd83ef29075a81d694"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/e6/30/fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5/websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/c3/fc/e91cc220803d7bc4db93fb02facd8461c37364151b8494762cc88b0fbcef/wrapt-1.17.2.tar.gz"
    sha256 "41388e9d4d1522446fe79d3213196bd9e3b301a336965b9e27ca2788ebd122f3"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/50/05/51dcca9a9bf5e1bce52582683ce50980bcadbc4fa5143b9f2b19ab99958f/xmltodict-0.14.2.tar.gz"
    sha256 "201e7c28bb210e374999d1dde6382923ab0ed1a8a5faeece48ab525b7810a553"
  end

  resource "yamlordereddictloader" do
    url "https://files.pythonhosted.org/packages/23/78/f853b0db6d8f3ea0ae4c648e4504ba376d024c139ba1292a256ce6180dd0/yamlordereddictloader-0.4.2.tar.gz"
    sha256 "36af2f6210fcff5da4fc4c12e1d815f973dceb41044e795e1f06115d634bca13"
  end

  resource "zabbix-api" do
    url "https://files.pythonhosted.org/packages/4a/ce/893d6ab7e978d0c00d9154c0cf385016b862438da069302e7ceac0f6c429/zabbix-api-0.5.6.tar.gz"
    sha256 "627ad26769b6831130239182afcb195f64fbf494626bc9eb4b2ac8170de5b775"
  end

  def install
    ENV["SODIUM_INSTALL"] = "system"
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
