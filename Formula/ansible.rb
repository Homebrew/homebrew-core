class Ansible < Formula
  include Language::Python::Virtualenv

  desc "Automate deployment, configuration, and upgrading"
  homepage "https://www.ansible.com/"
  url "https://files.pythonhosted.org/packages/6a/56/e05719098bee5586302d88b52522588060ae8e421b0d054d87581edcd652/ansible-7.3.0.tar.gz"
  sha256 "56c2fd97487b2cc83e39e895d8dfad8b2a5df34d490394a15735ebcfdc45f5be"
  license "GPL-3.0-or-later"
  head "https://github.com/ansible/ansible.git", branch: "devel"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "11869f8ad5ad1d3ba34b2f70aadcd06ce477118314090cd042a405b561e323ca"
    sha256 cellar: :any,                 arm64_monterey: "3a1ff4a8d9ccf0420ff7ec3fbcac5321b144dca8d9bbc25c1824be3f97ef4ab1"
    sha256 cellar: :any,                 arm64_big_sur:  "69ae16d8b043e3e8c8dbe81ebd508e12f367591e3d542e3df7aa4905c2014507"
    sha256 cellar: :any,                 ventura:        "e3c6f3787b9ac97050c1884bc9a099aeb3c3b8cc01858332551f9f2739468dc1"
    sha256 cellar: :any,                 monterey:       "26587059574eb3f78215b13315b6ab784ab2648e67ae2464a079acb85577299e"
    sha256 cellar: :any,                 big_sur:        "dd7abf563a487cf4313faa5f4b69a367ed63a84bac3a48339480a6660c3bff89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8705cc0523fef48511fc331fa0643f955e6d79ee8ee781ca2ec5e146e2fb1946"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.11"
  depends_on "pyyaml"
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
    url "https://files.pythonhosted.org/packages/c3/80/0df5b69d11a0daf73bd9f4ba4c23c31954dbe024243263e5d5b9393c63b8/ansible-core-2.14.3.tar.gz"
    sha256 "093a4bc4a1259eaeb56ea37ec1d33cf1836c88f39281d89197f8d3480e068a58"
  end

  resource "apache-libcloud" do
    url "https://files.pythonhosted.org/packages/ee/33/1cc39b29f392154765c9c86446892066275363c6f3cea6a5b1834d9c4301/apache-libcloud-3.7.0.tar.gz"
    sha256 "148a9e50069654432a7d34997954e91434dd38ebf68832eb9c75d442b3e62fad"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/21/31/3f468da74c7de4fcf9b25591e682856389b3400b4b62f201e65f15ea3e07/attrs-22.2.0.tar.gz"
    sha256 "c9227bfc2f01993c03f68db37d1d15c9690188323c067c641f1a35ca58185f99"
  end

  resource "autopage" do
    url "https://files.pythonhosted.org/packages/36/b1/e5a1c2ebeb64ccc9c2a4ae133f5955d9824482628ed4bf0331c73323f0de/autopage-0.5.1.tar.gz"
    sha256 "01be3ee61bb714e9090fcc5c10f4cf546c396331c620c6ae50a2321b28ed3199"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/00/25/556635bff0509b43f99d11ff6c258a8f39827a82330a705a20206df6eabb/boto3-1.26.81.tar.gz"
    sha256 "898fa38387e2f5a9136aec6cf9caa0a44ddbf78f1c4aaa33f7b1611ac44b4a4d"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/91/cc/5518bc41e62aec1e12518f443ba5bacc6bdaa8d78700bde0167d0f57ca7c/botocore-1.29.81.tar.gz"
    sha256 "b140c865fce64097c54cba37420c27f24b26cdec0fc00ce83ad439d3bdb053e1"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/4d/91/5837e9f9e77342bb4f3ffac19ba216eef2cd9b77d67456af420e7bafe51d/cachetools-5.3.0.tar.gz"
    sha256 "13dfddc7b8df938c21a940dfa6557ce6e94a2f1cdfa58eb90c805721d58f2c14"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/fe/6b/f9b689bef6ec161cb96a9f863fde77079c7edeb4cf5fa33561ee3ec22a61/cliff-4.2.0.tar.gz"
    sha256 "97fc31e93552e3bec664be9d55ad7f90dc2ab42aad8df29a5b985b644c9b8cf2"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/13/04/b85213575a7bf31cbf1d699cc7d5500d8ca8e52cbd1f3569a753a5376d5c/cmd2-2.4.3.tar.gz"
    sha256 "71873c11f72bd19e2b1db578214716f0d4f7c8fa250093c601265a9a717dee52"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/6a/f5/a729774d087e50fffd1438b3877a91e9281294f985bda0fd15bf99016c78/cryptography-39.0.1.tar.gz"
    sha256 "d1f6198ee6d9148405e49887803907fe8962a23e6c6f83ea7d98f1c0de375695"
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
    url "https://files.pythonhosted.org/packages/91/8b/522301c50ca1f78b09c2ca116ffb0fd797eadf6a76085d376c01f9dd3429/dnspython-2.3.0.tar.gz"
    sha256 "224e32b03eb46be70e12ef6d64e0be123a64e621ab4c0822ff6d450d52a540b9"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/79/26/6609b51ecb418e12d1534d00b888ce7e108f38b47dc6cd589598d5c6aaa2/docker-6.0.1.tar.gz"
    sha256 "896c4282e5c7af5c45e8b683b0b0c33932974fe6e50fc6906a0a83616ab3da97"
  end

  resource "dogpile.cache" do
    url "https://files.pythonhosted.org/packages/e4/11/c5c200e774fb6cca03288c25cdb600fb8c41f2ace38a7ebfedfd3de3c3e1/dogpile.cache-1.1.8.tar.gz"
    sha256 "d844e8bb638cc4f544a4c89a834dfd36fe935400b71a16cbd744ebdfb720fd4e"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/8f/2e/cf6accf7415237d6faeeebdc7832023c90e0282aa16fd3263db0eb4715ec/future-0.18.3.tar.gz"
    sha256 "34a17436ed1e96697a86f9de3d15a3b0be01d8bc8de9c1dffd59fb8234ed5307"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/3b/84/5d156b0736abe57ab060e81775c776602679522c141eb3ca367f31e4d858/google-auth-2.16.1.tar.gz"
    sha256 "5fd170986bce6bfd7bb5c845c4b8362edb1e0cba901e062196e83f8bb5d5d32c"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/90/07/6397ad02d31bddf1841c9ad3ec30a693a3ff208e09c2ef45c9a8a5f85156/importlib_metadata-6.0.0.tar.gz"
    sha256 "e354bedeb60efa6affdcc8ae121b73544a7aa74156d047311948f6d711cd378d"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/31/8c/1c342fdd2f4af0857684d16af766201393ef53318c15fa785fcb6c3b7c32/iso8601-1.1.0.tar.gz"
    sha256 "32811e7b81deee2063ea6d2e94f8819a86d1f3811e49d23623a41fa832bef03f"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
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
    url "https://files.pythonhosted.org/packages/7c/4e/501d8138f3794e8bb2221dc8e214f3a5d4548f5e8ab89968c02c9eba6bd1/junos-eznc-2.6.7.tar.gz"
    sha256 "b3ab81dafb160cd16cba8f26b92b6f5c3333a8d30566a7ebd966fc1f313b0980"
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
    url "https://files.pythonhosted.org/packages/2a/3c/6b7882c3f16acdc0321d538db8d4dc79846e7fe93c1729926e91e6512261/keystoneauth1-5.1.2.tar.gz"
    sha256 "d9f7484ad5fc9b0bbb7ecc3cbf3795a170694fbd848251331e54ba48bbeecc72"
  end

  resource "kubernetes" do
    url "https://files.pythonhosted.org/packages/34/19/2f351c0eaf05234dc33a6e0ffc7894e9dedab0ff341311c5b4ba44f2d8ac/kubernetes-26.1.0.tar.gz"
    sha256 "5854b0c508e8d217ca205591384ab58389abdae608576f9c9afc35a3c76a366c"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/06/5a/e11cad7b79f2cf3dd2ff8f81fa8ca667e7591d3d8451768589996b65dec1/lxml-4.9.2.tar.gz"
    sha256 "2455cfaeb7ac70338b3257f41e21f0724f4b5b0c0e7702da67ee6c3640835b67"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/22/44/0829b19ac243211d1d2bd759999aa92196c546518b0be91de9cacc98122a/msgpack-1.0.4.tar.gz"
    sha256 "f5d869c18f030202eb412f08b28d2afeea553d6613aee89e200d7aca7ef01f5f"
  end

  resource "ncclient" do
    url "https://files.pythonhosted.org/packages/ee/6f/ef2796c82d097dbead1b804db8457fc8fdc244e3d6860eb0a702315dbf67/ncclient-0.6.13.tar.gz"
    sha256 "f9f8cea8bcbe057e1b948b9cd1b241eafb8a3f73c4981fbdfa1cc6ed69c0a7b3"
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
    url "https://files.pythonhosted.org/packages/76/ac/5eb6deba6920830200f3f48d61fc886fc19913146e3571de09c9aece96dd/ntc_templates-3.2.0.tar.gz"
    sha256 "ee6abdfef0dd06ba2921b61d6f3321f8dfbdfdccf4a46853703cf7fa393664bc"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "openshift" do
    url "https://files.pythonhosted.org/packages/97/c0/d8e2aae7b4e8f3709eca4fd8c2f70ea3c66151d1a5259e9a7e1ee2497608/openshift-0.13.1.tar.gz"
    sha256 "a060afb7565dda18b2749857867d80ab22b2f4143264519f493a9cabccc3b8a8"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/94/47/76d19285d0f4a631c1b01bec39f4cccb7fc613d23bcd5a2785012346a290/openstacksdk-1.0.1.tar.gz"
    sha256 "365e5dcca64e16e74a4f9f9d2a1f2207970e946d9a5c482549cfa5ec02ca2c98"
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
    url "https://files.pythonhosted.org/packages/c9/1a/29836591c14ac7e41bc83996e58b4bc3f9d20d9b14f342775f6e8d819347/osc-lib-2.7.0.tar.gz"
    sha256 "b6263ff5d03b47f243fafc96a02b0a9558dc706bc609d7e52a7070cd6a27b000"
  end

  resource "oslo.config" do
    url "https://files.pythonhosted.org/packages/c2/f1/9012e248ca4a53d64aa2db2a9aad1c38861ec77237a149a521d00cf95c0a/oslo.config-9.1.1.tar.gz"
    sha256 "b07654b53d87792ae8e739962ad729c529c9938a118d891ece9ee31d59716bc9"
  end

  resource "oslo.context" do
    url "https://files.pythonhosted.org/packages/bc/ea/a81a65b2b322d7f71bb5764c7fb61f9636fbc1f8291e4984e8d3b1a1ab0e/oslo.context-5.1.1.tar.gz"
    sha256 "2f2e79171044efd1807c55713ed2c7f4068b18d73d027819165c4819b287cfaf"
  end

  resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/52/7a/655c1c95666d30400d59612a67f510a5395d821f7ae9e306b3fa2a2102e0/oslo.i18n-6.0.0.tar.gz"
    sha256 "ed10686b75f7c607825177a669155f4e259ce39f6143a375f6359bbcaa4a35cd"
  end

  resource "oslo.log" do
    url "https://files.pythonhosted.org/packages/46/9b/0bed0585d484b4da92278a572803db4bd9f056b907ea6dbcdc7220b5fdc9/oslo.log-5.1.0.tar.gz"
    sha256 "f6ac37af95918e05d7a1dd7d0b0552ba8b22b2e430862eb336de592d25c84f29"
  end

  resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/57/7c/fb7ac9b6fd5137763bb1265c85134decfbe3c6a3ee398e1a4b70a8183bad/oslo.serialization-5.1.1.tar.gz"
    sha256 "8abbda8b1763a06071fc28c5d8a9be547ba285f4830e68a70ff88fe11f16bf43"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/f7/49/7f6790af38e9ce1a1418dd74c7d07492d711384269b1cecc69bef136b033/oslo.utils-6.1.0.tar.gz"
    sha256 "76bc0108d50aca972b68fec8298e791b5fbcbeb9a51a27c6986b41b0a6a62eeb"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/3b/6b/554c00e5e68cd573bda345322a4e895e22686e94c7fa51848cd0e0442a71/paramiko-3.0.0.tar.gz"
    sha256 "fedc9b1dd43bc1d45f67f1ceca10bc336605427a46dcdf8dec6bfea3edf57965"
  end

  resource "passlib" do
    url "https://files.pythonhosted.org/packages/b6/06/9da9ee59a67fae7761aab3ccc84fa4f3f33f125b370f1ccdb915bf967c11/passlib-1.7.4.tar.gz"
    sha256 "defd50f72b65c5402ab2c573830a6978e5f202ad0d984793c8dde2c4152ebe04"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/ba/b6/8e78337766d4c324ac22cb887ecc19487531f508dbf17d922b91492d55bb/prettytable-3.6.0.tar.gz"
    sha256 "2e0026af955b4ea67b22122f310b90eae890738c08cb0458693a49b6221530ac"
  end

  resource "proxmoxer" do
    url "https://files.pythonhosted.org/packages/00/dd/629ec9dfdab26a75e3120403231bf3dc3ecda3ebe36db72c829ae30cbfca/proxmoxer-2.0.1.tar.gz"
    sha256 "088923f1a81ee27631e88314c609bfe22b33d8a41271b5f02e86f996f837fe31"
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
    url "https://files.pythonhosted.org/packages/97/b7/2ca5b546fc91d6c41e1796e49d0615fe7dfb4845d088da8a938934b3d63c/pyspnego-0.8.0.tar.gz"
    sha256 "e0499cc066c56762f8a315bb053243d34240cb85e384afc6b87b4fa0142543df"
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
    url "https://files.pythonhosted.org/packages/bb/57/f59abb588eb28c1b5a8432e3163a2135183672e2dceb747aed0b26f3db01/python-keystoneclient-5.1.0.tar.gz"
    sha256 "ba09bdfeafa2a2196450a327cd3f46f2a8a9dd9d21b838f8cb9b17a99740c6a1"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/ef/e4/107865bfbdd8153e15431e2fb9988a29b69de5558b928fd4a4671ceed972/python-neutronclient-9.0.0.tar.gz"
    sha256 "a4062d10052940b31dbeb4479c99de4281b32f343998177195a36860e2eb04db"
  end

  resource "python-string-utils" do
    url "https://files.pythonhosted.org/packages/10/91/8c883b83c7d039ca7e6c8f8a7e154a27fdeddd98d14c10c5ee8fe425b6c0/python-string-utils-1.0.0.tar.gz"
    sha256 "dcf9060b03f07647c0a603408dc8b03f807f3b54a05c6e19eb14460256fac0cb"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/03/3e/dc5c793b62c60d0ca0b7e58f1fdd84d5aaa9f8df23e7589b39cc9ce20a03/pytz-2022.7.1.tar.gz"
    sha256 "01a0681c4b9684a28304615eba55d1ab31ae00bf68ec157ec3708a8182dbbcd0"
  end

  resource "pywinrm" do
    url "https://files.pythonhosted.org/packages/7c/ba/78329e124138f8edf40a41b4252baf20cafdbea92ea45d50ec712124e99b/pywinrm-0.4.3.tar.gz"
    sha256 "995674bf5ac64b2562c9c56540473109e530d36bde10c262d5a5296121ad5565"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "requests-credssp" do
    url "https://files.pythonhosted.org/packages/bc/c3/de13b8598287440ab1df7eba97b93278d309dffb920f0163a09e089b71ec/requests-credssp-2.0.0.tar.gz"
    sha256 "229afe2f6e1c9fabef64fc2bdf2a10e794ca6c4a0c00a687d53fbfaf7b8ee71d"
  end

  resource "requests-ntlm" do
    url "https://files.pythonhosted.org/packages/7a/ad/486a6ca1879cf1bb181e3e4af4d816d23ec538a220ef75ca925ccb7dd31d/requests_ntlm-1.2.0.tar.gz"
    sha256 "33c285f5074e317cbdd338d199afa46a7c01132e5c111d36bd415534e9b916a8"
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
    url "https://files.pythonhosted.org/packages/ac/20/9541749d77aebf66dd92e2b803f38a50e3a5c76e7876f45eb2b37e758d82/resolvelib-0.8.1.tar.gz"
    sha256 "c6ea56732e9fb6fca1b2acc2ccc68a0b6b8c566d8f3e78e0443310ede61dbd37"
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
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "scp" do
    url "https://files.pythonhosted.org/packages/b6/50/277f788967eed7aa2cbb669ff91dff90d2232bfda95577515a783bbccf73/scp-0.14.5.tar.gz"
    sha256 "64f0015899b3d212cb8088e7d40ebaf0686889ff0e243d5c1242efe8b50f053e"
  end

  resource "shade" do
    url "https://files.pythonhosted.org/packages/b0/a6/a83f14eca6f7223319d9d564030bd322ca52c910c34943f38a59ad2a6549/shade-1.33.0.tar.gz"
    sha256 "36f6936da93723f34bf99d00bae24aa4cc36125d597392ead8319720035d21e8"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/b1/86/a67f6f595c5da14fa80bb4a8f7084c391ac1bfd3208ea4906307afc2b181/simplejson-3.18.3.tar.gz"
    sha256 "ebb53837c5ffcb6100646018565d3f1afed6f4b185b14b2c9cbccf874fe40157"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/f1/25/993d09dc7be3e7927228853c75324104d734bb784bd766b025ebf9f47b16/stevedore-5.0.0.tar.gz"
    sha256 "2c428d2338976279e8eb2196f7a94910960d9f7ba2f41f3988511e95ca447021"
  end

  resource "textfsm" do
    url "https://files.pythonhosted.org/packages/b8/bf/c9147d29c5a3ff4c1c876e16ea02f6d4e4f35ba1bcbb2ac80a254924f0aa/textfsm-1.1.3.tar.gz"
    sha256 "577ef278a9237f5341ae9b682947cefa4a2c1b24dbe486f94f2c95addc6504b5"
  end

  resource "transitions" do
    url "https://files.pythonhosted.org/packages/bc/c0/d2e5b8a03ad07c10694ab0804682722b9293fbe89391a8508aff1f6d9603/transitions-0.9.0.tar.gz"
    sha256 "2f54d11bdb225779d7e729011e93a9fb717668ce3dc65f8d4f5a5d7ba2f48e10"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/8b/94/696484b0c13234c91b316bc3d82d432f9b589a9ef09d016875a31c670b76/websocket-client-1.5.1.tar.gz"
    sha256 "3f09e6d8230892547132177f575a4e3e73cfdf06526e20cc02aa1c3b47184d40"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/f8/7d/73e4e3cdb2c780e13f9d87dc10488d7566d8fd77f8d68f0e416bfbd144c7/wrapt-1.15.0.tar.gz"
    sha256 "d06730c6aed78cee4126234cf2d071e01b44b915e725a6cb439a879ec9754a3a"
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
    url "https://files.pythonhosted.org/packages/53/ff/b0817b791bce12fb7def0aefafd09f4336f952e21c7b202a1f579f25146c/zabbix-api-0.5.5.tar.gz"
    sha256 "7e7b84792090bd3aa546fccb0e13c830dbfe0431303509b009f6d2783ca2418d"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/00/27/f0ac6b846684cecce1ee93d32450c45ab607f65c2e0255f0092032d91f07/zipp-3.15.0.tar.gz"
    sha256 "112929ad649da941c23de50f356a2b5570c954b65150642bccdd66bf194d224b"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")
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
      man1.install Pathname.glob("docs/man/man1/*.1")
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
  end
end
