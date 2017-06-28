class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://github.com/certbot/certbot/archive/v0.15.0.tar.gz"
  sha256 "87d306b1c013b472b8f548b38ccc476c125816435bb3b99e932fed09ac777296"
  head "https://github.com/certbot/certbot.git"

  bottle do
    cellar :any
    sha256 "7d953c0c0771829b47eaa147a1205a53ffebe1c34f01b305790984b83c399fe7" => :sierra
    sha256 "d3bfd83cf86ace7b92b34d095f2c975c9e9ff92867641b6eea9b294fa300bd1f" => :el_capitan
    sha256 "7a7ac97905846051b03899a5de00d54e3519f5e6c7787fccc4f49f526c6ce507" => :yosemite
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
    url "https://files.pythonhosted.org/packages/dd/0e/1e3b58c861d40a9ca2d7ea4ccf47271d4456ae4294c5998ad817bd1b4396/certifi-2017.4.17.tar.gz"
    sha256 "f7527ebf7461582ce95f7a9e03dd141ce810d40590834f4ec20cddd54234c10a"
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
    url "https://files.pythonhosted.org/packages/18/2e/28a7d361a568b1a6c86946674e8ac35a609573c3a3d12bb20f6aaf1c39bf/pbr-3.0.1.tar.gz"
    sha256 "d7e8917458094002b9a2e0030ba60ba4c834c456071f2d0c1ccb5265992ada91"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/9f/32/80fe4fddeb731b7766cd09fe0b2032a91b43dae655e216792af2a6ae3190/pyOpenSSL-17.0.0.tar.gz"
    sha256 "48abfe9d2bb8eb8d8947c8452b0223b7b1be2383b332f3b4f248fe59ef0bafdd"
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
    url "https://files.pythonhosted.org/packages/27/c7/a45641c83c6e28f4922ba6af3d4ae4d79b41932c2f3d77fed9e0bf878149/requests-2.17.3.tar.gz"
    sha256 "8d29f97ed1541709b57caddb77bb20592411d7ca10ec4f03275f49ee8456e225"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/96/d9/40e4e515d3e17ed0adbbde1078e8518f8c4e3628496b56eb8f026a02b9e4/urllib3-1.21.1.tar.gz"
    sha256 "b14486978518ca0901a76ba973d7821047409d7f726f22156b24e83fd71382a5"
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
    url "https://files.pythonhosted.org/packages/90/1c/942298a4f5ef7db8c885ae687c59d397127f5a8cff7a473b0d7475a2c6e7/zope.interface-4.4.1.tar.gz"
    sha256 "350e3615d70a96678c3170eb5c96d4f72b8e7738861afbf030967d52c05722fe"
  end

  # Required because augeas formula doesn't ship these.
  # Capped at 0.5.0: Requirement.parse('python-augeas<=0.5.0'))
  # https://github.com/certbot/certbot/commit/1c51ae25887f2dc31
  resource "python-augeas" do
    url "https://files.pythonhosted.org/packages/41/e6/4b6740cb3e31b82252099994cea751c648b846aa7874343c31d68c2215be/python-augeas-0.5.0.tar.gz"
    sha256 "67d59d66cdba8d624e0389b87b2a83a176f21f16a87553b50f5703b23f29bac2"
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
    assert_match "running as non-root", shell_output("#{bin}/certbot 2>&1", 1)
  end
end
