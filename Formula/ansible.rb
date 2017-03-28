class Ansible < Formula
  include Language::Python::Virtualenv

  desc "Automate deployment, configuration, and upgrading"
  homepage "https://www.ansible.com/"
  url "https://releases.ansible.com/ansible/ansible-2.2.1.0.tar.gz"
  sha256 "63a12ea784c0f90e43293b973d5c75263634c7415e463352846cd676c188e93f"
  revision 2

  head "https://github.com/ansible/ansible.git", :branch => "devel"

  bottle do
    sha256 "3a3ed57c48fab11487fbd7b9526993d6de5597354bcec541f23834d7ace272c1" => :sierra
    sha256 "05167277096f68dd05abc66c7ff40c9f5e2a9a2cbcdc1f31f96b83510ee40eba" => :el_capitan
    sha256 "6d06db627c51b56ffb07449673ddbd53b10c52ae7c6d2d889ef77bdbf5f6b28e" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on :python
  depends_on "libyaml"
  depends_on "openssl@1.1"

  # Collect requirements from:
  #   ansible
  #   docker-py
  #   pyrax (Rackspace)
  #   shade (OpenStack)
  #   pywinrm (Windows)
  #   kerberos (Windows)
  #   xmltodict (Windows)
  #   boto (AWS)
  #   boto3 (AWS)
  #   botocore (AWS)
  #   apache-libcloud (Google GCE)
  #   python-keyczar (Accelerated Mode)
  #   passlib (htpasswd core module)
  #   zabbix-api (Zabbix extras module)

  ### setup_requires dependencies
  resource "pbr" do
    url "https://files.pythonhosted.org/packages/c3/2c/63275fab26a0fd8cadafca71a3623e4d0f0ee8ed7124a5bb128853d178a7/pbr-1.10.0.tar.gz"
    sha256 "186428c270309e6fdfe2d5ab0949ab21ae5f7dea831eab96701b86bd666af39c"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/d0/e1/aca6ef73a7bd322a7fc73fd99631ee3454d4fc67dc2bee463e2adf6bb3d3/pytz-2016.10.tar.bz2"
    sha256 "7016b2c4fa075c564b81c37a252a5fccf60d8964aa31b7f5eae59aeb594ae02b"
  end
  ### end

  ### extras for requests[security]
  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/0c/d6/b1fe519846a21614fa4f8233361574eddb223e0bc36b182140d916acfb3b/pyOpenSSL-16.2.0.tar.gz"
    sha256 "7779a3bbb74e79db234af6a08775568c6769b5821faecf6e2f4143edb227516e"
  end

  resource "ndg-httpsclient" do
    url "https://files.pythonhosted.org/packages/a2/a7/ad1c1c48e35dc7545dab1a9c5513f49d5fa3b5015627200d2be27576c2a0/ndg_httpsclient-0.4.2.tar.gz"
    sha256 "580987ef194334c50389e0d7de885fccf15605c13c6eecaabd8d6c43768eb8ac"
  end
  ### end

  # The rest of this list should always be sorted by:
  # pip install homebrew-pypi-poet && poet_lint $(brew formula ansible)
  resource "Babel" do
    url "https://files.pythonhosted.org/packages/6e/96/ba2a2462ed25ca0e651fb7b66e7080f5315f91425a07ea5b34d7c870c114/Babel-2.3.4.tar.gz"
    sha256 "c535c4403802f6eb38173cd4863e419e2274921a01a8aad8a5b497c131c62875"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/5f/bd/5815d4d925a2b8cbbb4b4960f018441b0c65f24ba29f3bdcfb3c8218a307/Jinja2-2.8.1.tar.gz"
    sha256 "35341f3a97b46327b3ef1eb624aadea87a535b8f50863036e085e7c426ac5891"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/4d/de/32d741db316d8fdb7680822dd37001ef7a448255de9699ab4bfcbdf4172b/MarkupSafe-1.0.tar.gz"
    sha256 "a6be69091dac236ea9c6bc7d012beab42010fa914c459791d627dad4910eb665"
  end

  resource "PrettyTable" do
    # When switching to a different version, check if file permissions of the installed files need to be fixed. (See the "install" method below.)
    url "https://files.pythonhosted.org/packages/ef/30/4b0746848746ed5941f052479e7c23d2b56d174b82f4fd34a25e389831f5/prettytable-0.7.2.tar.bz2"
    sha256 "853c116513625c738dc3ce1aee148b5b5757a86727e67eff6502c7ca59d43c36"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "apache-libcloud" do
    url "https://files.pythonhosted.org/packages/1d/a6/569313d0c95b6e0bbebc5f2c8197a7261c85556a3de84d42e9093d7d6996/apache-libcloud-1.5.0.tar.bz2"
    sha256 "ea3dd7825e30611e5a018ab18107b33a9029097d64bd8b39a87feae7c2770282"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz"
    sha256 "9e5896d1372858f8dd3344faf4e5014d21849c756c8d5701f78f8a103b372d92"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/ce/39/17e90c2efacc4060915f7d1f9b8d2a5b20e54e46233bdf3092e68193407d/asn1crypto-0.21.1.tar.gz"
    sha256 "4e6d7b22814d680114a439faafeccb9402a78095fb23bf0b25f9404c6938a017"
  end

  resource "backports.ssl_match_hostname" do
    url "https://files.pythonhosted.org/packages/76/21/2dc61178a2038a5cb35d14b61467c6ac632791ed05131dda72c20e7b9e23/backports.ssl_match_hostname-3.5.0.1.tar.gz"
    sha256 "502ad98707319f4a51fa2ca1c677bd659008d27ded9f6380c79e8932e38dcdf2"
  end

  resource "boto" do
    url "https://files.pythonhosted.org/packages/b1/f9/cf8fa9a4a48e651294fc88446edee96f8b965f1d3ca044befc5dd7c9449b/boto-2.46.1.tar.gz"
    sha256 "d24a68d97276445d1b5baee6537bc565ab7070afcd449a72f2541b1da1328ed4"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/58/61/50d2e459049c5dbc963473a71fae928ac0e58ffe3fe7afd24c817ee210b9/boto3-1.4.4.tar.gz"
    sha256 "518f724c4758e5a5bed114fbcbd1cf470a15306d416ff421a025b76f1d390939"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/6f/c7/b4241da1abfd4b76c00409bcc76adf05ef942e178a2531fb490f098b26a0/botocore-1.5.24.tar.gz"
    sha256 "43f95a338b3d56e3006cc67bb9d55dadebbe6276fe752e7b72edf57314f37604"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a1/32/e3d6c3a8b5461b903651dd6ce958ed03c093d2e00128e3f33ea69f1d7965/cffi-1.9.1.tar.gz"
    sha256 "563e0bd53fda03c151573217b3a49b3abad8813de9dd0632e10090f6190fdaf8"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/5a/86/61cb36713a6feb28cfb3201022a218c359dc988cf9f65b2e2681cb33cf8d/cliff-2.4.0.tar.gz"
    sha256 "cc9175e3c2a42bc06343290a1218bc6b70f36883520b2948f743c5f9ae917675"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/97/80/d5c6efd4a1467865fd25c203fbe3a107f241b09f30cc7f8d9a3e3bef8abd/cmd2-0.6.9.tar.gz"
    sha256 "ef09745c91dbc13344db6d81f4dea4c844bf2fabf3baf91fab1bb54e4b3bb328"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/ec/5f/d5bc241d06665eed93cd8d3aa7198024ce7833af7a67f6dc92df94e00588/cryptography-1.8.1.tar.gz"
    sha256 "323524312bb467565ebca7e50c8ae5e9674e544951d28a2904a50012a8828190"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/c4/1e/89680e36d87799bdaf685c0896b66b1fa4301ff9ce1aaa0f53d34f7911a9/debtcollector-1.11.0.tar.gz"
    sha256 "733afa881c844a40ef4623ab73ce1862e505bc4655635da3a91d8f3482677785"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/cc/ac/5a16f1fc0506ff72fcc8fd4e858e3a1c231f224ab79bb7c4c9b2094cc570/decorator-4.0.11.tar.gz"
    sha256 "953d6bf082b100f43229cf547f4f97f97e970f5ad645ee7601d55ff87afdfe76"
  end

  resource "dnspython" do
    url "https://pypi.python.org/packages/e4/96/a598fa35f8a625bc39fed50cdbe3fd8a52ef215ef8475c17cabade6656cb/dnspython-1.15.0.zip"
    sha256 "40f563e1f7a7b80dc5a4e76ad75c23da53d62f1e15e6e517293b04e1f84ead7c"
  end

  resource "docker-py" do
    url "https://files.pythonhosted.org/packages/fa/2d/906afc44a833901fc6fed1a89c228e5c88fbfc6bd2f3d2f0497fdfb9c525/docker-py-1.10.6.tar.gz"
    sha256 "4c2a75875764d38d67f87bc7d03f7443a3895704efc57962bdf6500b8d4bc415"
  end

  resource "docker-pycreds" do
    url "https://files.pythonhosted.org/packages/95/2e/3c99b8707a397153bc78870eb140c580628d7897276960da25d8a83c4719/docker-pycreds-0.2.1.tar.gz"
    sha256 "93833a2cf280b7d8abbe1b8121530413250c6cd4ffed2c1cf085f335262f7348"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/05/25/7b5484aca5d46915493f1fd4ecb63c38c333bd32aa9ad6e19da8d08895ae/docutils-0.13.1.tar.gz"
    sha256 "718c0f5fb677be0f34b781e04241c4067cbd9327b66bdd8e763201130f5175be"
  end

  resource "dogpile.cache" do
    url "https://files.pythonhosted.org/packages/9d/a9/ba70aadc6170841a1c6145e9039d4b1c2a4ef8c44cd0ca9b09ab79be9120/dogpile.cache-0.6.2.tar.gz"
    sha256 "73793471af07af6dc5b3ee015abfaca4220caaa34c615537f5ab007ed150726d"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "funcsigs" do
    url "https://files.pythonhosted.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz"
    sha256 "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50"
  end

  resource "functools32" do
    url "https://files.pythonhosted.org/packages/c5/60/6ac26ad05857c601308d8fb9e87fa36d0ebf889423f47c3502ef034365db/functools32-3.2.3-2.tar.gz"
    sha256 "f6253dfbe0538ad2e387bd8fdfd9293c925d63553f5813c4e587745416501e6d"
  end

  resource "futures" do
    url "https://files.pythonhosted.org/packages/55/db/97c1ca37edab586a1ae03d6892b6633d8eaa23b23ac40c7e5bbc55423c78/futures-3.0.5.tar.gz"
    sha256 "0542525145d5afc984c88f914a0c85c77527f65946617edb5274f72406f981df"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/d8/82/28a51052215014efc07feac7330ed758702fc0581347098a81699b5281cb/idna-2.5.tar.gz"
    sha256 "3cb5ce08046c4e3a560fc02f138d0ac63e00f8ce5901a56b32ec8b7994082aab"
  end

  resource "ip_associations_python_novaclient_ext" do
    url "https://files.pythonhosted.org/packages/01/4e/230d9334ea61efb16dda8bef558fd11f8623f6f3ced8a0cf68559435b125/ip_associations_python_novaclient_ext-0.2.tar.gz"
    sha256 "e4576c3ee149bcca7e034507ad9c698cb07dd9fa10f90056756aea0fa59bae37"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/4e/13/774faf38b445d0b3a844b65747175b2e0500164b7c28d78e34987a5bfe06/ipaddress-1.0.18.tar.gz"
    sha256 "5d8534c8e185f2d8a1fda1ef73f2c8f4b23264e8e30063feeb9511d492a413e1"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/c0/75/c9209ee4d1b5975eb8c2cba4428bde6b61bd55664a98290dd015cdb18e98/iso8601-0.1.11.tar.gz"
    sha256 "e8fb52f78880ae063336c94eb5b87b181e6a0cc33a6c008511bac9a6e980ef30"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/9d/1a/c8ab901753ad7581032f99f88c759a45b6c72b75615f0cd731dd7c9dd0de/jmespath-0.9.1.tar.gz"
    sha256 "e72d02de23c1814322f7c0dcffb46716271f9b52b129aace0ab6f5a0450d5f02"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/be/c1/947048a839120acefc13a614280be3289db404901d1a2d49b6310c6d5757/jsonpatch-1.15.tar.gz"
    sha256 "ae23cd08b2f7246f8f2475363501e740c4ef93f08f2a3b7b9bcfac0cc37fceb1"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/f6/36/6bdd302303e8bc7c25102dbc1eabb3e3d97f57b0f8f414f4da7ea7ab9dd8/jsonpointer-1.10.tar.gz"
    sha256 "9fa5dcac35eefd53e25d6cd4c310d963c9f0b897641772cd6e5e7b89df7ee0b1"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/58/0d/c816f5ea5adaf1293a1d81d32e4cdfdaf8496973aa5049786d7fdb14e7e7/jsonschema-2.5.1.tar.gz"
    sha256 "36673ac378feed3daa5956276a829699056523d7961027911f064b52255ead41"
  end

  resource "kerberos" do
    url "https://files.pythonhosted.org/packages/46/73/1e7520780a50c9470aeba2b3c020981201c8662b618fb2889a3e3dc2aeed/kerberos-1.2.5.tar.gz"
    sha256 "b32ae66b1da2938a2ae68f83d67ce41b5c5e3b6c731407104cd209ba426dadfe"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/66/30/288e93e950f5b41bc93046094744814f178e96e9fe36441d7253c8df66e4/keyring-10.2.tar.gz"
    sha256 "bf49be09b31db401791bde1799da30d6926e7de2f0fb836c3dfc85aa5538a572"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/d7/f5/d6e5d18d46ac30369f334eda6b751096c6c5e85688a3b388ff4622f53e9a/keystoneauth1-2.18.0.tar.gz"
    sha256 "075a9ca7a8877c5885fa2487699015e45260c4e6be119683effe0ad2ab1255d2"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/0c/53/014354fc93c591ccc4abff12c473ad565a2eb24dcd82490fae33dbf2539f/mock-2.0.0.tar.gz"
    sha256 "b158b6df76edd239b8208d481dc46b6afd45a846b7812ff0ce58971cf5bc8bba"
  end

  resource "monotonic" do
    url "https://files.pythonhosted.org/packages/08/35/9e06c881c41962d7367e9466724beda2b1101439b149b7ff708d708890de/monotonic-1.2.tar.gz"
    sha256 "c0e1ceca563ca6bb30b0fb047ee1002503ae6ad3585fc9c6af37a8f77ec274ba"
  end

  resource "msgpack-python" do
    url "https://files.pythonhosted.org/packages/21/27/8a1d82041c7a2a51fcc73675875a5f9ea06c2663e02fcfeb708be1d081a0/msgpack-python-0.4.8.tar.gz"
    sha256 "1a2b19df0f03519ec7f19f826afb935b202d8979b0856c6fb3dc28955799f886"
  end

  resource "munch" do
    url "https://files.pythonhosted.org/packages/9d/0e/b2f9d2171182a521e90fe077c924ced5cfdea42efb1fe8c394a1b6fd7511/munch-2.1.0.tar.gz"
    sha256 "b7cc5c5e25b0de16dda314b4054dcd9b9b6e72740b1bf3f54814b40fd83c46c9"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/0c/13/7cbb180b52201c07c796243eeff4c256b053656da5cfe3916c3f5b57b3a0/netaddr-0.7.19.tar.gz"
    sha256 "38aeec7cdd035081d3a4c306394b19d677623bf76fa0913f6695127c7753aefd"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/a7/4c/8e0771a59fd6e55aac993a7cc1b6a0db993f299514c464ae6a1ecf83b31d/netifaces-0.10.5.tar.gz"
    sha256 "59d8ad52dd3116fcb6635e175751b250dc783fb011adba539558bd764e5d628b"
  end

  resource "ntlm-auth" do
    url "https://files.pythonhosted.org/packages/ac/99/5183cbb714537e0bd31dd266f2bad894f17112f862bb5c65fd6a5367dd2b/ntlm-auth-1.0.2.zip"
    sha256 "06b8d587c757c050ec4dce75057f41d519dfae42b09686387463290826ffda63"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/46/ee/b950c5a362ba67587974049a60428a1017bad57ca57f6840f0a5df0980be/openstacksdk-0.9.14.tar.gz"
    sha256 "ac40cc1a5d4ade6a50fbe147a617de0b8adb2285b52a5ccd85896cc1e13a24e8"
  end

  resource "ordereddict" do
    url "https://files.pythonhosted.org/packages/53/25/ef88e8e45db141faa9598fbf7ad0062df8f50f881a36ed6a0073e1572126/ordereddict-1.1.tar.gz"
    sha256 "1c35b4ac206cef2d24816c89f89cf289dd3d38cf7c449bb3fab7bf6d43f01b1f"
  end

  resource "os-client-config" do
    url "https://files.pythonhosted.org/packages/28/43/d2d7f2e9d0c911de155aaa22d3103ee478f95604dfce5d4df4f8fb3bda05/os-client-config-1.25.0.tar.gz"
    sha256 "9f3c89b533e7c07abe951ec5ff691fc4c1e8e68969863efc807b170c6d457f60"
  end

  resource "os_diskconfig_python_novaclient_ext" do
    url "https://files.pythonhosted.org/packages/a9/2c/306ef3376bee5fda62c1255da05db2efedc8276be5be98180dbd224d9949/os_diskconfig_python_novaclient_ext-0.1.3.tar.gz"
    sha256 "e7d19233a7b73c70244d2527d162d8176555698e7c621b41f689be496df15e75"
  end

  resource "os_networksv2_python_novaclient_ext" do
    url "https://files.pythonhosted.org/packages/9e/86/6ec4aa97a5e426034f8cc5657186e18303ffb89f37e71375ee0b342b7b78/os_networksv2_python_novaclient_ext-0.26.tar.gz"
    sha256 "613a75216d98d3ce6bb413f717323e622386c24fc9cc66148507539e7dc5bf19"
  end

  resource "os_virtual_interfacesv2_python_novaclient_ext" do
    url "https://files.pythonhosted.org/packages/db/33/d5e87b099c9d394a966051cde526c9fcfdd46a51762a8054c98d3ae3b464/os_virtual_interfacesv2_python_novaclient_ext-0.20.tar.gz"
    sha256 "6d39ff4174496a0f795d11f20240805a16bbf452091cf8eb9bd1d5ae2fca449d"
  end

  resource "osc-lib" do
    url "https://files.pythonhosted.org/packages/e5/5b/b0c6e7d737468c6de98d880ed90cacb11d080030d24b881dcce809f9ac3e/osc-lib-1.3.0.tar.gz"
    sha256 "32bf892ba828241f93ae0ef5c94d6b92ac3deb9f061dd4ffb61e05120b4ff365"
  end

  resource "oslo.config" do
    url "https://files.pythonhosted.org/packages/ee/5e/ba84db7ce2d8eea8e7aaef1d112596bf161f91ac9596468d5bcdda629245/oslo.config-3.22.0.tar.gz"
    sha256 "6b7d341d8bdce8026028485f8238ee7865edb123ffb5f916956ed52f37de3e47"
  end

  resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/ab/ff/65b92fea4afefd0c9e71e71e2a1a4c0c55dfae70a0976be1b84fd06ffa00/oslo.i18n-3.12.0.tar.gz"
    sha256 "6add28cbbe8254838f7f131de0cf0f3761786d57e5fe5716a488260b725f58d3"
  end

  resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/a3/e3/bf2eb833fe96381e4061bfdc0e167cb4b6af7b9acc3fe26833fff30f814d/oslo.serialization-2.15.0.tar.gz"
    sha256 "b79697b4e1f92f2f3312be0363b010dfc898a6c3dfc370a7d3be2787e31b18eb"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/59/71/2d528d347692b55488e124349f0af3f9fc19b57e8ed22814d89a2799ac6a/oslo.utils-3.22.0.tar.gz"
    sha256 "aa72be266fee787541c02baa9ac341ec4b1b01b0d5a097db459aee05b27b12fb"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c6/70/bb32913de251017e266c5114d0a645f262fb10ebc9bf6de894966d124e35/packaging-16.8.tar.gz"
    sha256 "5d50835fdf0a7edf0b55e311b7c887786504efea1177abd7e69329a8e5ea619e"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/64/79/5e8baeedb6baf1d5879efa8cd012f801efc232e56a068550ba00d7e82625/paramiko-2.1.2.tar.gz"
    sha256 "5fae49bed35e2e3d45c4f7b0db2d38b9ca626312d91119b3991d0ecf8125e310"
  end

  resource "passlib" do
    url "https://files.pythonhosted.org/packages/25/4b/6fbfc66aabb3017cd8c3bd97b37f769d7503ead2899bf76e570eb91270de/passlib-1.7.1.tar.gz"
    sha256 "3d948f64138c25633613f303bcc471126eae67c04d5e3f6b7b8ce6242f8653e0"
  end

  resource "positional" do
    url "https://files.pythonhosted.org/packages/83/73/1e2c630d868b73ecdea381ad7b081bc53888c07f1f9829699d277a2859a8/positional-1.1.1.tar.gz"
    sha256 "ef845fa46ee5a11564750aaa09dd7db059aaf39c44c901b37181e5ffa67034b0"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/69/17/eec927b7604d2663fef82204578a0056e11e0fc08d485fdb3b6199d9b590/pyasn1-0.2.3.tar.gz"
    sha256 "738c4ebd88a718e700ee35c8d129acce2286542daa80a82823a7073644f706ad"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz"
    sha256 "0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04"
  end

  resource "pyrax" do
    url "https://files.pythonhosted.org/packages/b8/00/3b456dc8423f6f6a1b9b07c92c487809307a13dee83d22edb524b6f024b4/pyrax-1.9.8.tar.gz"
    sha256 "e9db943447fdf2690046d7f98466fc4743497b74578efe6e400a6edbfd9728f5"
  end

  resource "python-cinderclient" do
    url "https://files.pythonhosted.org/packages/de/14/e4bd3212ac73e415f4e5dc99fc8becffdef54e97fde404e60d10c4838b33/python-cinderclient-1.10.0.tar.gz"
    sha256 "08dde1df6dbbeebd6c338f8a4f375b86907dd5c0014d47a4d738a2ac06d98d61"
  end

  resource "python-consul" do
    url "https://pypi.python.org/packages/82/01/0480ca4f42425cda93e4079b86852474dac4dde0ecacd263b9834f00c258/python-consul-0.7.0.tar.gz"
    sha256 "f5725067586f0119a4eb50bbc8daca75c86791d1c002b97fc173f2347d2dfaa1"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/51/fc/39a3fbde6864942e8bb24c93663734b74e281b984d1b8c4f95d64b0c21f6/python-dateutil-2.6.0.tar.gz"
    sha256 "62a2f8df3d66f878373fd0072eacf4ee52194ba302e00082828e0d263b0418d2"
  end

  resource "python-designateclient" do
    url "https://files.pythonhosted.org/packages/8b/3b/3d4d11240fa440a72a08b9989e1270f0ef3c720d062981beebfb362e702e/python-designateclient-2.4.0.tar.gz"
    sha256 "f362714f246213ef4bf6064399c1b858f4309ea28b75d56ac5f943fb5e6cf7c7"
  end

  resource "python-glanceclient" do
    url "https://files.pythonhosted.org/packages/93/4d/b8ddde77ed12292e376ea10b81b34ba87152b617416d028888de02022717/python-glanceclient-2.5.0.tar.gz"
    sha256 "8c510a089fb4dc8355d5db0de608361888b5e4e0c81e0d153ae1b1366bfb8a08"
  end

  resource "python-heatclient" do
    url "https://files.pythonhosted.org/packages/99/25/7252a5286c2669beda1a16f16abe02bbb31ee9e54de4c36ed79a75b5ae76/python-heatclient-1.7.0.tar.gz"
    sha256 "ccf0912b28d3ee64527849e896f23b133d6e1c9fb89c782c90bb41c537901e7b"
  end

  resource "python-ironicclient" do
    url "https://files.pythonhosted.org/packages/01/da/50842f21929a0a67b65f758365cbb3553272788ed572f73fd1c7e7d24aa4/python-ironicclient-1.9.0.tar.gz"
    sha256 "9fd13ae99cb612c05d6a19ab5d6dbc613d38a1299c5e9e82f1f9b8d33310923c"
  end

  resource "python-keyczar" do
    url "https://files.pythonhosted.org/packages/c8/14/3ffb68671fef927fa5b60f21c43a04a4a007acbe939a26ba08b197fea6b3/python-keyczar-0.716.tar.gz"
    sha256 "f9b614112dc8248af3d03b989da4aeca70e747d32fe7e6fce9512945365e3f83"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/a6/69/03a3121c0eb2017c44a41762e6c9671dc49006598f9502614f26563a158e/python-keystoneclient-3.9.0.tar.gz"
    sha256 "e5ad72c866f094a230e471c2e1149b1b4bb0eaaf2469a2c8fa45b005c1d93b3a"
  end

  resource "python-magnumclient" do
    url "https://files.pythonhosted.org/packages/07/5c/1a64a1d4fdbbb7dad8abc49903a5d9562261345cf8511b8842babddeb1bf/python-magnumclient-2.3.1.tar.gz"
    sha256 "16e2f6923b1ca987bb71f8303b1bab42ed55516cbc9a4845ceebc37c27f3c7f0"
  end

  resource "python-mistralclient" do
    url "https://files.pythonhosted.org/packages/f1/71/9ddde0c1e0a762378ea1bdded6ac3f391833d522e2328526dfb6bbb5cb94/python-mistralclient-3.0.0.tar.gz"
    sha256 "1213894df6ea69e4f6645a8b334c17d0e797c78b30e092331882f2d7a253aa96"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/50/4d/b0b3b3bfd678a0b3e0ce16bbd539dab1e7718f98d53787efbd41083828fb/python-neutronclient-6.0.0.tar.gz"
    sha256 "a30556f8b9541e94f44a9911d9af89037710761755758a2c1598fa92809293a2"
  end

  resource "python-novaclient" do
    url "https://files.pythonhosted.org/packages/b5/b9/249090e22e2c7c0aa640ac7d3cf154bbdd868b586939e1e7de520cff35cd/python-novaclient-7.0.0.tar.gz"
    sha256 "45fbe104e14e860d572e05992b53b72b98e3acb1fcf3f6184b5913e78fe856f0"
  end

  resource "python-openstackclient" do
    url "https://files.pythonhosted.org/packages/28/50/902e4288d5aa87a291c0a771028b8db26e5c967fb1471022ef8e660562f8/python-openstackclient-3.7.0.tar.gz"
    sha256 "3db74830d9033e329f3f24094fa4331ba35d7d8030a30557e00cd67da4378220"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/34/f5/d4702a0715ae9ffe4d66c5d519504b18757c6573aaa10af3790a6bdcb7ce/python-swiftclient-3.2.0.tar.gz"
    sha256 "8761697584ab060520d6094e8394242ee3b94c643ed1f3fe1dbc67df585ab3fa"
  end

  resource "python-troveclient" do
    url "https://files.pythonhosted.org/packages/e9/ca/c20f241772ff96f790bcff04461e104a075a8cf3532dcfe0409f81ed80b2/python-troveclient-2.7.0.tar.gz"
    sha256 "6ad70bd1df9de6115496723fff337a40ff38c5f7d29ba787b4eff2e08e2313ed"
  end

  resource "pywinrm" do
    url "https://files.pythonhosted.org/packages/0b/ca/d0ed22845185fdceb24a1e13811a993e805df9a147d223311061d2e294a7/pywinrm-0.2.2.tar.gz"
    sha256 "3030f700fbd6d06f715d4374c10b3586624bccca003b7075dd281c875705ac1b"
  end

  resource "rackspace-auth-openstack" do
    url "https://files.pythonhosted.org/packages/3c/14/8932bf613797715bf1fe42b00d413025aac9414cf35bacca091a9191155a/rackspace-auth-openstack-1.3.tar.gz"
    sha256 "c4c069eeb1924ea492c50144d8a4f5f1eb0ece945e0c0d60157cabcadff651cd"
  end

  resource "rackspace-novaclient" do
    url "https://files.pythonhosted.org/packages/2a/fc/2c31fea5bc50cd5a849d9fa61343e95af8e2033b35f2650755dcc5365ff1/rackspace-novaclient-2.1.tar.gz"
    sha256 "22fc44f623bae0feb32986ec4630abee904e4c96fba5849386a87e88c450eae7"
  end

  resource "rax_default_network_flags_python_novaclient_ext" do
    url "https://files.pythonhosted.org/packages/36/cf/80aeb67615503898b6b870f17ee42a4e87f1c861798c32665c25d9c0494d/rax_default_network_flags_python_novaclient_ext-0.4.0.tar.gz"
    sha256 "852bf49d90e7a1bc16aa0b25b46a45ba5654069f7321a363c8d94c5496666001"
  end

  resource "rax_scheduled_images_python_novaclient_ext" do
    url "https://files.pythonhosted.org/packages/ef/3c/9cd2453e85979f15316953a37a93d5500d8f70046b501b13766c58cf1310/rax_scheduled_images_python_novaclient_ext-0.3.1.tar.gz"
    sha256 "f170cf97b20bdc8a1784cc0b85b70df5eb9b88c3230dab8e68e1863bf3937cdb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/16/09/37b69de7c924d318e51ece1c4ceb679bf93be9d05973bb30c35babd596e2/requests-2.13.0.tar.gz"
    sha256 "5722cd09762faa01276230270ff16af7acf7c5c45d623868d9ba116f15791ce8"
  end

  resource "requests_ntlm" do
    url "https://files.pythonhosted.org/packages/e8/96/e1a02118867a47f7618df891e5fbecd7e50cafb30b42f1429a2ed5d268ce/requests_ntlm-1.0.0.tar.gz"
    sha256 "53ca319f5538e18c38ac79ec4e0d9680bd8ea7ac05532ed8316879296e426641"
  end

  resource "requestsexceptions" do
    url "https://files.pythonhosted.org/packages/09/0f/b0fa2986054805114fb185b97e270e0b8b0fd4159fa7a3791b7c61a958c9/requestsexceptions-1.1.3.tar.gz"
    sha256 "d678b872f51f76d875e00e6667f4ddbf013b3a99490ae5fe07cf3e4f846e283e"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/17/b6/f2d5df2e369142010fb5d91b12a962643e1a2d3578b04ff22276a5c53238/rfc3986-0.4.1.tar.gz"
    sha256 "5ac85eb132fae7bbd811fa48d11984ae3104be30d44d397a351d004c633a68d2"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/8b/13/517e8ec7c13f0bb002be33fbf53c4e3198c55bb03148827d72064426fe6e/s3transfer-0.1.10.tar.gz"
    sha256 "ba1a9104939b7c0331dc4dd234d79afeed8b66edce77bbeeecd4f56de74a0fc1"
  end

  resource "shade" do
    url "https://files.pythonhosted.org/packages/7e/1f/2409fd66f2574a2dc9daf335b47384e91f1ae52d8c1bb713ec1f840e188d/shade-1.14.1.tar.gz"
    sha256 "7e4346780f87c87b5447da20e7838a61ceb606aa9f2235610e92247b6ab98d0d"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/40/ad/52c1f3a562df3b210e8f165e1aa243a178c454ead65476a39fa3ce1847b6/simplejson-3.10.0.tar.gz"
    sha256 "953be622e88323c6f43fad61ffd05bebe73b9fd9863a46d68b052d2aa7d71ce2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/ac/72/1e890a8a70ee96edc4cc0fff895f99994e5271df62e0b665b2c54e3eec3c/stevedore-1.20.0.tar.gz"
    sha256 "83884f80ed0917346e658bfe51cdb2474512ec6521c18480b41f58b54c4a1f83"
  end

  resource "unicodecsv" do
    url "https://files.pythonhosted.org/packages/6f/a4/691ab63b17505a26096608cc309960b5a6bdf39e4ba1a793d5f9b1a53270/unicodecsv-0.14.1.tar.gz"
    sha256 "018c08037d48649a0412063ff4eda26eaa81eff1546dbffa51fa5293276ff7fc"
  end

  resource "warlock" do
    url "https://files.pythonhosted.org/packages/0f/d4/408b936a3d9214b7685c35936bb59d9254c70ff319ee6a837b9efcf5615e/warlock-1.2.0.tar.gz"
    sha256 "7c0d17891e14cf77e13a598edecc9f4682a5bc8a219dc84c139c5ba02789ef5a"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/a7/2b/0039154583cb0489c8e18313aa91ccd140ada103289c5c5d31d80fd6d186/websocket_client-0.40.0.tar.gz"
    sha256 "40ac14a0c54e14d22809a5c8d553de5a2ae45de3c60105fae53bcb281b3fe6fb"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/00/dd/dc22f8d06ee1f16788131954fc69bc4438f8d0125dd62419a43b86383458/wrapt-1.10.8.tar.gz"
    sha256 "4ea17e814e39883c6cf1bb9b0835d316b2f69f0f0882ffe7dad1ede66ba82c73"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/4a/5e/cd36c16c9eca47162fbbea9aa723b9ab3010f9ae9d4be5c9f6cb2bc147ab/xmltodict-0.10.2.tar.gz"
    sha256 "fc518ccf9adbbb917a2ddcb386be852ae6dd36935e1e8b9a3e760201abfdbf77"
  end

  resource "zabbix-api" do
    url "https://files.pythonhosted.org/packages/39/d9/6f31d35a8721364f1a3ac07dfe6f1bec4839c910a8b1dc14c9206e425d3c/zabbix-api-0.4.tar.gz"
    sha256 "31fab8ca9b12aa5e6fe79b4463cfe62f33ded770ddc933a8d99c4debe934a0de"
  end

  def install
    # https://github.com/Homebrew/homebrew-core/issues/7197
    ENV.prepend "CPPFLAGS", "-I#{MacOS.sdk_path}/usr/include/ffi"

    inreplace "lib/ansible/constants.py" do |s|
      s.gsub! "/usr/share/ansible", pkgshare
      s.gsub! "/etc/ansible", etc/"ansible"
    end

    virtualenv_install_with_resources

    # prettytable 0.7.2 has file permissions 600 for some files.
    # We need to add read permissions in order to be able to use it as a
    # different user than the one installing it.
    # See: https://github.com/Homebrew/homebrew-core/issues/6975
    # Also: https://github.com/Homebrew/brew/pull/1709
    Pathname.glob(libexec/"lib/python*/site-packages/prettytable-0.7.2-py*.egg-info").each do |prettytable_path|
      chmod_R("a+r", prettytable_path)
    end

    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    (testpath/"playbook.yml").write <<-EOF.undent
      ---
      - hosts: all
        gather_facts: False
        tasks:
        - name: ping
          ping:
    EOF
    (testpath/"hosts.ini").write "localhost ansible_connection=local\n"
    system bin/"ansible-playbook", testpath/"playbook.yml", "-i", testpath/"hosts.ini"

    # Ensure requests[security] is activated
    script = "import requests as r; r.get('https://mozilla-modern.badssl.com')"
    system libexec/"bin/python", "-c", script
  end
end
