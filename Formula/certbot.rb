class Certbot < Formula
  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://github.com/certbot/certbot/archive/v0.8.0.tar.gz"
  sha256 "b9f2c7b2d2867769abda8464575715899bb1f6993dbcd21f94e2a686f124357d"

  bottle do
    cellar :any
    revision 1
    sha256 "8397f64b68cab24463d603d64b34d1fc5096712f35df989e60dc8debf68dff10" => :el_capitan
    sha256 "489133821741806ae3b0c9111c0d8962624844e29ef559e50f2509d082d5c1cb" => :yosemite
    sha256 "02f1aff026cf84b729da3baa7a30ca22e42d370cbeaf7d5c260664497a90a0ff" => :mavericks
  end

  depends_on "augeas"
  depends_on "dialog"
  depends_on "openssl"
  depends_on :python if MacOS.version <= :snow_leopard

  resource "setuptools" do
    url "https://pypi.python.org/packages/13/e8/35d9c7528b3c266a17e888bea1e02eb061e9ab6cdabc7107dfb7da83a1d2/setuptools-21.2.1.tar.gz"
    sha256 "635b899b72c0f3793752227ebb388935053a33a42b283088ba66a90e28145a96"
  end

  resource "cffi" do
    url "https://pypi.python.org/packages/b6/98/11feff87072e2e640fb8320712b781eccdef05d588618915236b32289d5a/cffi-1.6.0.tar.gz"
    sha256 "a7f75c4ef2362c0a0e54657add0a6c509fecbfa3b3807bc0925f5cb1c9f927db"
  end

  resource "ConfigArgParse" do
    url "https://pypi.python.org/packages/d0/b8/8f7689980caa66fc02671f5837dc761e4c7a47c6ca31b3e38b304cbc3e73/ConfigArgParse-0.10.0.tar.gz"
    sha256 "3b50a83dd58149dfcee98cb6565265d10b53e9c0a2bca7eeef7fb5f5524890a7"
  end

  resource "configobj" do
    url "https://pypi.python.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "cryptography" do
    url "https://pypi.python.org/packages/a9/5b/a383b3a778609fe8177bd51307b5ebeee369b353550675353f46cb99c6f0/cryptography-1.4.tar.gz"
    sha256 "bb149540ed90c4b2171bf694fe6991d6331bc149ae623c8ff419324f4222d128"
  end

  resource "enum34" do
    url "https://pypi.python.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "funcsigs" do
    url "https://pypi.python.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz"
    sha256 "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50"
  end

  resource "idna" do
    url "https://pypi.python.org/packages/fb/84/8c27516fbaa8147acd2e431086b473c453c428e24e8fb99a1d89ce381851/idna-2.1.tar.gz"
    sha256 "ed36f281aebf3cd0797f163bb165d84c31507cedd15928b095b1675e2d04c676"
  end

  resource "ipaddress" do
    url "https://pypi.python.org/packages/cd/c5/bd44885274379121507870d4abfe7ba908326cf7bfd50a48d9d6ae091c0d/ipaddress-1.0.16.tar.gz"
    sha256 "5a3182b322a706525c46282ca6f064d27a02cffbd449f9f47416f1dc96aa71b0"
  end

  resource "mock" do
    url "https://pypi.python.org/packages/0c/53/014354fc93c591ccc4abff12c473ad565a2eb24dcd82490fae33dbf2539f/mock-2.0.0.tar.gz"
    sha256 "b158b6df76edd239b8208d481dc46b6afd45a846b7812ff0ce58971cf5bc8bba"
  end

  resource "ndg-httpsclient" do
    url "https://pypi.python.org/packages/df/a8/e7d70a8dd58c206c57b754fe15e5eb5f302f63fb1bfde5f26a0f5b019557/ndg_httpsclient-0.4.0.tar.gz"
    sha256 "e8c155fdebd9c4bcb0810b4ed01ae1987554b1ee034dd7532d7b8fdae38a6274"
  end

  resource "parsedatetime" do
    url "https://pypi.python.org/packages/8b/20/37822d52be72c99cad913fad0b992d982928cac882efbbc491d4b9d216a9/parsedatetime-2.1.tar.gz"
    sha256 "17c578775520c99131634e09cfca5a05ea9e1bd2a05cd06967ebece10df7af2d"
  end

  resource "pbr" do
    url "https://pypi.python.org/packages/c3/2c/63275fab26a0fd8cadafca71a3623e4d0f0ee8ed7124a5bb128853d178a7/pbr-1.10.0.tar.gz"
    sha256 "186428c270309e6fdfe2d5ab0949ab21ae5f7dea831eab96701b86bd666af39c"
  end

  resource "psutil" do
    url "https://pypi.python.org/packages/a6/bf/5ce23dc9f50de662af3b4bf54812438c298634224924c4e18b7c3b57a2aa/psutil-4.2.0.tar.gz"
    sha256 "544f013a0aea7199e07e3efe5627f5d4165179a04c66050b234cc3be2eca1ace"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/f7/83/377e3dd2e95f9020dbd0dfd3c47aaa7deebe3c68d3857a4e51917146ae8b/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycparser" do
    url "https://pypi.python.org/packages/6d/31/666614af3db0acf377876d48688c5d334b6e493b96d21aa7d332169bee50/pycparser-2.14.tar.gz"
    sha256 "7959b4a74abdc27b312fed1c21e6caf9309ce0b29ea86b591fd2e99ecdf27f73"
  end

  resource "pyOpenSSL" do
    url "https://pypi.python.org/packages/77/f2/bccec75ca4280a9fa762a90a1b8b152a22eac5d9c726d7da1fcbfe0a20e6/pyOpenSSL-16.0.0.tar.gz"
    sha256 "363d10ee43d062285facf4e465f4f5163f9f702f9134f0a5896f134cbb92d17d"
  end

  resource "pyRFC3339" do
    url "https://pypi.python.org/packages/7a/8a/78e04792f04da5f3780058f8cfc35ff9eb74080faffbf321c58e6d34d089/pyRFC3339-1.0.tar.gz"
    sha256 "8dfbc6c458b8daba1c0f3620a8c78008b323a268b27b7359e92a4ae41325f535"
  end

  resource "python2-pythondialog" do
    url "https://pypi.python.org/packages/26/3e/4ce683158e93cb6047911b457b9dc7858e5c1ba91864a097bb353e9fd071/python2-pythondialog-3.4.0.tar.bz2"
    sha256 "8978d355c8db6728eeb9e23b39449b14597f1c76cb06dc72462642ca7cde46a0"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/f4/7d/7c0c85e9c64a75dde11bc9d3e1adc4e09a42ce7cdb873baffa1598118709/pytz-2016.4.tar.bz2"
    sha256 "ee7c751544e35a7b7fb5e3fb25a49dade37d51e70a93e5107f10575d7102c311"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/49/6f/183063f01aae1e025cf0130772b55848750a2f3a89bfa11b385b35d7329d/requests-2.10.0.tar.gz"
    sha256 "63f1815788157130cee16a933b2ee184038e975f0017306d723ac326b5525b54"
  end

  resource "six" do
    url "https://pypi.python.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "zope.component" do
    url "https://pypi.python.org/packages/4c/c4/3f77127c876f49af478e8ea4dc223cda17730bb273c0d1606a4114c64008/zope.component-4.2.2.tar.gz"
    sha256 "282c112b55dd8e3c869a3571f86767c150ab1284a9ace2bdec226c592acaf81a"
  end

  resource "zope.event" do
    url "https://pypi.python.org/packages/cd/a5/4927363244aaa7fd8a696d32005ea8214c4811550d35edea27797ebbd4fd/zope.event-4.2.0.tar.gz"
    sha256 "ce11004217863a4827ea1a67a31730bddab9073832bdb3b9be85869259118758"
  end

  resource "zope.interface" do
    url "https://pypi.python.org/packages/9d/81/2509ca3c6f59080123c1a8a97125eb48414022618cec0e64eb1313727bfe/zope.interface-4.1.3.tar.gz"
    sha256 "2e221a9eec7ccc58889a278ea13dcfed5ef939d80b07819a9a8b3cb1c681484f"
  end

  # Required because augeas formula doesn't ship these.
  resource "python-augeas" do
    url "https://pypi.python.org/packages/41/e6/4b6740cb3e31b82252099994cea751c648b846aa7874343c31d68c2215be/python-augeas-0.5.0.tar.gz"
    sha256 "67d59d66cdba8d624e0389b87b2a83a176f21f16a87553b50f5703b23f29bac2"
  end

  # Required for the nginx module.
  resource "pyparsing" do
    url "https://pypi.python.org/packages/ae/0c/b6ce7eea7ccf020ae68db1119bacaa07ad91fedaefaf8f3265e8dd156813/pyparsing-2.1.4.tar.gz"
    sha256 "a9234dea79b50d49b92a994132cd1c84e873f3936db94977a66f0a4159b1797c"
  end

  # https://github.com/certbot/certbot/pull/3118
  # Safe to remove on next stable release.
  patch do
    url "https://github.com/certbot/certbot/commit/45e47f6d.patch"
    sha256 "5aa52ed90e6bc401856d553e233911181fc4aca28bbb4a6966392102797d33c9"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # Namespace packages and .pth files aren't processed from PYTHONPATH.
    touch libexec/"vendor/lib/python2.7/site-packages/zope/__init__.py"
    touch libexec/"vendor/lib/python2.7/site-packages/ndg/__init__.py"

    cd "acme" do
      system "python", *Language::Python.setup_install_args(libexec)
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    cd "certbot-apache" do
      system "python", *Language::Python.setup_install_args(libexec)
    end

    cd "certbot-nginx" do
      system "python", *Language::Python.setup_install_args(libexec)
    end

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    pkgshare.install "examples"

    # Keep the old name around temporarily for compatibility
    # so that people's scripts don't suddenly bork.
    bin.install_symlink bin/"certbot" => "letsencrypt"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/certbot --version 2>&1")
  end
end
