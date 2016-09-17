class Duplicity < Formula
  include Language::Python::Virtualenv

  desc "Bandwidth-efficient encrypted backup"
  homepage "http://www.nongnu.org/duplicity/"
  url "https://code.launchpad.net/duplicity/0.7-series/0.7.09/+download/duplicity-0.7.09.tar.gz"
  sha256 "431e7060ba1b028605f82aee2202543506998c386c7008cd9dfe975e9128a8b3"

  bottle do
    cellar :any
    rebuild 1
    sha256 "543b52cc13ebd28fad5560e46f3d0ce12e1bb2db43d27857baed16191630d3fd" => :sierra
    sha256 "fa3ef85ed6a17105f30da37003eeff182ffd770960b4cf06eeb8b3ae3f02406c" => :el_capitan
    sha256 "5ca3cda7ceb6a1b49b867a26e0d5efc1521c47688e795cba77ba89b0de0cbec8" => :yosemite
    sha256 "b9b46b5e99f1c96746e412e683841a2f75550c0ec939b95156364cd814fd4d2b" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "librsync"
  depends_on "openssl"
  depends_on "par2" => :optional
  depends_on :gpg => :run

  # Generated with homebrew-pypi-poet from
  # for i in boto pyrax dropbox mega.py paramiko pexpect pycrypto
  # lockfile python-swiftclient python-keystoneclient; do poet -r $i >>
  # resources; done
  # Additional dependencies of requests[security] should also be installed:
  #   ndg-httpsclient, pyOpenSSL

  # must be installed early
  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f7/c7/08e54702c74baf9d8f92d0bc331ecabf6d66a56f6d36370f0a672fc6a535/pytz-2016.6.1.tar.bz2"
    sha256 "b5aff44126cf828537581e534cc94299b223b945a2bb3b5434d37bf8c7f3a10c"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/6e/96/ba2a2462ed25ca0e651fb7b66e7080f5315f91425a07ea5b34d7c870c114/Babel-2.3.4.tar.gz"
    sha256 "c535c4403802f6eb38173cd4863e419e2274921a01a8aad8a5b497c131c62875"
  end

  resource "PrettyTable" do
    url "https://files.pythonhosted.org/packages/ef/30/4b0746848746ed5941f052479e7c23d2b56d174b82f4fd34a25e389831f5/prettytable-0.7.2.tar.bz2"
    sha256 "853c116513625c738dc3ce1aee148b5b5757a86727e67eff6502c7ca59d43c36"
  end

  resource "boto" do
    url "https://files.pythonhosted.org/packages/c4/bb/28324652bedb4ea9ca77253b84567d1347b54df6231b51822eaaa296e6e0/boto-2.42.0.tar.gz"
    sha256 "dcf140d4ce535bb8f5266d1750c16def4d50f6c46eff27fab38b55d0d74d5ac7"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/83/3c/00b553fd05ae32f27b3637f705c413c4ce71290aa9b4c4764df694e906d9/cffi-1.7.0.tar.gz"
    sha256 "6ed5dd6afd8361f34819c68aaebf9e8fc12b5a5893f91f50c9e50c8886bb60df"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/a9/5b/a383b3a778609fe8177bd51307b5ebeee369b353550675353f46cb99c6f0/cryptography-1.4.tar.gz"
    sha256 "bb149540ed90c4b2171bf694fe6991d6331bc149ae623c8ff419324f4222d128"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/ae/ba/87697a1381386d353e7922a29926d02daeac2f186994848f15e40aeffdc7/debtcollector-1.8.0.tar.gz"
    sha256 "66cd8a08a585f6836896fc980389f1e57bbe36eb140494e546a439b29234d83a"
  end

  resource "dropbox" do
    url "https://files.pythonhosted.org/packages/8b/45/7078fe204fcb672d960e34fcdbb7c121c6309977dd7e44a67dfd79c82d4c/dropbox-6.7.0.tar.gz"
    sha256 "2fda43352ab7c2c946d2e32c3f114aeacbeabac989208398115bf6870e658444"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "funcsigs" do
    url "https://files.pythonhosted.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz"
    sha256 "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50"
  end

  resource "futures" do
    url "https://files.pythonhosted.org/packages/55/db/97c1ca37edab586a1ae03d6892b6633d8eaa23b23ac40c7e5bbc55423c78/futures-3.0.5.tar.gz"
    sha256 "0542525145d5afc984c88f914a0c85c77527f65946617edb5274f72406f981df"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/fb/84/8c27516fbaa8147acd2e431086b473c453c428e24e8fb99a1d89ce381851/idna-2.1.tar.gz"
    sha256 "ed36f281aebf3cd0797f163bb165d84c31507cedd15928b095b1675e2d04c676"
  end

  resource "ip_associations_python_novaclient_ext" do
    url "https://files.pythonhosted.org/packages/01/4e/230d9334ea61efb16dda8bef558fd11f8623f6f3ced8a0cf68559435b125/ip_associations_python_novaclient_ext-0.2.tar.gz"
    sha256 "e4576c3ee149bcca7e034507ad9c698cb07dd9fa10f90056756aea0fa59bae37"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/cd/c5/bd44885274379121507870d4abfe7ba908326cf7bfd50a48d9d6ae091c0d/ipaddress-1.0.16.tar.gz"
    sha256 "5a3182b322a706525c46282ca6f064d27a02cffbd449f9f47416f1dc96aa71b0"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/c0/75/c9209ee4d1b5975eb8c2cba4428bde6b61bd55664a98290dd015cdb18e98/iso8601-0.1.11.tar.gz"
    sha256 "e8fb52f78880ae063336c94eb5b87b181e6a0cc33a6c008511bac9a6e980ef30"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/7e/84/65816c2936cf7191bcb5b3e3dc4fb87def6f8a38be25b3a78131bbb08594/keyring-9.3.1.tar.gz"
    sha256 "3be74f6568fcac1350b837d7e46bd3525e2e9fe2b78b3a3a87dc3b29f24a0c00"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/77/eb/f892ef2ccf03a748282049229ef9cc27e86a6421cf34d72f627636d6d723/keystoneauth1-2.11.1.tar.gz"
    sha256 "137221347f26fb8dd23a0ddd8764525b9d26618ae1ebb8e95767a3f228c3ae94"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "mega.py" do
    url "https://files.pythonhosted.org/packages/13/d2/cbbc5d21f2281fb59e27085c98b33bc93616be314b6fda5ad5d1955136ac/mega.py-0.9.18.tar.gz"
    sha256 "f3e15912ce2e5de18e31e7abef8a819a5546c184aa09586bfdaa42968cc827bf"
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

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/7c/ec/104f193e985e0aa813ffb4ba5da78d6ae3200165bf583d522ac2dc40aab2/netaddr-0.7.18.tar.gz"
    sha256 "a1f5c9fcf75ac2579b9995c843dade33009543c04f218ff7c007b3c81695bd19"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/18/fa/dd13d4910aea339c0bb87d2b3838d8fd923c11869b1f6e741dbd0ff3bc00/netifaces-0.10.4.tar.gz"
    sha256 "9656a169cb83da34d732b0eb72b39373d48774aee009a3d1272b7ea2ce109cde"
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

  resource "oslo.config" do
    url "https://files.pythonhosted.org/packages/1d/0e/693ec02d5b0e1a88cfdc62a361d585dde1c695f4ded53fb80a0a2f6175db/oslo.config-3.15.0.tar.gz"
    sha256 "ade31314150c151999c4dbb11e24d87a9404f4a10dd8ac11959a47fd6f541669"
  end

  resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/73/c7/96640411381fedd31e8541c594c8e54421a71144ab145b902ce9b14aac2c/oslo.i18n-3.8.0.tar.gz"
    sha256 "09d5f92317eda9f026f58c6d403c552780ec0beccc02e1b25b70e45b9e7175d7"
  end

  resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/af/63/cdfd2dde6380fa8b22612b00d3ee4a143c8aeb9c2fed07f7ea4bdb05fad2/oslo.serialization-2.13.0.tar.gz"
    sha256 "7bfdb1c10bc24c4887407a2ac46708b1fd16e9bc2ceb6bb3805696e8cebf6566"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/cd/87/97ba9a3bce5f03eba41e0eee9345f2c1fe533121e2880a35493854650511/oslo.utils-3.16.0.tar.gz"
    sha256 "109e018da9d95caba79c94935257d2335e5a77e65ebbff218cb9756e746630f1"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/6b/4e/971b8c917456a2ec9666311f7e695493002a64022397cd668150b5efd2a8/paramiko-2.0.2.tar.gz"
    sha256 "411bf90fa22b078a923ff19ef9772c1115a0953702db93549a2848acefd141dc"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/c3/2c/63275fab26a0fd8cadafca71a3623e4d0f0ee8ed7124a5bb128853d178a7/pbr-1.10.0.tar.gz"
    sha256 "186428c270309e6fdfe2d5ab0949ab21ae5f7dea831eab96701b86bd666af39c"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/b3/7b/7b3659b9d7059d6d21e23b2464c5c84bffd4a34450cbf0ed19c9a8a4a52f/pexpect-4.2.0.tar.gz"
    sha256 "bf6816b8cc8d301a499e7adf338828b39bc7548eb64dbed4dd410ed93d95f853"
  end

  resource "positional" do
    url "https://files.pythonhosted.org/packages/83/73/1e2c630d868b73ecdea381ad7b081bc53888c07f1f9829699d277a2859a8/positional-1.1.1.tar.gz"
    sha256 "ef845fa46ee5a11564750aaa09dd7db059aaf39c44c901b37181e5ffa67034b0"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/db/d7/b465161910f3d1cef593c5e002bff67e0384898f597f1a7fdc8db4c02bf6/ptyprocess-0.5.1.tar.gz"
    sha256 "0530ce63a9295bfae7bd06edc02b6aa935619f486f0f1dc0972f516265ee81a6"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/f7/83/377e3dd2e95f9020dbd0dfd3c47aaa7deebe3c68d3857a4e51917146ae8b/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/6d/31/666614af3db0acf377876d48688c5d334b6e493b96d21aa7d332169bee50/pycparser-2.14.tar.gz"
    sha256 "7959b4a74abdc27b312fed1c21e6caf9309ce0b29ea86b591fd2e99ecdf27f73"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/65/25/1bb68622ca70abc145ac9c9bcd0e837fccd2889d79cee641aa8604d18a11/pyparsing-2.1.8.tar.gz"
    sha256 "03a4869b9f3493807ee1f1cb405e6d576a1a2ca4d81a982677c0c1ad6177c56b"
  end

  resource "pyrax" do
    url "https://files.pythonhosted.org/packages/23/3f/4e043bc3c0893931554edcd671147c48869eb99d77f983839f8b79667df1/pyrax-1.9.7.tar.gz"
    sha256 "6f2e2bbe9d34541db66f5815ee2016a1366a78a5bf518810d4bd81b71a9bc477"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/68/b8/9304887319ea3f38b6921586413d213f85990ea0d9f6c0bdfee254ccc8a9/python-keystoneclient-3.4.0.tar.gz"
    sha256 "b63111c5102a8a70561d8fcb3848da0261a146098e7667175e595cadd4a12dd6"
  end

  resource "python-novaclient" do
    url "https://files.pythonhosted.org/packages/ac/10/aa4d81bb5ceac249b7facf86d021b7008a138b447ca9cbf09557fca61046/python-novaclient-2.27.0.tar.gz"
    sha256 "d1279d5c2857cf8c56cb953639b36225bc1fec7fa30ee632940823506a7638ef"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/74/bd/3f06dd32f9d50705633ee7d45501915c5dd4a2a5919aa6d06c1da5a55ec6/python-swiftclient-3.0.0.tar.gz"
    sha256 "824b8f204c5a7764de51795256e4175fdcd655ae4df85b8ae6e6ea9ec0b41f68"
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
    url "https://files.pythonhosted.org/packages/8d/66/649f861f980c0a168dd4cccc4dd0ed8fa5bd6c1bed3bea9a286434632771/requests-2.11.0.tar.gz"
    sha256 "b2ff053e93ef11ea08b0e596a1618487c4e4c5f1006d7a1706e3671c57dea385"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/97/87/87da602f3c8357c94d98f7961e85da4f7fe284753be9115286be309c2afc/rfc3986-0.3.1.tar.gz"
    sha256 "b94638db542896ccf89dc62785ec26dbcbd6a97d337f64e02615b164b974f2e5"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/f0/07/26b519e6ebb03c2a74989f7571e6ae6b82e9d7d81b8de6fcdbfc643c7b58/simplejson-3.8.2.tar.gz"
    sha256 "d58439c548433adcda98e695be53e526ba940a4b9c44fb9a05d92cd495cdd47f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/60/2a/9e109b387cba156cf97871cd3cdb34a00ce65429d5d4ba16678490f6d2ab/stevedore-1.17.0.tar.gz"
    sha256 "99fb1b2cc3c372850e839f2cae8cb9b493114a0678c20e99b69f75db0cf0a3fb"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/19/2f/b1090ace275335a9c0dde9a4623b109b7960a2b5370ae59d1eb1539afd8a/typing-3.5.2.2.tar.gz"
    sha256 "2bce34292653af712963c877f3085250a336738e64f99048d1b8509bebc4772f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/3b/f0/e763169124e3f5db0926bc3dbfcd580a105f9ca44cf5d8e6c7a803c9f6b5/urllib3-1.16.tar.gz"
    sha256 "63d479478ddfc83bbc11577dc16d47835c5179ac13e550118ca143b62c4bf9ab"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/00/dd/dc22f8d06ee1f16788131954fc69bc4438f8d0125dd62419a43b86383458/wrapt-1.10.8.tar.gz"
    sha256 "4ea17e814e39883c6cf1bb9b0835d316b2f69f0f0882ffe7dad1ede66ba82c73"
  end

  def install
    virtualenv_install_with_resources
    inreplace Dir[bin/"*"], %r{^#!/usr/bin/env python.*$},
                            "#!#{libexec}/bin/python"
    man1.install Dir[libexec/"share/man/man1/*"]
  end

  test do
    Gpg.create_test_key(testpath)
    (testpath/"test/hello.txt").write "Hello!"
    (testpath/"command.sh").write <<-EOS.undent
      #!/usr/bin/expect -f
      set timeout -1
      spawn #{bin}/duplicity #{testpath} "file://test"
      expect -exact "Local and Remote metadata are synchronized, no sync needed."
      expect -exact "Last full backup date: none"
      expect -exact "GnuPG passphrase:"
      send -- "brew\n"
      expect -exact "Retype passphrase to confirm:"
      send -- "brew\n"
      expect -exact "No signatures found, switching to full backup."
      expect eof
    EOS
    chmod 0755, testpath/"command.sh"
    system "./command.sh"
    assert_match "duplicity-full-signatures", Dir["test/*"].to_s
  end
end
