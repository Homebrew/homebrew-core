class AnsibleAT8 < Formula
  include Language::Python::Virtualenv

  desc "Automate deployment, configuration, and upgrading"
  homepage "https://www.ansible.com/"
  url "https://files.pythonhosted.org/packages/90/25/55e09468efe564f3b48c47a7e082bd84d4f0d064af60ac8458eba4667994/ansible-8.7.0.tar.gz"
  sha256 "3a5ca5152e4547d590e40b542d76b18dbbe2b36da4edd00a13a7c51a374ff737"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f004f489b86deb0493906cbb400768209c66dbbfec8e29e5dacc249ce5263324"
    sha256 cellar: :any,                 arm64_sonoma:  "4949d0db36fff1aef4e69a9ca49ad6179e9fc980876901066c4af141466d401a"
    sha256 cellar: :any,                 arm64_ventura: "b9f8f6bec6b24d0fee295481e8cc9d8ba4160260ef8da35777b76ded78e22b1a"
    sha256 cellar: :any,                 sonoma:        "187330798c85545952dbe8606f44f156f8a49597dad0184ea1ed56a65bbcc47c"
    sha256 cellar: :any,                 ventura:       "f1e961e26484e8b7cc8239b71c3a21d9ae6887dd4079065d5a62874092424ee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c4b4102e16e982331e98d4d4b3077468737c729459ccb00acb850f61577508a"
  end

  keg_only :versioned_formula

  # https://docs.ansible.com/ansible/latest/reference_appendices/release_and_maintenance.html#ansible-community-package-release-cycle
  disable! date: "2024-12-14", because: :unmaintained

  # `pkgconf` and `rust` are for bcrypt
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libsodium" # for pynacl
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "python@3.11"

  uses_from_macos "krb5"
  uses_from_macos "libffi"
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages extra_packages: %w[apache-libcloud boto3 dnspython docker
                                   junos-eznc jxmlease kerberos ntc-templates openshift
                                   passlib pexpect proxmoxer pysphere3 python-consul
                                   python-neutronclient pywinrm requests-credssp shade zabbix-api]

  resource "ansible-core" do
    url "https://files.pythonhosted.org/packages/a1/fc/e81a2e2a6e4247444fe632c8ffaff5c1bcc3adf85ae87d08158724f419fd/ansible_core-2.15.12.tar.gz"
    sha256 "5fde82cd3928d9857ad880782c644f27d3168b0f25321d5a8d6befa524aa1818"
  end

  resource "apache-libcloud" do
    url "https://files.pythonhosted.org/packages/1b/45/1a239d9789c75899df8ff53a6b198c1657328f3b333f1711194643d53868/apache-libcloud-3.8.0.tar.gz"
    sha256 "75bf4c0b123bc225e24ca95fca1c35be30b19e6bb85feea781404d43c4276c91"
  end

  resource "autopage" do
    url "https://files.pythonhosted.org/packages/9f/9e/559b0cfdba9f3ed6744d8cbcdbda58880d3695c43c053a31773cefcedde3/autopage-0.5.2.tar.gz"
    sha256 "826996d74c5aa9f4b6916195547312ac6384bac3810b8517063f293248257b72"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/e4/7e/d95e7d96d4828e965891af92e43b52a4cd3395dc1c1ef4ee62748d0471d0/bcrypt-4.2.0.tar.gz"
    sha256 "cf69eaf5185fd58f268f805b505ce31f9b9fc2d64b376642164e9244540c1221"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/12/c1/1dc34b322d2f022d190c34dd4aa7f1a242d73633c25061bf56bd1319fe05/boto3-1.35.53.tar.gz"
    sha256 "f4124548bb831e13504e805f2fbbfcee06df42fffea0655862c6eb9b95d6d1be"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/48/c9/d5a1f5ad4024eda0d5d1b4103d28085c13cf42ca377fc141f7df4ad1cec9/botocore-1.35.53.tar.gz"
    sha256 "e610ae076ad1eaed5680d3990493659bbabdffd67b15c61d8373a23e4bc41062"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/c3/38/a0f315319737ecf45b4319a8cd1f3a908e29d9277b46942263292115eee7/cachetools-5.5.0.tar.gz"
    sha256 "2cc24fb4cbe39633fb7badd9db9ca6295d766d9c2995f245725a46715d050f2a"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/b0/ee/9b19140fe824b367c04c5e1b369942dd754c4c5462d5674002f75c4dedc1/certifi-2024.8.30.tar.gz"
    sha256 "bec941d2aa8195e248a60b31ff9f0558284cf01a52591ceda73ea9afffd69fd9"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/fc/97/c783634659c2920c3fc70419e3af40972dbaf758daa229a7d6ea6135c90d/cffi-1.17.1.tar.gz"
    sha256 "1c39c6016c32bc48dd54561950ebd6836e1670f2ae46128f67cf49e789c52824"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/3c/1c/213ba67600827d8c8cb2b30f1e5471e298b766505341b7fe7c8486cdc388/cliff-4.7.0.tar.gz"
    sha256 "6ca45f8df519bbc0722c61049de7b7e442a465fa7f3f552b96d735fa26fd5b26"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/b1/f8/1d6f1a54378a12acc9e8cc68aa69e2463bbb02f75878da4ad0c5e4d37751/cmd2-2.5.0.tar.gz"
    sha256 "36292d144e5fd62549b50e94e5f36514557fb92e615155ac28763ea4bc13b954"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/0d/05/07b55d1fa21ac18c3a8c79f764e2514e6f6a9698f1be44994f5adf0d29db/cryptography-43.0.3.tar.gz"
    sha256 "315b9001266a492a6ff443b61238f956b214dbec9910a081ba5b6646a055a805"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/31/e2/a45b5a620145937529c840df5e499c267997e85de40df27d54424a158d3c/debtcollector-3.0.0.tar.gz"
    sha256 "2a8917d25b0e1f1d0d365d3c1c6ecfc7a522b1e9716e8a1a4a915126f7ccea6f"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
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
    url "https://files.pythonhosted.org/packages/81/3b/83ce66995ce658ad63b86f7ca83943c466133108f20edc7056d4e0f41347/dogpile.cache-1.3.3.tar.gz"
    sha256 "f84b8ed0b0fb297d151055447fa8dcaf7bae566d4dbdefecdcc1f37662ab588b"
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
    url "https://files.pythonhosted.org/packages/a1/37/c854a8b1b1020cf042db3d67577c6f84cd1e8ff6515e4f5498ae9e444ea5/google_auth-2.35.0.tar.gz"
    sha256 "f4c64ed4e01e8e8b646ef34c018f8bf3338df0c8e37d8b3bba40e7f574a3278a"
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
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
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
    url "https://files.pythonhosted.org/packages/52/28/05d6d7a15e231b91f2e3133f29ab235f7798393d30a39a8611a12a90cf55/junos-eznc-2.7.2.tar.gz"
    sha256 "7c7e6f8e9bb9d0d034ffaeb592e400dd114f03db44c3bb608c951e88483c825d"
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
    url "https://files.pythonhosted.org/packages/09/9e/c11b6f5b97f0a5671b61c4908ecae0c6fb879323699c116a8a9040fff6f0/keystoneauth1-5.8.0.tar.gz"
    sha256 "3157c212e121164de64d63e5ef7e1daad2bd3649a68de1e971b76877019ef1c4"
  end

  resource "kubernetes" do
    url "https://files.pythonhosted.org/packages/7e/bd/ffcd3104155b467347cd9b3a64eb24182e459579845196b3a200569c8912/kubernetes-31.0.0.tar.gz"
    sha256 "28945de906c8c259c1ebe62703b56a03b714049372196f854105afe4e6d014c0"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
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

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/a6/91/86a6eac449ddfae239e93ffc1918cf33fd9bab35c04d1e963b311e347a73/netifaces-0.11.0.tar.gz"
    sha256 "043a79146eb2907edf439899f262b3dfe41717d34124298ed281139a8b93ca32"
  end

  resource "ntc-templates" do
    url "https://files.pythonhosted.org/packages/29/c1/96131cd0ce7eb614d07efb8441dd4b9a65159c7cf0dd5f9855c5dc124e30/ntc_templates-7.3.0.tar.gz"
    sha256 "6ac605fe745b5757e0ae703c5561e0181527402c62b054d042cf622a3ab0e5f7"
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
    url "https://files.pythonhosted.org/packages/32/7b/42529e0014cf5c3e1a4f4c07ed43c1df357d57f5f61ca15cbdbfdd229654/openstacksdk-4.1.0.tar.gz"
    sha256 "ccac9b158e3d36b959a3bdce71bd4f883d7758fef6856841c855ff2b22c941ea"
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
    url "https://files.pythonhosted.org/packages/56/42/a85b60f90efd29bade74d2e4fee287339b8a5b20377736fd2aac7378492d/osc-lib-3.1.0.tar.gz"
    sha256 "ef085249a8764b6f29d404eda566a261a3003502aa431b39ffd54307ee103e19"
  end

  resource "oslo-config" do
    url "https://files.pythonhosted.org/packages/42/92/f53acc4f8bb37ba50722b9ba03f53fd507adc434d821552d79d34ca87d2f/oslo.config-9.6.0.tar.gz"
    sha256 "9f05ef70e48d9a61a8d0c9bed389da24f2ef5a89df5b6e8deb7c741d6113667e"
  end

  resource "oslo-context" do
    url "https://files.pythonhosted.org/packages/41/3a/d217eb9c3f844aa6e955bf6d85cc9207b2d93e42fc47aff77fc1a778fc72/oslo.context-5.6.0.tar.gz"
    sha256 "5222c32636be070a230df9d3141a0b27a95f0a3b6978f4c1485bcada47a4c3cb"
  end

  resource "oslo-i18n" do
    url "https://files.pythonhosted.org/packages/75/16/743dbdaa3ddf05206c07965e89889295ada095d7b91954445f3e6cc7157e/oslo.i18n-6.4.0.tar.gz"
    sha256 "66e04c041e9ff17d07e13ec7f48295fbc36169143c72ca2352a3efcc98e7b608"
  end

  resource "oslo-log" do
    url "https://files.pythonhosted.org/packages/69/dd/7d461de2e089c0ddd56e8834a17f1b4efaf2e6ae495acf63c0ed558780b7/oslo.log-6.1.2.tar.gz"
    sha256 "f768047df9d706c484dd6665dcbbea289021d48cb7ce5abf7a1f69a09491f5fe"
  end

  resource "oslo-serialization" do
    url "https://files.pythonhosted.org/packages/3d/99/5d314298d154a58343050b4d8bb972cbbbb728ef943b57aef7f247c372f8/oslo.serialization-5.5.0.tar.gz"
    sha256 "9e752fc5d8a975956728dd96a82186783b3fefcacbb3553acd933058861e15a6"
  end

  resource "oslo-utils" do
    url "https://files.pythonhosted.org/packages/80/67/160e651bbd4c919ea308d63f5cc6c2b82808f0e118abb9f5f7ebca32ca60/oslo.utils-7.3.0.tar.gz"
    sha256 "59a5d3e4e7bbc78d801ccebc2b823e429b624c12bb6e3b6e76f71c29f2bf21df"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/1b/0f/c00296e36ff7485935b83d466c4f2cf5934b84b0ad14e81796e1d9d3609b/paramiko-3.5.0.tar.gz"
    sha256 "ad11e540da4f55cedda52931f1a3f812a8238a7af7f62a60de538cd80bb28124"
  end

  resource "passlib" do
    url "https://files.pythonhosted.org/packages/b6/06/9da9ee59a67fae7761aab3ccc84fa4f3f33f125b370f1ccdb915bf967c11/passlib-1.7.4.tar.gz"
    sha256 "defd50f72b65c5402ab2c573830a6978e5f202ad0d984793c8dde2c4152ebe04"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/b2/35/80cf8f6a4f34017a7fe28242dc45161a1baa55c41563c354d8147e8358b2/pbr-6.1.0.tar.gz"
    sha256 "788183e382e3d1d7707db08978239965e8b9e4e5ed42669bf4758186734d5f24"
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
    url "https://files.pythonhosted.org/packages/3b/8a/de4dc1a6098621781c266b3fb3964009af1e9023527180cb8a3b0dd9d09e/prettytable-3.12.0.tar.gz"
    sha256 "f04b3e1ba35747ac86e96ec33e3bb9748ce08e254dc2a1c6253945901beec804"
  end

  resource "proxmoxer" do
    url "https://files.pythonhosted.org/packages/e3/99/eb6129acd6552178b5fb20d101e43f1c78695140f1c3c2769f5dcb37a56d/proxmoxer-2.1.0.tar.gz"
    sha256 "d92993782e74ed8a76ff355dc050f58aa039fa697f9349a68e643552bd0fa62e"
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

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1d/b2/31537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52c/pycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/8c/d5/e5aeee5387091148a19e1145f63606619cb5f20b83fccb63efae6474e7b2/pyparsing-3.2.0.tar.gz"
    sha256 "cbf74e27246d595d9a74b186b810f6fbb86726dbf3b9532efb343f6d7294fe9c"
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
    url "https://files.pythonhosted.org/packages/46/f5/1f938a781742d18475ac43a101ec8a9499e1655da0984e08b59e20012c04/pyspnego-0.11.1.tar.gz"
    sha256 "e92ed8b0a62765b9d6abbb86a48cf871228ddb97678598dc01c9c39a626823f6"
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
    url "https://files.pythonhosted.org/packages/ea/5e/2d6700c6e36c288ec7e6d24ad49ef400311e8d2b2d926b16906f12c1cb26/python-keystoneclient-5.5.0.tar.gz"
    sha256 "c2f5934f95576936c98e45bf599ad48bcb0ac451593e5f8344ebf52cb0f411f5"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/6e/b2/b2cb8b08085e419907a28932ca55a2d54b71bd41aedb10f9faf03410e218/python-neutronclient-11.3.1.tar.gz"
    sha256 "53cd9923f43a3b0772a40e3561f74655adc8038f90261ab3de05b6211d12edcb"
  end

  resource "python-string-utils" do
    url "https://files.pythonhosted.org/packages/10/91/8c883b83c7d039ca7e6c8f8a7e154a27fdeddd98d14c10c5ee8fe425b6c0/python-string-utils-1.0.0.tar.gz"
    sha256 "dcf9060b03f07647c0a603408dc8b03f807f3b54a05c6e19eb14460256fac0cb"
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
    url "https://files.pythonhosted.org/packages/a0/a8/e0a98fd7bd874914f0608ef7c90ffde17e116aefad765021de0f012690a2/s3transfer-0.10.3.tar.gz"
    sha256 "4f50ed74ab84d474ce614475e0b8d5047ff080810aac5d01ea25231cfc944b0c"
  end

  resource "scp" do
    url "https://files.pythonhosted.org/packages/d6/1c/d213e1c6651d0bd37636b21b1ba9b895f276e8057f882c9f944931e4f002/scp-0.15.0.tar.gz"
    sha256 "f1b22e9932123ccf17eebf19e0953c6e9148f589f93d91b872941a696305c83f"
  end

  resource "shade" do
    url "https://files.pythonhosted.org/packages/b0/a6/a83f14eca6f7223319d9d564030bd322ca52c910c34943f38a59ad2a6549/shade-1.33.0.tar.gz"
    sha256 "36f6936da93723f34bf99d00bae24aa4cc36125d597392ead8319720035d21e8"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/c4/59/f8aefa21020054f553bf7e3b405caec7f8d1f432d9cb47e34aaa244d8d03/stevedore-5.3.0.tar.gz"
    sha256 "9a64265f4060312828151c204efbe9b7a9852a0d9228756344dbc7e4023e375a"
  end

  resource "textfsm" do
    url "https://files.pythonhosted.org/packages/b8/bf/c9147d29c5a3ff4c1c876e16ea02f6d4e4f35ba1bcbb2ac80a254924f0aa/textfsm-1.1.3.tar.gz"
    sha256 "577ef278a9237f5341ae9b682947cefa4a2c1b24dbe486f94f2c95addc6504b5"
  end

  resource "transitions" do
    url "https://files.pythonhosted.org/packages/4a/82/4dfbb3cf62501cb3e8d026cbeb2d5cdeaf5bfe916ea50d3a9435faa2b0e1/transitions-0.9.2.tar.gz"
    sha256 "2f8490dbdbd419366cef1516032ab06d07ccb5839ef54905e842a472692d4204"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/e1/34/943888654477a574a86a98e9896bae89c7aa15078ec29f490fef2f1e5384/tzdata-2024.2.tar.gz"
    sha256 "7d85cc416e9382e69095b7bdf4afd9e3880418a2413feec7069d533d6b4e31cc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
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
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
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

  def python3
    "python3.11"
  end

  def install
    venv = virtualenv_create(libexec, python3)
    skipped = %w[ansible-core junos-eznc]
    venv.pip_install resources.reject { |r| skipped.include? r.name }
    venv.pip_install_and_link resource("ansible-core")
    venv.pip_install_and_link buildpath
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
    (testpath/"hosts.ini").write [
      "localhost ansible_connection=local",
      " ansible_python_interpreter=#{Formula["python@3.11"].opt_bin}/python3.11",
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
