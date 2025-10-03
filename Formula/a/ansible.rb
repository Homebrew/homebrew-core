class Ansible < Formula
  include Language::Python::Virtualenv

  desc "Automate deployment, configuration, and upgrading"
  homepage "https://www.ansible.com/"
  url "https://files.pythonhosted.org/packages/40/47/e7294a50e89e1f26456703a2fc2f3ce84fde6ad92ef86582648da21cc997/ansible-12.0.0.tar.gz"
  sha256 "1b3ad8158dd2597ce45a864a55ca09e5be1807cc97f44a00c39d7bb9e1520aa6"
  license "GPL-3.0-or-later"
  head "https://github.com/ansible/ansible.git", branch: "devel"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ae61a40d92fb421b706dbe4feeb3d996f2bec2509f70d9f9b3d6c84c2550e047"
    sha256 cellar: :any,                 arm64_sequoia: "a14972267bd58edac7704196c9d4d36c324568fab7b0f97b46561e7e6365878d"
    sha256 cellar: :any,                 arm64_sonoma:  "fdf2820de20b9ab4b6c4072d3bc0db431e383abb7bf917bebabe50232ffcbf28"
    sha256 cellar: :any,                 arm64_ventura: "400a4afaff0852f55945e7cde09ec9f8f257fa68d4732905ef17f507ba8f1926"
    sha256 cellar: :any,                 sonoma:        "dfc67a7341a90a6058e00196518db4eb654b2bb3ffbd5f6c7f8f2c4923306cfd"
    sha256 cellar: :any,                 ventura:       "a7ee1a0ace6fcb2092effb396edbfc3fe0e221712dd9303de9e09bb0999fb1b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00e0c3e46b59219f1aa79b1c91f8ff35387055d433eae64b55fdfd99dc1a7435"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be43ebd3a21977b5588b55f6398322275443a48dc05075b1b489e62c683f0594"
  end

  # `pkgconf` and `rust` are for bcrypt
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libsodium" # for pynacl
  depends_on "libssh"
  depends_on "libyaml"
  depends_on "python@3.13"
  depends_on "tree" # for ansible-role-init

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
    url "https://files.pythonhosted.org/packages/16/f1/1c21d3bff03fe9a5b51515307db7a76ec8b8972c70d5702cc3027c988a99/ansible_core-2.19.2.tar.gz"
    sha256 "87fcbbc492ed16eb6adb0379bae0adbf69f3ce88a8440e7e88e0dcefa9f8a54c"
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
    url "https://files.pythonhosted.org/packages/66/68/40902312de023458edae9bb42c503f2aafda5009079cead1ab693f2350a6/boto3-1.40.26.tar.gz"
    sha256 "9a71684825cfd4548027f254eadf4dafb7fccc7523f20e2a1cb74033f4d74a6b"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/b7/d7/e42337570f38405a99fa9f9d5f1379fd52de412b1d4c65351d688c461b5d/botocore-1.40.26.tar.gz"
    sha256 "f8f46b3978b7c324f4c0bef03505870c4c5240c736bfb63318da091942a29710"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/6c/81/3747dad6b14fa2cf53fcf10548cf5aea6913e96fab41a3c198676f8948a5/cachetools-5.5.2.tar.gz"
    sha256 "1a661caa9175d26759571b2e19580f9d6393969e5dfca11fdb1f947a23e640d4"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/8d/43/6974bae8a54e8e49aea448f2897ba1af4d261b95328a3cc112fa0e290b1a/cliff-4.11.0.tar.gz"
    sha256 "aa33c11ac2fecdf2d1eaffea9d5d0eb4584b8e777673bb55d42a693e34ccc429"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/75/68/4bf43d284e41c01c6011146e5c2824aa6f17a3bb1ef10ba3dbbae5cf31dc/cmd2-2.7.0.tar.gz"
    sha256 "81d8135b46210e1d03a5a810baf859069a62214788ceeec3588f44eed86fbeeb"
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
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "dogpile-cache" do
    url "https://files.pythonhosted.org/packages/e8/07/2257f13f9cd77e71f62076d220b7b59e1f11a70b90eb1e3ef8bdf0f14b34/dogpile_cache-1.4.0.tar.gz"
    sha256 "b00a9e2f409cf9bf48c2e7a3e3e68dac5fa75913acbf1a62f827c812d35f3d09"
  end

  resource "durationpy" do
    url "https://files.pythonhosted.org/packages/9d/a4/e44218c2b394e31a6dd0d6b095c4e1f32d0be54c2a4b250032d717647bab/durationpy-0.10.tar.gz"
    sha256 "1fa6893409a6e739c9c72334fc65cca1f355dbdd93405d30f726deb5bde42fba"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/9e/9b/e92ef23b84fa10a64ce4831390b7a4c2e53c0132568d99d4ae61d04c8855/google_auth-2.40.3.tar.gz"
    sha256 "500c3a29adedeb36ea9cf24b8d10858e152f2412e3ca37829b3fa18e33d63b77"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/f9/42/127e6d792884ab860defc3f4d80a8f9812e48ace584ffc5a346de58cdc6c/invoke-2.2.0.tar.gz"
    sha256 "ee6cbb101af1a859c7fe84f2a264c059020b0cb7fe3535f9424300ab568f6bd5"
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
    url "https://files.pythonhosted.org/packages/4e/fb/8636537d3832ab752501296ac8a85b2d0b13da169ca95024584434d77836/junos-eznc-2.7.4.tar.gz"
    sha256 "c9d90f8ecea908b0b8bf3f47ccc4c7afc212dddcd275a426e5c0104f40418d59"
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
    url "https://files.pythonhosted.org/packages/e5/16/b96df223ca7ea4bfa78034b205e0eaf4875bfecb2f119f375fc5232d2061/keystoneauth1-5.12.0.tar.gz"
    sha256 "dd113c2f3dcb418d9f761c73b8cd43a96ddfa8a612b51c576822381f39ca4ae8"
  end

  resource "kubernetes" do
    url "https://files.pythonhosted.org/packages/ae/52/19ebe8004c243fdfa78268a96727c71e08f00ff6fe69a301d0b7fcbce3c2/kubernetes-33.1.0.tar.gz"
    sha256 "f64d829843a54c251061a8e7a14523b521f2dc5c896cf6d65ccf348648a88993"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/8f/bd/f9d01fd4132d81c6f43ab01983caea69ec9614b913c290a26738431a015d/lxml-6.0.1.tar.gz"
    sha256 "2b3a882ebf27dd026df3801a87cf49ff791336e0f94b0fad195db77e01240690"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/45/b1/ea4f68038a18c77c9467400d166d74c4ffa536f34761f7983a104357e614/msgpack-1.1.1.tar.gz"
    sha256 "77b79ce34a2bdab2594f490c8e80dd62a02d650b91a75159a63ec413b8d104cd"
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
    url "https://files.pythonhosted.org/packages/db/c8/db26631c27c42ec4f93e148d1c0141f9d5ec83c6871bccdca39dba0a4c80/ntc_templates-8.0.0.tar.gz"
    sha256 "44d94539f70709ade86b768147ddfdef0dbf1f58aebaf27fa9971c93941e2007"
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
    url "https://files.pythonhosted.org/packages/92/c2/a3521476b32fd0a25e842632d6e4d5cca401ff6e5c456d8a824194eb1f38/openstacksdk-4.7.0.tar.gz"
    sha256 "ee6b853897b3eef347fa5042187174026ad181a95ff6e6933841f5f9c697b1bd"
  end

  resource "os-client-config" do
    url "https://files.pythonhosted.org/packages/50/cd/352f6f18d1fb90780b95fdc3a668a279bd41d89905d70ee06076b529077c/os_client_config-2.3.0.tar.gz"
    sha256 "e16a260f2fd500af14f157b9b7b7d69292ce83b0f8a461ec68ce6a8a42967cbd"
  end

  resource "os-service-types" do
    url "https://files.pythonhosted.org/packages/9d/e9/1725288a94496d7780cd1624d16b86b7ed596960595d5742f051c4b90df5/os_service_types-1.8.0.tar.gz"
    sha256 "890ce74f132ca334c2b23f0025112b47c6926da6d28c2f75bcfc0a83dea3603e"
  end

  resource "osc-lib" do
    url "https://files.pythonhosted.org/packages/7c/63/ea0eda39e1b2c0ca3e9d87798568f881ea7aa90e4f94affb78676215f72d/osc_lib-4.2.0.tar.gz"
    sha256 "99718f06a990c1ad6fb9034bbed9655390a2ea83cef71a53781e7e9abd9f20ce"
  end

  resource "oslo-config" do
    url "https://files.pythonhosted.org/packages/03/67/221128a241ab4151ecc5b101de23651e7c08491f7b2edea31744207a23dc/oslo_config-10.0.0.tar.gz"
    sha256 "333e675db8c6be7715b3decf78c398ca1138439225aa274632e89314837f6ea3"
  end

  resource "oslo-context" do
    url "https://files.pythonhosted.org/packages/15/a3/d4804bb24e6f8cabcae4925a02ade281c2f8d90e3d0b7b367221cfb65ad8/oslo_context-6.1.0.tar.gz"
    sha256 "c1a8d17c79f50c71024d54cc17cc0b01e89dbff258315dc11d7e04e6b1a02ce3"
  end

  resource "oslo-i18n" do
    url "https://files.pythonhosted.org/packages/c1/74/a2238cfdf6e97ee398b3fc5eda8b0e108be3913494dbef90961ebe38bf23/oslo_i18n-6.6.0.tar.gz"
    sha256 "bb5e3becefa2e40488b259f9db12cc5ad894dd309b5b5aca56382ff190c18f5e"
  end

  resource "oslo-log" do
    url "https://files.pythonhosted.org/packages/81/6b/a7f1c1daeadd36f71633fb3ebac9817fcb1f8edfd06d6bdd71384f39010f/oslo_log-7.2.1.tar.gz"
    sha256 "01aebabdcf06b62df00e479db99df0c23f6cd24c6500ab3110e604bd059fa8d5"
  end

  resource "oslo-serialization" do
    url "https://files.pythonhosted.org/packages/d4/ac/119c430df3a86dc6a664fa864f777b4fd5cc16c50caa1ba3dd3bf10f43ae/oslo_serialization-5.8.0.tar.gz"
    sha256 "5871a62b23f98cacd5518482941ae6d2a983e2936ed52d543ad08685dc6d2343"
  end

  resource "oslo-utils" do
    url "https://files.pythonhosted.org/packages/d9/ec/9f12c8ded6eb7ba0774ea4a0e03bfe6cd35fea4cbc944a826c751bb49500/oslo_utils-9.1.0.tar.gz"
    sha256 "01c3875e7cca005b59465c429f467113b5f4b04211cbd534c9ac2f152276d3b3"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/1f/e7/81fdcbc7f190cdb058cffc9431587eb289833bdd633e2002455ca9bb13d4/paramiko-4.0.0.tar.gz"
    sha256 "6a25f07b380cc9c9a88d2b920ad37167ac4667f8d9886ccebd8f90f654b5d69f"
  end

  resource "passlib" do
    url "https://files.pythonhosted.org/packages/b6/06/9da9ee59a67fae7761aab3ccc84fa4f3f33f125b370f1ccdb915bf967c11/passlib-1.7.4.tar.gz"
    sha256 "defd50f72b65c5402ab2c573830a6978e5f202ad0d984793c8dde2c4152ebe04"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/ad/8d/23253ab92d4731eb34383a69b39568ca63a1685bec1e9946e91a32fc87ad/pbr-7.0.1.tar.gz"
    sha256 "3ecbcb11d2b8551588ec816b3756b1eb4394186c3b689b17e04850dfc20f7e57"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/42/92/cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149d/pexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/23/e8/21db9c9987b0e728855bd57bff6984f67952bea55d6f75e055c46b5383e8/platformdirs-4.4.0.tar.gz"
    sha256 "ca753cf4d81dc309bc67b0ea38fd15dc97bc30ce419a7f58d13eb3bf14c4febf"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/99/b1/85e18ac92afd08c533603e3393977b6bc1443043115a47bb094f3b98f94f/prettytable-3.16.0.tar.gz"
    sha256 "3c64b31719d961bf69c9a7e03d0c1e477320906a98da63952bc6698d6164ff57"
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
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pynetbox" do
    url "https://files.pythonhosted.org/packages/d3/0b/695021a23c373991d07c1e4cb510287a521318cfc4b29f68ebbecb19fcd2/pynetbox-7.5.0.tar.gz"
    sha256 "780064c800fb8c079c9828df472203146442ed3dd0b522a28a501204eb00c066"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/bb/22/f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60f/pyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
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
    url "https://files.pythonhosted.org/packages/f9/e4/8b32a91aeba6fbc6943a630c44b2fe038615e5c7dec8814316fafdcf4bf4/pyspnego-0.12.0.tar.gz"
    sha256 "e1d9cd3520a87a1d6db8d68783b17edc4e1464eae3d51ead411a51c82dbaae67"
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
    url "https://files.pythonhosted.org/packages/94/29/3775d7a722924a72208753a8aa5ddb0a58de24f5a5dd287cc9a0f66038e4/python_keystoneclient-5.7.0.tar.gz"
    sha256 "8ce7bf1c8cddca6d7140fc76918b44eddf1d64040a60cb8ff7059136104d4ceb"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/57/15/96f2f42df4c1d6873c89a0cae2ba3b98f83273e965421eb11b7dbb257b4d/python_neutronclient-11.6.0.tar.gz"
    sha256 "3c6958088d18c8676a10abf9d94b8dbf1a984741cbb988554f216880797e072f"
  end

  resource "python-string-utils" do
    url "https://files.pythonhosted.org/packages/10/91/8c883b83c7d039ca7e6c8f8a7e154a27fdeddd98d14c10c5ee8fe425b6c0/python-string-utils-1.0.0.tar.gz"
    sha256 "dcf9060b03f07647c0a603408dc8b03f807f3b54a05c6e19eb14460256fac0cb"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
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
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
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
    url "https://files.pythonhosted.org/packages/05/57/c5c178e21968123cf2aa90501b5fc14a48e342612695863333f4b70510ad/resolvelib-1.2.0.tar.gz"
    sha256 "c27fbb5098acd7dfc01fb2be3724bd0881168edc2bd3b4dc876ca3f46b8e4a3d"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/85/40/1520d68bfa07ab5a6f065a186815fb6610c86fe957bc065754e47f7b0840/rfc3986-2.0.0.tar.gz"
    sha256 "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fe/75/af448d8e52bf1d8fa6a9d089ca6c07ff4453d86c65c145d0a300bb073b9b/rich-14.1.0.tar.gz"
    sha256 "e497a48b844b0320d45007cdebfeaeed8db2a4f4bcf49f15e455cfc4af11eaa8"
  end

  resource "rich-argparse" do
    url "https://files.pythonhosted.org/packages/71/a6/34460d81e5534f6d2fc8e8d91ff99a5835fdca53578eac89e4f37b3a7c6d/rich_argparse-1.7.1.tar.gz"
    sha256 "d7a493cde94043e41ea68fb43a74405fa178de981bf7b800f7a3bd02ac5c27be"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/da/8a/22b7beea3ee0d44b1916c0c1cb0ee3af23b700b6da9f04991899d0c555d4/rsa-4.9.1.tar.gz"
    sha256 "e7bdbfdb5497da4c07dfd35530e1a902659db6ff241e39d9953cad06ebd0ae75"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/6d/05/d52bf1e65044b4e5e27d4e63e8d1579dbdec54fce685908ae09bc3720030/s3transfer-0.13.1.tar.gz"
    sha256 "c3fdba22ba1bd367922f27ec8032d6a1cf5f10c934fb5d68cf60fd5a23d936cf"
  end

  resource "scp" do
    url "https://files.pythonhosted.org/packages/d6/1c/d213e1c6651d0bd37636b21b1ba9b895f276e8057f882c9f944931e4f002/scp-0.15.0.tar.gz"
    sha256 "f1b22e9932123ccf17eebf19e0953c6e9148f589f93d91b872941a696305c83f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
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
    url "https://files.pythonhosted.org/packages/2a/5f/8418daad5c353300b7661dd8ce2574b0410a6316a8be650a189d5c68d938/stevedore-5.5.0.tar.gz"
    sha256 "d31496a4f4df9825e1a1e4f1f74d19abb0154aff311c3b376fcc89dae8fccd73"
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
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/95/32/1a225d6164441be760d75c2c42e2780dc0873fe382da3e98a2e1e48361e5/tzdata-2025.2.tar.gz"
    sha256 "b60a638fcc0daffadf82fe0f57e53d06bdec2f36c4df66280ae79bce6bd6f2b9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
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
    url "https://files.pythonhosted.org/packages/95/8f/aeb76c5b46e273670962298c23e7ddde79916cb74db802131d49a85e4b7d/wrapt-1.17.3.tar.gz"
    sha256 "f66eb08feaa410fe4eebd17f2a2c8e2e46d3476e9f8c783daa8e09e0faa666d0"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/d7/7a/42f705c672e77dc3ce85a6823bb289055323aac30de7c4b9eca1e28b2c17/xmltodict-0.15.1.tar.gz"
    sha256 "3d8d49127f3ce6979d40a36dbcad96f8bab106d232d24b49efdd4bd21716983c"
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
