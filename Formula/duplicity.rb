class Duplicity < Formula
  desc "Bandwidth-efficient encrypted backup"
  homepage "http://www.nongnu.org/duplicity/"
  url "https://code.launchpad.net/duplicity/0.7-series/0.7.08/+download/duplicity-0.7.08.tar.gz"
  sha256 "d6d0b25ac2a39daa32f269a9bf6b3ea6d9202dcab388fa91bd645868defb0f17"

  bottle do
    cellar :any
    sha256 "a76f176445ef3b46a8b69fe09786b1e9a47a6c6f650ce5df91b20b477835a681" => :el_capitan
    sha256 "9a5f7182d0b205b238adca32861291f363172b3f555d525875cf863c4d54fced" => :yosemite
    sha256 "e5b6310c71ddbccf52957ef9aa4c6467a3e2e25b6278eb7834b74a09c3a55601" => :mavericks
  end

  option :universal

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "librsync"
  depends_on "openssl"
  depends_on "par2" => :optional
  depends_on :gpg => :run

  # Generated with homebrew-pypi-poet from
  # for i in boto pyrax dropbox mega.py paramiko pexpect pycrypto
  # lockfile python-swiftclient python-keystoneclient; do poet -r $i >>
  # resources; done
  # Additional dependencies of requests[security] should also be installed.

  # MacOS versions prior to Yosemite need the latest setuptools in order to compile dependencies
  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/7a/a8/5877fa2cec00f7678618fb465878fd9356858f0894b60c6960364b5cf816/setuptools-24.0.1.tar.gz"
    sha256 "5d3ae6f1cc9f1d3e1fe420c5daaeb8d79059fcb12624f4897d5ed8a9348ee1d2"
  end

  # must be installed before cryptography
  resource "cffi" do
    url "https://files.pythonhosted.org/packages/83/3c/00b553fd05ae32f27b3637f705c413c4ce71290aa9b4c4764df694e906d9/cffi-1.7.0.tar.gz"
    sha256 "6ed5dd6afd8361f34819c68aaebf9e8fc12b5a5893f91f50c9e50c8886bb60df"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/6e/96/ba2a2462ed25ca0e651fb7b66e7080f5315f91425a07ea5b34d7c870c114/Babel-2.3.4.tar.gz"
    sha256 "c535c4403802f6eb38173cd4863e419e2274921a01a8aad8a5b497c131c62875"
  end

  resource "PrettyTable" do
    url "https://files.pythonhosted.org/packages/e0/a1/36203205f77ccf98f3c6cf17cf068c972e6458d7e58509ca66da949ca347/prettytable-0.7.2.tar.gz"
    sha256 "2d5460dc9db74a32bcc8f9f67de68b2c4f4d2f01fa3bd518764c69156d9cacd9"
  end

  resource "boto" do
    url "https://files.pythonhosted.org/packages/e9/74/7ef3431c37fc1f51f98cc04491cdb112dcd9f474c83b275e1a1450c24527/boto-2.41.0.tar.gz"
    sha256 "c638acdecb0a2383b517c15ac2a6ccf15a2f806aee923cc4448a59b9b73b52e0"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/a9/5b/a383b3a778609fe8177bd51307b5ebeee369b353550675353f46cb99c6f0/cryptography-1.4.tar.gz"
    sha256 "bb149540ed90c4b2171bf694fe6991d6331bc149ae623c8ff419324f4222d128"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/17/ba/e594686fbe0c5c1e15cc78600f363604eb4dfb80c4f62685b53d9b490943/debtcollector-1.5.0.tar.gz"
    sha256 "8eab1fba356cc465c4ab347119e217b045929713e2c543290f7c0571ede417dc"
  end

  resource "dropbox" do
    url "https://files.pythonhosted.org/packages/ae/1c/6555463c30d2f4f44436fa4a9bd20d2330e29ba7582a4eae69811231e31e/dropbox-6.5.0.tar.gz"
    sha256 "c1a5a95c3d5f7dae392c1fb228a11d1d952756cb4ab0a5afcb1f9b283af1407c"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/f9/e5/99ebb176e47f150ac115ffeda5fedb6a3dbb3c00c74a59fd84ddf12f5857/ecdsa-0.13.tar.gz"
    sha256 "64cf1ee26d1cde3c73c6d7d107f835fed7c6a2904aef9eac223d57ad800c43fa"
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
    url "https://files.pythonhosted.org/packages/ff/58/f3393b41852c1a1b12a9fcdfb468f638d0808c3520f23cc7c13f8f6c14e0/keyring-9.3.tar.gz"
    sha256 "5c6cc42902c2135e4cb674b9108fc7a9ddb9550466dc332640ca89034984f7c2"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/c4/f2/3aec9d8e69c95723dafc920f76a348e308fae6b98adcc3a1823ac63d39c8/keystoneauth1-2.8.0.tar.gz"
    sha256 "7f92251600b86c368d2201317c60b82e37760e1399c223005710b1ee8a52b03f"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "mega.py" do
    url "https://files.pythonhosted.org/packages/13/d2/cbbc5d21f2281fb59e27085c98b33bc93616be314b6fda5ad5d1955136ac/mega.py-0.9.18.tar.gz"
    sha256 "f3e15912ce2e5de18e31e7abef8a819a5546c184aa09586bfdaa42968cc827bf"
  end

  resource "monotonic" do
    url "https://files.pythonhosted.org/packages/3f/3b/7ee821b1314fbf35e6f5d50fce1b853764661a7f59e2da1cb58d33c3fdd9/monotonic-1.1.tar.gz"
    sha256 "255c31929e1a01acac4ca709f95bd6d319d6112db3ba170d1fe945a6befe6942"
  end

  resource "msgpack-python" do
    url "https://files.pythonhosted.org/packages/a3/fb/bcf568236ade99903ef3e3e186e2d9252adbf000b378de596058fb9df847/msgpack-python-0.4.7.tar.gz"
    sha256 "5e001229a54180a02dcdd59db23c9978351af55b1290c27bc549e381f43acd6b"
  end

  resource "ndg-httpsclient" do
    url "https://files.pythonhosted.org/packages/08/92/6318c6c71566778782065736d73c62e621a7a190f9bb472a23857d97f823/ndg_httpsclient-0.4.1.tar.gz"
    sha256 "133931ab2cf7118f8fc7ccc29e289ba8f644dd90f84632fa0e6eb16df4ba1891"
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
    url "https://files.pythonhosted.org/packages/e3/2b/f4da5fc091bebda229caece59e81867ab439858ece54b59c1da95501396f/oslo.config-3.12.0.tar.gz"
    sha256 "4d0425939db7f6f418023a94b3c24f07729b2add3692d75fcaca7301e6417942"
  end

  resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/92/f7/1a986fdeb2bdb46d1c0650db3fb790e594a3171ad40567c9cae5825a5b06/oslo.i18n-3.7.0.tar.gz"
    sha256 "f534a69013891b64320f5a9d444a4ae0e28d388b6b97f63ee5c7532292454287"
  end

  resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/f3/d2/08ad522a749bd25cc288c805187d07187b43ab54ea71ef09049090d7932a/oslo.serialization-2.10.0.tar.gz"
    sha256 "5f8ec814d55fe15a24527b6328ceef6101d43ca974a5c18781d7fa92ce0082f6"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/19/99/11101ee5172d71749a0e3c419a682281d5e1a3f3001b8e03aeb0dc4f817c/oslo.utils-3.14.0.tar.gz"
    sha256 "24b0692b8f6e144a21da5950c7e1c64f65cb484008f2a374f166526803eeef81"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/b5/dd/cc2b8eb360e3db2e65ad5adf8cb4fd57493184e3ce056fd7625e9c387bfa/paramiko-2.0.1.tar.gz"
    sha256 "261afe9246c2494e50bbeab55e50934348e91d1189803123459e0c81cda70fac"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/c3/2c/63275fab26a0fd8cadafca71a3623e4d0f0ee8ed7124a5bb128853d178a7/pbr-1.10.0.tar.gz"
    sha256 "186428c270309e6fdfe2d5ab0949ab21ae5f7dea831eab96701b86bd666af39c"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/56/2b/9c9c113fb88082950067a42cc99e3c61f1df72035f89bb0bdf0a60308ca0/pexpect-4.1.0.tar.gz"
    sha256 "c381c60f1987355b65df8f08a27f428831914c8a81091bd1778ac336fa2f27e7"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/db/d7/b465161910f3d1cef593c5e002bff67e0384898f597f1a7fdc8db4c02bf6/ptyprocess-0.5.1.tar.gz"
    sha256 "0530ce63a9295bfae7bd06edc02b6aa935619f486f0f1dc0972f516265ee81a6"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/77/f2/bccec75ca4280a9fa762a90a1b8b152a22eac5d9c726d7da1fcbfe0a20e6/pyOpenSSL-16.0.0.tar.gz"
    sha256 "363d10ee43d062285facf4e465f4f5163f9f702f9134f0a5896f134cbb92d17d"
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

  resource "pyrax" do
    url "https://files.pythonhosted.org/packages/23/3f/4e043bc3c0893931554edcd671147c48869eb99d77f983839f8b79667df1/pyrax-1.9.7.tar.gz"
    sha256 "6f2e2bbe9d34541db66f5815ee2016a1366a78a5bf518810d4bd81b71a9bc477"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/45/9e/de957806f2f04f195ebb6dda5e963335c1c2050d4c4ad1069e9695d0b67a/python-keystoneclient-3.1.0.tar.gz"
    sha256 "8ddd7efe422981368c1e97c1358dd8dcadd114813d055e2a3ce3f081590a6624"
  end

  resource "python-novaclient" do
    url "https://files.pythonhosted.org/packages/47/9a/a8c34efd5df49109ff5ee3e090a82b5c5a000b730a8fe7fa9615440c54ba/python-novaclient-4.1.0.tar.gz"
    sha256 "8ca47ffd454c07c96f486ca8ea5c886329cc42d25c5996e61ca26949824593d9"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/74/bd/3f06dd32f9d50705633ee7d45501915c5dd4a2a5919aa6d06c1da5a55ec6/python-swiftclient-3.0.0.tar.gz"
    sha256 "824b8f204c5a7764de51795256e4175fdcd655ae4df85b8ae6e6ea9ec0b41f68"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f4/7d/7c0c85e9c64a75dde11bc9d3e1adc4e09a42ce7cdb873baffa1598118709/pytz-2016.4.tar.bz2"
    sha256 "ee7c751544e35a7b7fb5e3fb25a49dade37d51e70a93e5107f10575d7102c311"
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
    url "https://files.pythonhosted.org/packages/source/r/rax_scheduled_images_python_novaclient_ext/rax_scheduled_images_python_novaclient_ext-0.3.1.tar.gz"
    sha256 "f170cf97b20bdc8a1784cc0b85b70df5eb9b88c3230dab8e68e1863bf3937cdb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/49/6f/183063f01aae1e025cf0130772b55848750a2f3a89bfa11b385b35d7329d/requests-2.10.0.tar.gz"
    sha256 "63f1815788157130cee16a933b2ee184038e975f0017306d723ac326b5525b54"
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
    url "https://files.pythonhosted.org/packages/ae/e7/aef03849b8b838779880fa997465f24e0c7d4762ccfe4199752d282e8993/stevedore-1.15.0.tar.gz"
    sha256 "b048b7976754ad55d7cbc7407b17cbfd945dbb4c5ecc333d3c2142d506fc90e1"
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
    ENV["PYTHONPATH"] = libexec/"lib/python2.7/site-packages"

    ENV.universal_binary if build.universal?

    vendor_site_packages = libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", vendor_site_packages
    resources.each do |r|
      r.stage { system "python", *Language::Python.setup_install_args(libexec/"vendor") }
    end

    # ndg is a namespace package
    touch vendor_site_packages/"ndg/__init__.py"

    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    man1.install Dir[libexec/"share/man/man1/*"]

    # OSX doesn't provide a /usr/bin/python2. Upstream has been notified but
    # cannot fix the issue. See:
    #   https://github.com/Homebrew/homebrew/pull/34165#discussion_r22342214
    inreplace "#{libexec}/bin/duplicity", "python2", "python"
  end

  test do
    system bin/"duplicity", "--dry-run", "--no-encryption", testpath, "file:///#{testpath}/test"
  end
end
