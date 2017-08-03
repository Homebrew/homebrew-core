class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://github.com/certbot/certbot/archive/v0.17.0.tar.gz"
  sha256 "ed4334dce166bf38ecc7218449efda3798d62c7e2934a71702c0dc3d78eccdd1"
  head "https://github.com/certbot/certbot.git"

  bottle do
    cellar :any
    sha256 "e2e45f5be43b90c6da98e7b2baeedfadcf2d268bd4ab4989a92e26e18c42fb9b" => :sierra
    sha256 "6c3b25331680343d80bd233b319f7c4057b6e24683fab5a8c2e5c548995e3ffc" => :el_capitan
    sha256 "43401e00f1f2a74ed162aa833f55cac782eaa9451c51b64f383fca20be589034" => :yosemite
  end

  depends_on "augeas"
  depends_on "dialog"
  depends_on "openssl@1.1"
  depends_on :python

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/67/14/5d66588868c4304f804ebaff9397255f6ec5559e46724c2496e0f26e68d6/asn1crypto-0.22.0.tar.gz"
    sha256 "cbbadd640d3165ab24b06ef25d1dca09a3441611ac15f6a6b452474fdf0aed1a"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/20/d0/3f7a84b0c5b89e94abbd073a5f00c7176089f526edb056686751d5064cbd/certifi-2017.7.27.1.tar.gz"
    sha256 "40523d2efb60523e113b44602298f0960e900388cf3bb6043f645cf57ea9e3f5"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/5b/b9/790f8eafcdab455bcd3bd908161f802c9ce5adbf702a83aa7712fcc345b7/cffi-1.10.0.tar.gz"
    sha256 "b3b02911eb1f6ada203b0763ba924234629b51586f72a21faacc638269f4ced5"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/17/8d/4a41f11b0971017c7001f118be8003da8f7b96b010c66cd792b76658d1e1/ConfigArgParse-0.12.0.tar.gz"
    sha256 "28cd7d67669651f2a4518367838c49539457504584a139709b2b8f6c208ef339"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/2a/0c/31bd69469e90035381f0197b48bf71032991d9f07a7e444c311b4a23a3df/cryptography-1.9.tar.gz"
    sha256 "5518337022718029e367d982642f3e3523541e098ad671672a90b82474c84882"
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
    url "https://files.pythonhosted.org/packages/d8/82/28a51052215014efc07feac7330ed758702fc0581347098a81699b5281cb/idna-2.5.tar.gz"
    sha256 "3cb5ce08046c4e3a560fc02f138d0ac63e00f8ce5901a56b32ec8b7994082aab"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/4e/13/774faf38b445d0b3a844b65747175b2e0500164b7c28d78e34987a5bfe06/ipaddress-1.0.18.tar.gz"
    sha256 "5d8534c8e185f2d8a1fda1ef73f2c8f4b23264e8e30063feeb9511d492a413e1"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/0c/53/014354fc93c591ccc4abff12c473ad565a2eb24dcd82490fae33dbf2539f/mock-2.0.0.tar.gz"
    sha256 "b158b6df76edd239b8208d481dc46b6afd45a846b7812ff0ce58971cf5bc8bba"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/e3/b3/02385db13f1f25f04ad7895f35e9fe3960a4b9d53112775a6f7d63f264b6/parsedatetime-2.4.tar.gz"
    sha256 "3d817c58fb9570d1eec1dd46fa9448cd644eeed4fb612684b02dfda3a79cb84b"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/d5/d6/f2bf137d71e4f213b575faa9eb426a8775732432edb67588a8ee836ecb80/pbr-3.1.1.tar.gz"
    sha256 "05f61c71aaefc02d8e37c0a3eeb9815ff526ea28b3b76324769e6158d7f95be1"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/b0/9e/7088f6165c40c46416aff434eb806c1d64ad6ec6dbc201f5ad4d0484704e/pyOpenSSL-17.2.0.tar.gz"
    sha256 "5d617ce36b07c51f330aa63b83bf7f25c40a0e95958876d54d1982f8c91b4834"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz"
    sha256 "0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04"
  end

  resource "pyRFC3339" do
    url "https://files.pythonhosted.org/packages/7a/8a/78e04792f04da5f3780058f8cfc35ff9eb74080faffbf321c58e6d34d089/pyRFC3339-1.0.tar.gz"
    sha256 "8dfbc6c458b8daba1c0f3620a8c78008b323a268b27b7359e92a4ae41325f535"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/a4/09/c47e57fc9c7062b4e83b075d418800d322caa87ec0ac21e6308bd3a2d519/pytz-2017.2.zip"
    sha256 "f5c056e8f62d45ba8215e5cb8f50dfccb198b4b9fbea8500674f3443e4689589"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c3/38/d95ddb6cc8558930600be088e174a2152261a1e0708a18bf91b5b8c90b22/requests-2.18.3.tar.gz"
    sha256 "fb68a7baef4965c12d9cd67c0f5a46e6e28be3d8c7b6910c758fbcc99880b518"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  resource "zope.component" do
    url "https://files.pythonhosted.org/packages/5c/1e/5cb27047f5817aa5e413efcea8ca701265644623dd9dddb4ca92ef150138/zope.component-4.4.0.tar.gz"
    sha256 "2a53e184026d63ef4073dd3722b34f104fbc702329b61182bf65e1152ef5038a"
  end

  resource "zope.event" do
    url "https://files.pythonhosted.org/packages/9e/d0/54ba59f19a0635f6591b74be259cf6fbf67e73f4edda27b5cd0cf4d26efa/zope.event-4.3.0.tar.gz"
    sha256 "e0ecea24247a837c71c106b0341a7a997e3653da820d21ef6c08b32548f733e7"
  end

  resource "zope.interface" do
    url "https://files.pythonhosted.org/packages/c5/88/93373971f893714f0dc15e09696ec4886ee8b4e561ce5ae45612c2c516c4/zope.interface-4.4.2.tar.gz"
    sha256 "4e59e427200201f69ef82956ddf9e527891becf5b7cde8ec3ce39e1d0e262eb0"
  end

  resource "python-augeas" do
    url "https://files.pythonhosted.org/packages/b3/f7/f2bc09ec2cb46543f368e89a8b17e083d923bff24806ef5cbb08bac532ce/python-augeas-1.0.2.tar.gz"
    sha256 "efb370aeb2dd3965e6a168241726ace1c2afc5efebf76e0ac5c7914729cf2603"
  end

  def install
    venv = virtualenv_install_with_resources

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
    # This throws a bad exit code but we can check it actually is failing
    # for the right reasons by asserting. --version never fails even if
    # resources are missing or outdated/too new/etc.
    assert_match "Either run as root", shell_output("#{bin}/certbot 2>&1", 1)
  end
end
