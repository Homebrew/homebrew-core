class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://files.pythonhosted.org/packages/8d/21/0cb5341289df917d5286aa4f79adeb844815b2ffa112067b2ab748bf107d/certbot-2.7.4.tar.gz"
  sha256 "173778fef4e2e3014f60be02d4798dff7ea32790277b90b3c7249c5d46d17c75"
  license "Apache-2.0"
  head "https://github.com/certbot/certbot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2b89ceebbf1e79f34a8671ae04f178a5507359dbfdc8e8d06f7654949992ec6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d318e97eac3ff53d4f83773262dc9abdeb7051e426a5bf33608bd0ebd306172d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76e73426880949941d281fce925c10b888a5a29cd9e1db43e0fffb1cbe267b6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "be65afc73a1bf221546467354b525df3659611a3712e19af878340692384f133"
    sha256 cellar: :any_skip_relocation, ventura:        "5806a5900e807131685fc66198d3598281f122e02c31bcf277a2299dc17cc226"
    sha256 cellar: :any_skip_relocation, monterey:       "06350e2c000cfdfa6b77c62449cf233a35cb13b64a0e862558c0b842be217831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1e467306a97b942931086517fc0f7cd267659ce6f942ea82aa4ba9a7ff66d41"
  end

  depends_on "augeas"
  depends_on "cffi"
  depends_on "dialog"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-pyparsing"
  depends_on "python-pytz"
  depends_on "python@3.12"
  depends_on "six"

  uses_from_macos "libffi"

  resource "acme" do
    url "https://files.pythonhosted.org/packages/97/f7/9a3513b27b2196340d06137d7734e66c95af560ff3330928790bdcf9554a/acme-2.7.4.tar.gz"
    sha256 "b9d27f49156b111e207be4aae6fc468c273572c99461f05fd65d679e338322f6"
  end

  resource "certbot-apache" do
    url "https://files.pythonhosted.org/packages/58/c7/707e07fa70dcae1fab28798b3798b5f257c300735c384b96e094cfe79d5f/certbot-apache-2.7.4.tar.gz"
    sha256 "6ff21ae1ca61d9f5546de6e6c7d155d4e24f50b5894a2f1323547694cbb64422"
  end

  resource "certbot-nginx" do
    url "https://files.pythonhosted.org/packages/6e/4b/43eb74491bd27427da8d765050d1a4b0b29495a79aba1f380c6c53c9f27c/certbot-nginx-2.7.4.tar.gz"
    sha256 "bfaf0daa6128de2386c1af91e2ec6fa46095d67a7787b8884f075f67f1cc9b54"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/4b/89/eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398/distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "josepy" do
    url "https://files.pythonhosted.org/packages/2c/cd/684c45107851da4507854ef4b16fcdce448e02668f0e7c359d0558cbfbeb/josepy-1.14.0.tar.gz"
    sha256 "308b3bf9ce825ad4d4bba76372cf19b5dc1c2ce96a9d298f9642975e64bd13dd"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/bf/a0/e667c3c43b65a188cc3041fa00c50655315b93be45182b2c94d185a2610e/pyOpenSSL-23.3.0.tar.gz"
    sha256 "6b2cba5cc46e822750ec3e5a81ee12819850b11303630d575e98108a079c2b12"
  end

  resource "pyrfc3339" do
    url "https://files.pythonhosted.org/packages/00/52/75ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7/pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  resource "python-augeas" do
    url "https://files.pythonhosted.org/packages/af/cc/5064a3c25721cd863e6982b87f10fdd91d8bcc62b6f7f36f5231f20d6376/python-augeas-1.1.0.tar.gz"
    sha256 "5194a49e86b40ffc57055f73d833f87e39dce6fce934683e7d0d5bbb8eff3b8c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    if build.head?
      head_packages = %w[acme certbot certbot-apache certbot-nginx]
      venv = virtualenv_create(libexec, "python3.12")
      venv.pip_install resources.reject { |r| head_packages.include? r.name }
      venv.pip_install_and_link head_packages.map { |pkg| buildpath/pkg }
      pkgshare.install buildpath/"certbot/examples"
    else
      virtualenv_install_with_resources
      pkgshare.install buildpath/"examples"
    end
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/certbot --version 2>&1")
    # This throws a bad exit code but we can check it actually is failing
    # for the right reasons by asserting. --version never fails even if
    # resources are missing or outdated/too new/etc.
    assert_match "Either run as root", shell_output("#{bin}/certbot 2>&1", 1)
  end
end
