class Ansible < Formula
  include Language::Python::Virtualenv

  desc "Automate deployment, configuration, and upgrading"
  homepage "https://www.ansible.com/"
  url "https://files.pythonhosted.org/packages/d4/a0/e0a0bbff4b2ba003fd72a4be6fc9ae7a0c93c394b9ef132d3aa366dbe2f1/ansible-5.8.0.tar.gz"
  sha256 "fa056476201f40625fb36d95c5041ef463880be18be5c73b998b57b401967863"
  license "GPL-3.0-or-later"
  head "https://github.com/ansible/ansible.git", branch: "devel"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "699dc425f7abaaf761ac42a69dd7126ff305fb9f762cfdf131746fe30902071b"
    sha256 cellar: :any,                 arm64_big_sur:  "4a94fd14bdb592b97e672270be761060abcddc3ccd5e740e1e22c36aa78fb717"
    sha256 cellar: :any,                 monterey:       "71a6e1dcf79cedc0e74eb0e951ffe98c8bc3defdc0cef2c6564c5fbf8e3ac6b0"
    sha256 cellar: :any,                 big_sur:        "3ae5ecdc5ce1c3415b54709ee81e99523b21c58764794f709292c914e017b375"
    sha256 cellar: :any,                 catalina:       "96bc492eef5dad53c38d1d45af8734dc43b52308ac4ad721cbf905e6c94782c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d0ea6559a7476e59463c84934599a9b5018e0b74daa1a146d9cf21705a4ec0a"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "python@3.10"
  depends_on "six"

  uses_from_macos "krb5"
  uses_from_macos "libffi"
  uses_from_macos "libxslt"

  # This will collect requirements from:
  #   ansible
  #   docker
  #   python-neutronclient (OpenStack)
  #   shade (OpenStack)
  #   pywinrm (Windows)
  #   kerberos (Windows)
  #   boto3 (AWS)
  #   apache-libcloud (Google GCE)
  #   passlib (htpasswd core module)
  #   zabbix-api (Zabbix extras module)
  #   junos-eznc (Juniper device support)
  #   jxmlease (Juniper device support)
  #   dnspython (DNS Lookup - dig)
  #   pysphere3 (VMware vSphere support)
  #   python-consul (Consul support)
  #   requests-credssp (CredSSP support for windows hosts)
  #   openshift (k8s module support)
  #   pexpect (expect module support)
  #   ntc-templates (Parsing semi-structured text)
  #   proxmoxer (Proxmox VE support)

  # Automatically updated resources
  resource "ansible-core" do
    url "https://files.pythonhosted.org/packages/a4/39/b2c94aa83804bedaffee84f6a03a11c5038e849a98a9543ca6c24b4a045e/ansible-core-2.12.5.tar.gz"
    sha256 "1ccc9944f101331adad1ed40d5ac66a8149133052ae34db0267a74aa73beebb3"
  end

  resource "apache-libcloud" do
    url "https://files.pythonhosted.org/packages/43/75/d444d15ef271fb5bd9c5ce17e5ddb7eb1a11175c8892ff9ff34097a992d1/apache-libcloud-3.5.1.tar.gz"
    sha256 "ec92c39478fe90a27e3cfe886c43cbcb989a4593c239ff9f2c1dd77520863cf2"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

  resource "autopage" do
    url "https://files.pythonhosted.org/packages/d1/1c/aaaf5bcb9f37e3d17e040a83de5a35c6cb29fc9ce45412cc8224a570fe30/autopage-0.5.0.tar.gz"
    sha256 "5305b43cc0798170d7124e5a2feecf969e45f4a0baf75cb351138114eaf76b83"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/e8/36/edc85ab295ceff724506252b774155eff8a238f13730c8b13badd33ef866/bcrypt-3.2.2.tar.gz"
    sha256 "433c410c2177057705da2a9f2cd01dd157493b2a7ac14c8593a16b3dab6b6bfb"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/78/ef/716d0792cd578180092fc50ee0618394963acc11d3e1d69903e32da6804f/boto3-1.23.3.tar.gz"
    sha256 "9d5ce5ae3ddd4429cf752efe7c9f39691db6c85b6b5f1cfc8861b8f23b72b67a"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/6b/b0/b9a73d07061c19702b5146a4c659c0c795ce5a0b44b0bffa3ba83bb5a2c8/botocore-1.26.3.tar.gz"
    sha256 "f83c5cd7b3e1889aabf2fcf7926ddafc41f249a29f76f37cdb9e8680ac9b5af4"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/1c/bf/f240cea66ada23676c635411f5dd2ad1a04bd8cf39804080e3e903203b5a/cachetools-5.1.0.tar.gz"
    sha256 "8b3b8fa53f564762e5b221e9896798951e7f915513abf2ba072ce0f07f3f5a98"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/c5/63/a8e4b0c24e8538cec5579edbb2df4ed1f980d5f186878905317139d83b61/certifi-2022.5.18.tar.gz"
    sha256 "6ae10321df3e464305a46e997da41ea56c1d311fb9ff1dd4e04d6f14653ec63a"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/71/33/0115d1f56dce6bc9f4f4b394347c52a7182109026d2c25d8837047e3edee/cliff-3.10.1.tar.gz"
    sha256 "045aee3f3c64471965d7ad507ce8474a4e2f20815fbb5405a770f8596a2a00a0"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/0b/22/3206860cce08a384909fdf7f7bf21a20d881c6ce533f0b046bb356a373ef/cmd2-2.4.1.tar.gz"
    sha256 "f3b0467daca18fca0dc7838de7726a72ab64127a018a377a86a6ed8ebfdbb25f"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/51/05/bb2b681f6a77276fc423d04187c39dafdb65b799c8d87b62ca82659f9ead/cryptography-37.0.2.tar.gz"
    sha256 "f224ad253cc9cea7568f49077007d2263efa57396a2f2f78114066fd54b5c68e"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/c8/7d/904f64535d04f754c20a02a296de0bf3fb02be8ff5274155e41c89ae211a/debtcollector-2.5.0.tar.gz"
    sha256 "dc9d1ad3f745c43f4bbedbca30f9ffe8905a8c028c9926e61077847d5ea257ab"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/99/fb/e7cd35bba24295ad41abfdff30f6b4c271fd6ac70d20132fa503c3e768e0/dnspython-2.2.1.tar.gz"
    sha256 "0f7569a4a6ff151958b64304071d370daa3243d15941a7beedf0c9fe5105603e"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/ab/d2/45ea0ee13c6cffac96c32ac36db0299932447a736660537ec31ec3a6d877/docker-5.0.3.tar.gz"
    sha256 "d916a26b62970e7c2f554110ed6af04c7ccff8e9f81ad17d0d40c75637e227fb"
  end

  resource "dogpile.cache" do
    url "https://files.pythonhosted.org/packages/0e/94/73c2d93c9e3293115e5b831da50d6dcb20959a424309e2ddcc485238e0ce/dogpile.cache-1.1.5.tar.gz"
    sha256 "0f01bdc329329a8289af9705ff40fadb1f82a28c336f3174e12142b70d31c756"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/fd/8c/3c24a436775d6582effe4ecaf33b2562e6a7f0cbc647a293c764c5eac9ee/google-auth-2.6.6.tar.gz"
    sha256 "1ba4938e032b73deb51e59c4656a00e0939cf0b1112575099f136babb4563312"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/28/97/d2d3d96952c77e7593e0f4a634656fb384f7282327f7fef74b726b3b4c1c/iso8601-1.0.2.tar.gz"
    sha256 "27f503220e6845d9db954fb212b95b0362d8b7e6c1b2326a87061c3de93594b1"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/06/7e/44686b986ef9ca6069db224651baaa8300b93af2a085a5b135997bf659b3/jmespath-1.0.0.tar.gz"
    sha256 "a490e280edd1f57d6de88636992d05b71e97d69a26a19f058ecf7d304474bf5e"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/21/67/83452af2a6db7c4596d1e2ecaa841b9a900980103013b867f2865e5e1cf0/jsonpatch-1.32.tar.gz"
    sha256 "b6ddfe6c3db30d81a96aaeceb6baf916094ffa23d7dd5fa2c13e13f8b6e600c2"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/a0/6c/c52556b957a0f904e7c45585444feef206fe5cb1ff656303a1d6d922a53b/jsonpointer-2.3.tar.gz"
    sha256 "97cba51526c829282218feb99dab1b1e6bdf8efd1c43dc9d57be093c0d69c99a"
  end

  resource "junos-eznc" do
    url "https://files.pythonhosted.org/packages/5b/ea/1e0f77b4ecf101db14a56d71f3dc4c208189364ce846523943b72a734124/junos-eznc-2.6.3.tar.gz"
    sha256 "4eee93d0af203af7cee54a8f0c7bd28af683e829edf1fd68feba85d0ad737395"
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
    url "https://files.pythonhosted.org/packages/18/4d/e6f986e9c12c1c817abcc1080bf7db56faf5ac86a7607a11a3c9cf722fa3/keystoneauth1-4.5.0.tar.gz"
    sha256 "49b3488966a43eeb0200ea511b997e6403c25d563a984c6330e82a0ebfc4540c"
  end

  resource "kubernetes" do
    url "https://files.pythonhosted.org/packages/d5/a5/e50dbde38d54aa38a191204d6e446c7b41c1ab67354a2f652e971a4b5932/kubernetes-23.6.0.tar.gz"
    sha256 "cadb1cd7c44eae5b39b50316313343c0f2aff94529f067ec2ba44d38411158e3"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/3b/94/e2b1b3bad91d15526c7e38918795883cee18b93f6785ea8ecf13f8ffa01e/lxml-4.8.0.tar.gz"
    sha256 "f63f62fc60e6228a4ca9abae28228f35e1bd3ce675013d1dfb828688d50c6e23"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/61/3c/2206f39880d38ca7ad8ac1b28d2d5ca81632d163b2d68ef90e46409ca057/msgpack-1.0.3.tar.gz"
    sha256 "51fdc7fb93615286428ee7758cecc2f374d5ff363bdd884c7ea622a7a327a81e"
  end

  resource "munch" do
    url "https://files.pythonhosted.org/packages/43/a1/ec48010724eedfe2add68eb7592a0d238590e14e08b95a4ffb3c7b2f0808/munch-2.5.0.tar.gz"
    sha256 "2d735f6f24d4dba3417fa448cae40c6e896ec1fdab6cdb5e6510999758a4dbd2"
  end

  resource "ncclient" do
    url "https://files.pythonhosted.org/packages/72/fd/ccae38393c22099229b68e8cdf061408b824e09ee207e2401c224398c5b0/ncclient-0.6.9.tar.gz"
    sha256 "0112f2ad41fb658f52446d870853a63691d69299c73c7351c520d38dbd8dc0c4"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/c3/3b/fe5bda7a3e927d9008c897cf1a0858a9ba9924a6b4750ec1824c9e617587/netaddr-0.8.0.tar.gz"
    sha256 "d6cc57c7a07b1d9d2e917aa8b36ae8ce61c35ba3fcd1b83ca31c5a0ee2b5a243"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/a6/91/86a6eac449ddfae239e93ffc1918cf33fd9bab35c04d1e963b311e347a73/netifaces-0.11.0.tar.gz"
    sha256 "043a79146eb2907edf439899f262b3dfe41717d34124298ed281139a8b93ca32"
  end

  resource "ntc-templates" do
    url "https://files.pythonhosted.org/packages/a2/24/b242054d9a21ec20502c7cfe2af7ccf394dd29a8493ddb60d796ad1dab4a/ntc_templates-3.0.0.tar.gz"
    sha256 "866c1b57af48625e1a38cc7226067e400d8a992c4d5594b914cafd7b13fd4a50"
  end

  resource "ntlm-auth" do
    url "https://files.pythonhosted.org/packages/44/a5/ab45529cc1860a1cb05129b438b189af971928d9c9c9d1990b549a6707f9/ntlm-auth-1.5.0.tar.gz"
    sha256 "c9667d361dc09f6b3750283d503c689070ff7d89f2f6ff0d38088d5436ff8543"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6e/7e/a43cec8b2df28b6494a865324f0ac4be213cb2edcf1e2a717547a93279b0/oauthlib-3.2.0.tar.gz"
    sha256 "23a8208d75b902797ea29fd31fa80a15ed9dc2c6c16fe73f5d346f83f6fa27a2"
  end

  resource "openshift" do
    url "https://files.pythonhosted.org/packages/97/c0/d8e2aae7b4e8f3709eca4fd8c2f70ea3c66151d1a5259e9a7e1ee2497608/openshift-0.13.1.tar.gz"
    sha256 "a060afb7565dda18b2749857867d80ab22b2f4143264519f493a9cabccc3b8a8"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/88/48/06ff537795ca78dd51c15d0dbfba6b2fd538f02b9b2715ba264e09d7d4e6/openstacksdk-0.61.0.tar.gz"
    sha256 "3eed308871230f0c53a8f58b6c5a358b184080c6b2c6bc69ab088eea057aa127"
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
    url "https://files.pythonhosted.org/packages/68/17/03e208f95d40f88e2fda8d60c62698eeb1ac54b19c9cafcd921d806c669a/osc-lib-2.5.0.tar.gz"
    sha256 "d8f8a450fab2a1294e0aef8cdc9a255a1bcc5b58e1b2f6098e35e6db1e13e9d1"
  end

  resource "oslo.config" do
    url "https://files.pythonhosted.org/packages/52/c0/e7e93ba68b601cf14dacac5a8ae33fe225a9ef2b9f53c284e51b4eb608bb/oslo.config-8.8.0.tar.gz"
    sha256 "96933d3011dae15608a11616bfb00d947e22da3cb09b6ff37ddd7576abd4764c"
  end

  resource "oslo.context" do
    url "https://files.pythonhosted.org/packages/da/0c/04ebb9679c3c198073081c0406b85bde525671329218c7efa929f447f258/oslo.context-4.1.0.tar.gz"
    sha256 "75a9a722a552fba8a89e8a01028fa82a6190ab317a9591bb83303a2210a79144"
  end

  resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/7c/d8/a56cdadc3eb21f399327c45662e96479cb73beee0d602769b7847e857e7d/oslo.i18n-5.1.0.tar.gz"
    sha256 "6bf111a6357d5449640852de4640eae4159b5562bbba4c90febb0034abc095d0"
  end

  resource "oslo.log" do
    url "https://files.pythonhosted.org/packages/bd/42/d15d65d3196fef425432bb525564eb6f5297ae26fcc1a1a8138ca5751eab/oslo.log-4.8.0.tar.gz"
    sha256 "9eddf6f6a2035327f2a3231a108b98e21ad90c0680380d9d1bc647ac9663e056"
  end

  resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/e8/3d/142b294299ace8a470ad47a90fe152fc21ab8b4e7f9c88dfcb9679d53ff6/oslo.serialization-4.3.0.tar.gz"
    sha256 "3aa472f434aee8bbcc0725312b7f409aa1fa54bbc134904124cf49b0e86b9115"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/31/55/09032306dc483e05e1de6fda14a885e8814ca299a875287a253d367eb9b3/oslo.utils-4.13.0.tar.gz"
    sha256 "45ba8aaa5ed056a8e8e46059ef93d5c2d7b9c99bc7480e361cf5783e47f28fba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/1d/08/3b8d8f1b4ec212c17429c2f3ff55b7f2237a1ad0c954972e39c8f0ac394c/paramiko-2.11.0.tar.gz"
    sha256 "003e6bee7c034c21fbb051bf83dc0a9ee4106204dd3c53054c71452cc4ec3938"
  end

  resource "passlib" do
    url "https://files.pythonhosted.org/packages/b6/06/9da9ee59a67fae7761aab3ccc84fa4f3f33f125b370f1ccdb915bf967c11/passlib-1.7.4.tar.gz"
    sha256 "defd50f72b65c5402ab2c573830a6978e5f202ad0d984793c8dde2c4152ebe04"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/96/9f/f4bc832eeb4ae723b86372277da56a5643b0ad472a95314e8f516a571bb0/pbr-5.9.0.tar.gz"
    sha256 "e8dca2f4b43560edef58813969f52a56cef023146cbb8931626db80e6c1c4308"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/10/88/ef38a6e4bc375600d3031e405a8d3b3dc4a154fccffd21d5d06e66c96230/prettytable-3.3.0.tar.gz"
    sha256 "118eb54fd2794049b810893653b20952349df6d3bc1764e7facd8a18064fa9b0"
  end

  resource "proxmoxer" do
    url "https://files.pythonhosted.org/packages/cc/bf/cc547d27185b98c82591924e6134decdb8583b1dc6884a54457dd63e589e/proxmoxer-1.3.1.tar.gz"
    sha256 "ef32c549877bf4439da6df3dff08be10d9dfe3bfc8a25d676a786ffe861ee096"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/88/87/72eb9ccf8a58021c542de2588a867dbefc7556e14b2866d1e40e9e2b587e/pyasn1-modules-0.2.8.tar.gz"
    sha256 "905f84c712230b2c592c19470d3ca8d552de726050d1d1716282a1f6146be65e"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
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
    url "https://files.pythonhosted.org/packages/05/ee/f48c0427845659b25d6ae6edcd480c5f5e17f9e4006f035bd94a62449908/pyspnego-0.5.2.tar.gz"
    sha256 "1fed228edc4b1730844da8237b90489be28c55681cf3934cd04fceb2253e55bf"
  end

  resource "python-consul" do
    url "https://files.pythonhosted.org/packages/7f/06/c12ff73cb1059c453603ba5378521e079c3f0ab0f0660c410627daca64b7/python-consul-1.1.0.tar.gz"
    sha256 "168f1fa53948047effe4f14d53fc1dab50192e2a2cf7855703f126f469ea11f4"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/ee/a7/4f371e8f4fd063799ad5cef8789360e5a3b94f197e956ef46a4b9fb6e988/python-keystoneclient-4.4.0.tar.gz"
    sha256 "fc17ca9a1aa493104b496ba347f12507f271b5b6e819f4de4aef6574918aa071"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/43/50/f9aa3ce530b1ba59f442042c9d57b5395853b9d336fffcb8d89fd25065de/python-neutronclient-7.8.0.tar.gz"
    sha256 "9bc66b2952912c2ba298d4c8492db897a5eafcb0ecf757e37baa691b70b47b4e"
  end

  resource "python-string-utils" do
    url "https://files.pythonhosted.org/packages/10/91/8c883b83c7d039ca7e6c8f8a7e154a27fdeddd98d14c10c5ee8fe425b6c0/python-string-utils-1.0.0.tar.gz"
    sha256 "dcf9060b03f07647c0a603408dc8b03f807f3b54a05c6e19eb14460256fac0cb"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/2f/5f/a0f653311adff905bbcaa6d3dfaf97edcf4d26138393c6ccd37a484851fb/pytz-2022.1.tar.gz"
    sha256 "1e760e2fe6a8163bc0b3d9a19c4f84342afa0a2affebfaa84b01b978a02ecaa7"
  end

  resource "pywinrm" do
    url "https://files.pythonhosted.org/packages/7c/ba/78329e124138f8edf40a41b4252baf20cafdbea92ea45d50ec712124e99b/pywinrm-0.4.3.tar.gz"
    sha256 "995674bf5ac64b2562c9c56540473109e530d36bde10c262d5a5296121ad5565"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "requests-credssp" do
    url "https://files.pythonhosted.org/packages/bc/c3/de13b8598287440ab1df7eba97b93278d309dffb920f0163a09e089b71ec/requests-credssp-2.0.0.tar.gz"
    sha256 "229afe2f6e1c9fabef64fc2bdf2a10e794ca6c4a0c00a687d53fbfaf7b8ee71d"
  end

  resource "requests_ntlm" do
    url "https://files.pythonhosted.org/packages/3e/02/6b31dfc8334caeea446a2ac3aea5b8e197710e0b8ad3c3035f7c79e792a8/requests_ntlm-1.1.0.tar.gz"
    sha256 "9189c92e8c61ae91402a64b972c4802b2457ce6a799d658256ebf084d5c7eb71"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/52/531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49f/requests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "requestsexceptions" do
    url "https://files.pythonhosted.org/packages/82/ed/61b9652d3256503c99b0b8f145d9c8aa24c514caff6efc229989505937c1/requestsexceptions-1.4.0.tar.gz"
    sha256 "b095cbc77618f066d459a02b137b020c37da9f46d9b057704019c9f77dba3065"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/52/ba/3860b1bfe6b08a727deddda52287282e10303d20f01321c3666f2e602c18/resolvelib-0.5.5.tar.gz"
    sha256 "123de56548c90df85137425a3f51eb93df89e2ba719aeb6a8023c032758be950"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/85/40/1520d68bfa07ab5a6f065a186815fb6610c86fe957bc065754e47f7b0840/rfc3986-2.0.0.tar.gz"
    sha256 "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/8c/ee/4022542e0fed77dd6ddade38e1e4dea3299f873b7fd4e6d78319953b0f83/rsa-4.8.tar.gz"
    sha256 "5c6bd9dc7a543b7fe4304a631f8a8a3b674e2bbfc49c2ae96200cdbe55df6b17"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/7e/19/f82e4af435a19b28bdbfba63f338ea20a264f4df4beaf8f2ab9bfa34072b/s3transfer-0.5.2.tar.gz"
    sha256 "95c58c194ce657a5f4fb0b9e60a84968c808888aed628cd98ab8771fe1db98ed"
  end

  resource "scp" do
    url "https://files.pythonhosted.org/packages/01/96/82028abe87441ae172ce9df2eeb46274130475bfeeb4dedeaddaf75b16a9/scp-0.14.4.tar.gz"
    sha256 "54699b92cb68ae34b5928c48a888eab9722a212502cba89aa795bd56597505bd"
  end

  resource "shade" do
    url "https://files.pythonhosted.org/packages/b0/a6/a83f14eca6f7223319d9d564030bd322ca52c910c34943f38a59ad2a6549/shade-1.33.0.tar.gz"
    sha256 "36f6936da93723f34bf99d00bae24aa4cc36125d597392ead8319720035d21e8"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/7a/47/c7cc3d4ed15f09917838a2fb4e1759eafb6d2f37ebf7043af984d8b36cf7/simplejson-3.17.6.tar.gz"
    sha256 "cf98038d2abf63a1ada5730e91e84c642ba6c225b0198c3684151b1f80c5f8a6"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/67/73/cd693fde78c3b2397d49ad2c6cdb082eb0b6a606188876d61f53bae16293/stevedore-3.5.0.tar.gz"
    sha256 "f40253887d8712eaa2bb0ea3830374416736dc8ec0e22f5a65092c1174c44335"
  end

  resource "textfsm" do
    url "https://files.pythonhosted.org/packages/9f/53/fa46575d30be6aa591712aa9c44caa7fa9f057f3bb726fe42519a5ae2d8e/textfsm-1.1.2.tar.gz"
    sha256 "85a450b441aff04b1cac726bdb36f35534a5b196cca08c8bc14fddd879c4255c"
  end

  resource "transitions" do
    url "https://files.pythonhosted.org/packages/0b/e2/694deb6e9f8b66c6a356a738237ddec13c57ac2aaa3906e5573345bf20ea/transitions-0.8.11.tar.gz"
    sha256 "7b20d32906ea4d60ee6f6c1f5dc9c9f178802425c5b155213eb0f25c277f04e4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/7c/de/9f5354b4b37df453b7d664f587124c70a75c81805095d491d39f5b591818/websocket-client-1.3.2.tar.gz"
    sha256 "50b21db0058f7a953d67cc0445be4b948d7fc196ecbeb8083d68d94628e4abf6"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/11/eb/e06e77394d6cf09977d92bff310cb0392930c08a338f99af6066a5a98f92/wrapt-1.14.1.tar.gz"
    sha256 "380a85cf89e0e69b7cfbe2ea9f765f004ff419f34194018a6827ac0e3edfed4d"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  resource "yamlordereddictloader" do
    url "https://files.pythonhosted.org/packages/56/e1/1ca77da64cc355f0de483095e841d96f2366f93b095b83869440a296c21d/yamlordereddictloader-0.4.0.tar.gz"
    sha256 "7f30f0b99ea3f877f7cb340c570921fa9d639b7f69cba18be051e27f8de2080e"
  end

  resource "zabbix-api" do
    url "https://files.pythonhosted.org/packages/e3/ed/2092731880f0de5b07067fc446dc0fc5166f2ee98018b6d524cd3e28a69d/zabbix-api-0.5.4.tar.gz"
    sha256 "2d6c62001cb79a7de6fe286424967276edaca09d3833b72fb04f7863f29fce4b"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"

    venv = virtualenv_create(libexec, "python3")
    # Install all of the resources declared on the formula into the virtualenv.
    resources.each do |r|
      # ansible-core provides all ansible binaries
      if r.name == "ansible-core"
        venv.pip_install_and_link r
      else
        venv.pip_install r
      end
    end
    venv.pip_install_and_link buildpath

    resource("ansible-core").stage do
      man1.install Dir["docs/man/man1/*.1"]
    end
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    (testpath/"playbook.yml").write <<~EOS
      ---
      - hosts: all
        gather_facts: False
        tasks:
        - name: ping
          ping:
    EOS
    (testpath/"hosts.ini").write [
      "localhost ansible_connection=local",
      " ansible_python_interpreter=#{Formula["python@3.10"].opt_bin}/python3",
      "\n",
    ].join
    system bin/"ansible-playbook", testpath/"playbook.yml", "-i", testpath/"hosts.ini"

    # Ensure requests[security] is activated
    script = "import requests as r; r.get('https://mozilla-modern.badssl.com')"
    system libexec/"bin/python3", "-c", script

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
  end
end
