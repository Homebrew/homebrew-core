class Duplicity < Formula
  desc "Bandwidth-efficient encrypted backup"
  homepage "http://www.nongnu.org/duplicity/"
  url "https://code.launchpad.net/duplicity/0.7-series/0.7.07.1/+download/duplicity-0.7.07.1.tar.gz"
  sha256 "594c6d0e723e56f8a7114d57811c613622d535cafdef4a3643a4d4c89c1904f8"

  bottle do
    sha256 "47cdf42038348b3a3e009ccd8d148a05f41a33769bdbbf82b0a59cbc1ab16ed3" => :el_capitan
    sha256 "76aeaf0e6ce250a6b37eea30e7b8d1b13baf583f525e355d74e9c6ab56f05ab5" => :yosemite
    sha256 "11a6ddfb129a58293ce2a092207ee3f2123b40be19026e7fe56cc5ffc8a3e62d" => :mavericks
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
    url "https://pypi.python.org/packages/13/e8/35d9c7528b3c266a17e888bea1e02eb061e9ab6cdabc7107dfb7da83a1d2/setuptools-21.2.1.tar.gz"
    sha256 "635b899b72c0f3793752227ebb388935053a33a42b283088ba66a90e28145a96"
  end

  # must be installed before cryptography
  resource "cffi" do
    url "https://pypi.python.org/packages/b6/98/11feff87072e2e640fb8320712b781eccdef05d588618915236b32289d5a/cffi-1.6.0.tar.gz"
    sha256 "a7f75c4ef2362c0a0e54657add0a6c509fecbfa3b3807bc0925f5cb1c9f927db"
  end

  resource "Babel" do
    url "https://pypi.python.org/packages/6e/96/ba2a2462ed25ca0e651fb7b66e7080f5315f91425a07ea5b34d7c870c114/Babel-2.3.4.tar.gz"
    sha256 "c535c4403802f6eb38173cd4863e419e2274921a01a8aad8a5b497c131c62875"
  end

  resource "PrettyTable" do
    url "https://pypi.python.org/packages/source/P/PrettyTable/prettytable-0.7.2.tar.bz2"
    sha256 "853c116513625c738dc3ce1aee148b5b5757a86727e67eff6502c7ca59d43c36"
  end

  resource "boto" do
    url "https://pypi.python.org/packages/6f/ce/3447e2136c629ae895611d946879b43c19346c54876dea614316306b17dd/boto-2.40.0.tar.gz"
    sha256 "e12d5fca11fcabfd0acd18f78651e0f0dba60f958a0520ff4e9b73e35cd9928f"
  end

  resource "cryptography" do
    url "https://pypi.python.org/packages/04/da/35f9a1d34dab5d777f65fb87731288f338ab0ae46a525ffdf0405b573dd0/cryptography-1.3.2.tar.gz"
    sha256 "fbaafa8827966dc588ccb00be813d3149fa8de04aec96e418ea0fdd5f0312088"
  end

  resource "debtcollector" do
    url "https://pypi.python.org/packages/19/f2/a2cf6e62bcfa4c3428bdcba09150e5f6835db3797d74689d4427510a7532/debtcollector-1.4.0.tar.gz"
    sha256 "4f0bab4ae1ba0e4f8602fa1a1326fbdcc6cfc6ccc662d780a17a53173e8e59a5"
  end

  resource "dropbox" do
    url "https://pypi.python.org/packages/3d/10/3113dffadc324cfd0852ac21b7a5e828caeb4a3e3fe5b5207ee21e56a52d/dropbox-6.3.0.tar.gz"
    sha256 "feae1542691f7aee61d562a64297f048297764fb83cb52869fb0b49f1eb8f2b3"
  end

  resource "ecdsa" do
    url "https://pypi.python.org/packages/source/e/ecdsa/ecdsa-0.13.tar.gz"
    sha256 "64cf1ee26d1cde3c73c6d7d107f835fed7c6a2904aef9eac223d57ad800c43fa"
  end

  resource "enum34" do
    url "https://pypi.python.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "funcsigs" do
    url "https://pypi.python.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz"
    sha256 "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50"
  end

  resource "futures" do
    url "https://pypi.python.org/packages/55/db/97c1ca37edab586a1ae03d6892b6633d8eaa23b23ac40c7e5bbc55423c78/futures-3.0.5.tar.gz"
    sha256 "0542525145d5afc984c88f914a0c85c77527f65946617edb5274f72406f981df"
  end

  resource "idna" do
    url "https://pypi.python.org/packages/fb/84/8c27516fbaa8147acd2e431086b473c453c428e24e8fb99a1d89ce381851/idna-2.1.tar.gz"
    sha256 "ed36f281aebf3cd0797f163bb165d84c31507cedd15928b095b1675e2d04c676"
  end

  resource "ip_associations_python_novaclient_ext" do
    url "https://pypi.python.org/packages/01/4e/230d9334ea61efb16dda8bef558fd11f8623f6f3ced8a0cf68559435b125/ip_associations_python_novaclient_ext-0.2.tar.gz"
    sha256 "e4576c3ee149bcca7e034507ad9c698cb07dd9fa10f90056756aea0fa59bae37"
  end

  resource "ipaddress" do
    url "https://pypi.python.org/packages/source/i/ipaddress/ipaddress-1.0.16.tar.gz"
    sha256 "5a3182b322a706525c46282ca6f064d27a02cffbd449f9f47416f1dc96aa71b0"
  end

  resource "iso8601" do
    url "https://pypi.python.org/packages/source/i/iso8601/iso8601-0.1.11.tar.gz"
    sha256 "e8fb52f78880ae063336c94eb5b87b181e6a0cc33a6c008511bac9a6e980ef30"
  end

  resource "keyring" do
    url "https://pypi.python.org/packages/b3/57/570bd1ae514dbe2c2764fed003f0118cc2218af3d2576d24fe30e2e959c7/keyring-9.0.tar.gz"
    sha256 "1c1222298da2100128f821c57096c69cb6cec0d22ba3b66c2859ae95ae473799"
  end

  resource "keystoneauth1" do
    url "https://pypi.python.org/packages/bd/1c/567730ded9327a55c51b7b4f4460c8a3e698ea20bc209801fa568d690607/keystoneauth1-2.7.0.tar.gz"
    sha256 "bd3450fc777636189989e4aa78421302ae25bbb663cbee60a19b39fdcddf060d"
  end

  resource "lockfile" do
    url "https://pypi.python.org/packages/source/l/lockfile/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "mega.py" do
    url "https://pypi.python.org/packages/source/m/mega.py/mega.py-0.9.18.tar.gz"
    sha256 "f3e15912ce2e5de18e31e7abef8a819a5546c184aa09586bfdaa42968cc827bf"
  end

  resource "monotonic" do
    url "https://pypi.python.org/packages/3f/3b/7ee821b1314fbf35e6f5d50fce1b853764661a7f59e2da1cb58d33c3fdd9/monotonic-1.1.tar.gz"
    sha256 "255c31929e1a01acac4ca709f95bd6d319d6112db3ba170d1fe945a6befe6942"
  end

  resource "msgpack-python" do
    url "https://pypi.python.org/packages/a3/fb/bcf568236ade99903ef3e3e186e2d9252adbf000b378de596058fb9df847/msgpack-python-0.4.7.tar.gz"
    sha256 "5e001229a54180a02dcdd59db23c9978351af55b1290c27bc549e381f43acd6b"
  end

  resource "ndg-httpsclient" do
    url "https://pypi.python.org/packages/source/n/ndg-httpsclient/ndg_httpsclient-0.4.0.tar.gz"
    sha256 "e8c155fdebd9c4bcb0810b4ed01ae1987554b1ee034dd7532d7b8fdae38a6274"
  end

  resource "netaddr" do
    url "https://pypi.python.org/packages/source/n/netaddr/netaddr-0.7.18.tar.gz"
    sha256 "a1f5c9fcf75ac2579b9995c843dade33009543c04f218ff7c007b3c81695bd19"
  end

  resource "netifaces" do
    url "https://pypi.python.org/packages/source/n/netifaces/netifaces-0.10.4.tar.gz"
    sha256 "9656a169cb83da34d732b0eb72b39373d48774aee009a3d1272b7ea2ce109cde"
  end

  resource "os_diskconfig_python_novaclient_ext" do
    url "https://pypi.python.org/packages/a9/2c/306ef3376bee5fda62c1255da05db2efedc8276be5be98180dbd224d9949/os_diskconfig_python_novaclient_ext-0.1.3.tar.gz"
    sha256 "e7d19233a7b73c70244d2527d162d8176555698e7c621b41f689be496df15e75"
  end

  resource "os_networksv2_python_novaclient_ext" do
    url "https://pypi.python.org/packages/9e/86/6ec4aa97a5e426034f8cc5657186e18303ffb89f37e71375ee0b342b7b78/os_networksv2_python_novaclient_ext-0.26.tar.gz"
    sha256 "613a75216d98d3ce6bb413f717323e622386c24fc9cc66148507539e7dc5bf19"
  end

  resource "os_virtual_interfacesv2_python_novaclient_ext" do
    url "https://pypi.python.org/packages/source/o/os_virtual_interfacesv2_python_novaclient_ext/os_virtual_interfacesv2_python_novaclient_ext-0.19.tar.gz"
    sha256 "5171370e5cea447019cee5da22102b7eca4d4a7fb3f12875e2d7658d98462c0a"
  end

  resource "oslo.config" do
    url "https://pypi.python.org/packages/83/0f/f51e69bee2eb3cd2218ec1d94d1bedfdc26534b743c7d81d4a3ed8ac4c6b/oslo.config-3.10.0.tar.gz"
    sha256 "7c9af6ac0f37640f6ddad05ac07c15cf44698b20e1847a070fc1e04e3863e5cb"
  end

  resource "oslo.i18n" do
    url "https://pypi.python.org/packages/ab/85/660993359fc85a88f8a7d7c1829cea51c6d37bf123626c2e73c8ae65123a/oslo.i18n-3.6.0.tar.gz"
    sha256 "479e93cdd20b3e50f9c614ca4e301211eb0367c13d4bb7871a1392266a80d6c7"
  end

  resource "oslo.serialization" do
    url "https://pypi.python.org/packages/24/a9/17f60c463b663b35e3fe99c7a846a242ec8e336b6e954240c34de5490fc7/oslo.serialization-2.7.0.tar.gz"
    sha256 "27589577627a4af2c7e14422bd18cf28e4f165078edbbdc636b210a5832ccf7d"
  end

  resource "oslo.utils" do
    url "https://pypi.python.org/packages/a9/b0/ad68e5cb0b68ffc26c651e4bb622207e9e91b8ba6c8f60dd4cc20d864b54/oslo.utils-3.11.0.tar.gz"
    sha256 "9f0b478a4dbde95855919e63ebfec2821ae2281cedcda6a37c29d58d53337b1b"
  end

  resource "paramiko" do
    url "https://pypi.python.org/packages/ce/63/cc9baa5d5b568aadaaa7c19190a9b852a0a740b478dd068137c4b0c7cb74/paramiko-2.0.0.tar.gz"
    sha256 "51219ecaf88aa1cea9952b3c4ddcc0c1316f015d23d77edb7aee78a3468ef0e2"
  end

  resource "pbr" do
    url "https://pypi.python.org/packages/c3/2c/63275fab26a0fd8cadafca71a3623e4d0f0ee8ed7124a5bb128853d178a7/pbr-1.10.0.tar.gz"
    sha256 "186428c270309e6fdfe2d5ab0949ab21ae5f7dea831eab96701b86bd666af39c"
  end

  resource "pexpect" do
    url "https://pypi.python.org/packages/56/2b/9c9c113fb88082950067a42cc99e3c61f1df72035f89bb0bdf0a60308ca0/pexpect-4.1.0.tar.gz"
    sha256 "c381c60f1987355b65df8f08a27f428831914c8a81091bd1778ac336fa2f27e7"
  end

  resource "ptyprocess" do
    url "https://pypi.python.org/packages/db/d7/b465161910f3d1cef593c5e002bff67e0384898f597f1a7fdc8db4c02bf6/ptyprocess-0.5.1.tar.gz"
    sha256 "0530ce63a9295bfae7bd06edc02b6aa935619f486f0f1dc0972f516265ee81a6"
  end

  resource "pyOpenSSL" do
    url "https://pypi.python.org/packages/77/f2/bccec75ca4280a9fa762a90a1b8b152a22eac5d9c726d7da1fcbfe0a20e6/pyOpenSSL-16.0.0.tar.gz"
    sha256 "363d10ee43d062285facf4e465f4f5163f9f702f9134f0a5896f134cbb92d17d"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycparser" do
    url "https://pypi.python.org/packages/source/p/pycparser/pycparser-2.14.tar.gz"
    sha256 "7959b4a74abdc27b312fed1c21e6caf9309ce0b29ea86b591fd2e99ecdf27f73"
  end

  resource "pycrypto" do
    url "https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "pyrax" do
    url "https://pypi.python.org/packages/source/p/pyrax/pyrax-1.9.7.tar.gz"
    sha256 "6f2e2bbe9d34541db66f5815ee2016a1366a78a5bf518810d4bd81b71a9bc477"
  end

  resource "python-keystoneclient" do
    url "https://pypi.python.org/packages/45/9e/de957806f2f04f195ebb6dda5e963335c1c2050d4c4ad1069e9695d0b67a/python-keystoneclient-3.1.0.tar.gz"
    sha256 "8ddd7efe422981368c1e97c1358dd8dcadd114813d055e2a3ce3f081590a6624"
  end

  resource "python-novaclient" do
    url "https://pypi.python.org/packages/f6/29/9082e96d8d0a5606b0a7d6a36c5d331ed433c2f9e08bc618cc09e139c6c3/python-novaclient-4.0.0.tar.gz"
    sha256 "13474a2454931d34079d95bd56cdd8d5470e7dbe08b8c7f1a8fdabb948b26488"
  end

  resource "python-swiftclient" do
    url "https://pypi.python.org/packages/74/bd/3f06dd32f9d50705633ee7d45501915c5dd4a2a5919aa6d06c1da5a55ec6/python-swiftclient-3.0.0.tar.gz"
    sha256 "824b8f204c5a7764de51795256e4175fdcd655ae4df85b8ae6e6ea9ec0b41f68"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/f4/7d/7c0c85e9c64a75dde11bc9d3e1adc4e09a42ce7cdb873baffa1598118709/pytz-2016.4.tar.bz2"
    sha256 "ee7c751544e35a7b7fb5e3fb25a49dade37d51e70a93e5107f10575d7102c311"
  end

  resource "rackspace-auth-openstack" do
    url "https://pypi.python.org/packages/source/r/rackspace-auth-openstack/rackspace-auth-openstack-1.3.tar.gz"
    sha256 "c4c069eeb1924ea492c50144d8a4f5f1eb0ece945e0c0d60157cabcadff651cd"
  end

  resource "rackspace-novaclient" do
    url "https://pypi.python.org/packages/d5/51/b8b5648477caaa7e9aeb64260cd6a80612807cb7256d5f6023bba0745f95/rackspace-novaclient-2.0.tar.gz"
    sha256 "f0872ba4b2d82ca11a82b185d237eee492c60413fe10f9fc7cdb24ea14e63f34"
  end

  resource "rax_default_network_flags_python_novaclient_ext" do
    url "https://pypi.python.org/packages/36/cf/80aeb67615503898b6b870f17ee42a4e87f1c861798c32665c25d9c0494d/rax_default_network_flags_python_novaclient_ext-0.4.0.tar.gz"
    sha256 "852bf49d90e7a1bc16aa0b25b46a45ba5654069f7321a363c8d94c5496666001"
  end

  resource "rax_scheduled_images_python_novaclient_ext" do
    url "https://pypi.python.org/packages/source/r/rax_scheduled_images_python_novaclient_ext/rax_scheduled_images_python_novaclient_ext-0.3.1.tar.gz"
    sha256 "f170cf97b20bdc8a1784cc0b85b70df5eb9b88c3230dab8e68e1863bf3937cdb"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/49/6f/183063f01aae1e025cf0130772b55848750a2f3a89bfa11b385b35d7329d/requests-2.10.0.tar.gz"
    sha256 "63f1815788157130cee16a933b2ee184038e975f0017306d723ac326b5525b54"
  end

  resource "simplejson" do
    url "https://pypi.python.org/packages/f0/07/26b519e6ebb03c2a74989f7571e6ae6b82e9d7d81b8de6fcdbfc643c7b58/simplejson-3.8.2.tar.gz"
    sha256 "d58439c548433adcda98e695be53e526ba940a4b9c44fb9a05d92cd495cdd47f"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "stevedore" do
    url "https://pypi.python.org/packages/db/46/2e84e2aedfdb59ac2690c08363e376860bbcc0921d44f8828d7c09167f5c/stevedore-1.14.0.tar.gz"
    sha256 "474381b594451f8999b889476aeaaea193e007c6fdf7b7c5659e6e7e5fb53d8a"
  end

  resource "urllib3" do
    url "https://pypi.python.org/packages/49/26/a7d12ea00cb4b9fa1e13b5980e5a04a1fe7c477eb8f657ce0b757a7a497d/urllib3-1.15.1.tar.gz"
    sha256 "d0a1dc60433f7e9b90b4f085f1d45753174b4594558b29eda0009abe0b82da4c"
  end

  resource "wrapt" do
    url "https://pypi.python.org/packages/00/dd/dc22f8d06ee1f16788131954fc69bc4438f8d0125dd62419a43b86383458/wrapt-1.10.8.tar.gz"
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
