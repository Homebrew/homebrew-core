class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://github.com/certbot/certbot/archive/v0.10.2.tar.gz"
  sha256 "da6c357e831926cfb57ec49c1fb3b9a5bbce0202fb7fb60487ee52944c712341"
  head "https://github.com/certbot/certbot.git"

  bottle do
    sha256 "846e684a0f5992eec9ad5028847c7f9cbe31d0c2118f53d168bfafe8df5c91ab" => :sierra
    sha256 "41c5ede49190ed70bf191701f89d78c8be435fe49ef92cca674798803c1f0e65" => :el_capitan
    sha256 "bb706af6999402c4ec972b0b35d475a96a33c8b4a9b8be738084a7e7c7057ac0" => :yosemite
  end

  depends_on "augeas"
  depends_on "dialog"
  depends_on "openssl@1.1"
  depends_on :python

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/bd/66/0a7f48a0f3fb1d3a4072bceb5bbd78b1a6de4d801fb7135578e7c7b1f563/appdirs-1.4.0.tar.gz"
    sha256 "8fc245efb4387a4e3e0ac8ebcc704582df7d72ff6a42a53f5600bbb18fdaadc5"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a1/32/e3d6c3a8b5461b903651dd6ce958ed03c093d2e00128e3f33ea69f1d7965/cffi-1.9.1.tar.gz"
    sha256 "563e0bd53fda03c151573217b3a49b3abad8813de9dd0632e10090f6190fdaf8"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/45/87/a815edcdc867de0964e5f1efef6db956bbb6fe77dbe3f273f2aeab39cbe8/ConfigArgParse-0.11.0.tar.gz"
    sha256 "6c8ae823f6844b055f2a3aa9b51f568ed3bd7e5be9fba63abcaf4bdd38a0ac89"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/82/f7/d6dfd7595910a20a563a83a762bf79a253c4df71759c3b228accb3d7e5e4/cryptography-1.7.1.tar.gz"
    sha256 "953fef7d40a49a795f4d955c5ce4338abcec5dea822ed0414ed30348303fdb4c"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "funcsigs" do
    url "https://files.pythonhosted.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz"
    sha256 "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz"
    sha256 "e39ced1ab767b5936646cedba8bcce582398233d6a627067d4c6a454c90cfedb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/94/fe/efb1cb6f505e1a560b3d080ae6b9fddc11e7c542d694ce4635c49b1ccdcb/idna-2.2.tar.gz"
    sha256 "0ac27740937d86850010e035c6a10a564158a5accddf1aa24df89b0309252426"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/4e/13/774faf38b445d0b3a844b65747175b2e0500164b7c28d78e34987a5bfe06/ipaddress-1.0.18.tar.gz"
    sha256 "5d8534c8e185f2d8a1fda1ef73f2c8f4b23264e8e30063feeb9511d492a413e1"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/0c/53/014354fc93c591ccc4abff12c473ad565a2eb24dcd82490fae33dbf2539f/mock-2.0.0.tar.gz"
    sha256 "b158b6df76edd239b8208d481dc46b6afd45a846b7812ff0ce58971cf5bc8bba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c6/70/bb32913de251017e266c5114d0a645f262fb10ebc9bf6de894966d124e35/packaging-16.8.tar.gz"
    sha256 "5d50835fdf0a7edf0b55e311b7c887786504efea1177abd7e69329a8e5ea619e"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/62/a3/0c546deec0c1ea5e20320daf7719df9419c2bee97f1a11b9feaf0143b0fc/parsedatetime-2.2.tar.gz"
    sha256 "1b1b647812e336f85be84206e4fb1f2df3852e036ac35b18dec809e7ebff1309"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/c3/2c/63275fab26a0fd8cadafca71a3623e4d0f0ee8ed7124a5bb128853d178a7/pbr-1.10.0.tar.gz"
    sha256 "186428c270309e6fdfe2d5ab0949ab21ae5f7dea831eab96701b86bd666af39c"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/f7/83/377e3dd2e95f9020dbd0dfd3c47aaa7deebe3c68d3857a4e51917146ae8b/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/0c/d6/b1fe519846a21614fa4f8233361574eddb223e0bc36b182140d916acfb3b/pyOpenSSL-16.2.0.tar.gz"
    sha256 "7779a3bbb74e79db234af6a08775568c6769b5821faecf6e2f4143edb227516e"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/38/bb/bf325351dd8ab6eb3c3b7c07c3978f38b2103e2ab48d59726916907cd6fb/pyparsing-2.1.10.tar.gz"
    sha256 "811c3e7b0031021137fc83e051795025fcb98674d07eb8fe922ba4de53d39188"
  end

  resource "pyRFC3339" do
    url "https://files.pythonhosted.org/packages/7a/8a/78e04792f04da5f3780058f8cfc35ff9eb74080faffbf321c58e6d34d089/pyRFC3339-1.0.tar.gz"
    sha256 "8dfbc6c458b8daba1c0f3620a8c78008b323a268b27b7359e92a4ae41325f535"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/d0/e1/aca6ef73a7bd322a7fc73fd99631ee3454d4fc67dc2bee463e2adf6bb3d3/pytz-2016.10.tar.bz2"
    sha256 "7016b2c4fa075c564b81c37a252a5fccf60d8964aa31b7f5eae59aeb594ae02b"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/16/09/37b69de7c924d318e51ece1c4ceb679bf93be9d05973bb30c35babd596e2/requests-2.13.0.tar.gz"
    sha256 "5722cd09762faa01276230270ff16af7acf7c5c45d623868d9ba116f15791ce8"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "zope.component" do
    url "https://files.pythonhosted.org/packages/c9/56/501d51f0277af1899d1381e4b9928b5e14675187752622ddc344a756439d/zope.component-4.3.0.tar.gz"
    sha256 "bb4136c7443610f8c2d2d357cad247c3e90bb5e6f0b7a02b0edfb11924ff9bc2"
  end

  resource "zope.event" do
    url "https://files.pythonhosted.org/packages/cd/a5/4927363244aaa7fd8a696d32005ea8214c4811550d35edea27797ebbd4fd/zope.event-4.2.0.tar.gz"
    sha256 "ce11004217863a4827ea1a67a31730bddab9073832bdb3b9be85869259118758"
  end

  resource "zope.interface" do
    url "https://files.pythonhosted.org/packages/44/af/cea1e18bc0d3be0e0824762d3236f0e61088eeed75287e7b854d65ec9916/zope.interface-4.3.3.tar.gz"
    sha256 "8780ef68ca8c3fe1abb30c058a59015129d6e04a6b02c2e56b9c7de6078dfa88"
  end

  # Required because augeas formula doesn't ship these.
  resource "python-augeas" do
    url "https://files.pythonhosted.org/packages/41/e6/4b6740cb3e31b82252099994cea751c648b846aa7874343c31d68c2215be/python-augeas-0.5.0.tar.gz"
    sha256 "67d59d66cdba8d624e0389b87b2a83a176f21f16a87553b50f5703b23f29bac2"
  end

  # Required for the nginx module.
  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/38/bb/bf325351dd8ab6eb3c3b7c07c3978f38b2103e2ab48d59726916907cd6fb/pyparsing-2.1.10.tar.gz"
    sha256 "811c3e7b0031021137fc83e051795025fcb98674d07eb8fe922ba4de53d39188"
  end

  def install
    venv = virtualenv_create(libexec)

    resource("cryptography").stage do
      if MacOS.version < :sierra
        # Fixes .../cryptography/hazmat/bindings/_openssl.so: Symbol not found: _getentropy
        # Reported 20 Dec 2016 https://github.com/pyca/cryptography/issues/3332
        inreplace "src/_cffi_src/openssl/src/osrandom_engine.h",
          "#elif defined(BSD) && defined(SYS_getentropy)",
          "#elif defined(BSD) && defined(SYS_getentropy) && 0"
      end
      venv.pip_install Pathname.pwd
    end

    res = resources.map(&:name).to_set - ["cryptography"]

    res.each do |r|
      venv.pip_install resource(r)
    end

    venv.pip_install_and_link buildpath

    # Shipped with certbot, not external resources.
    %w[acme certbot-apache certbot-nginx].each do |r|
      venv.pip_install buildpath/r
    end

    pkgshare.install "examples"
    # Keep the old name around temporarily for compatibility
    # so that people's scripts don't suddenly bork.
    bin.install_symlink bin/"certbot" => "letsencrypt"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/certbot --version 2>&1")
  end
end
