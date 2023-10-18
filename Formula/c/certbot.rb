class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://files.pythonhosted.org/packages/fb/da/1124407c79ae88b6eec56dcd057f08c1ebc6fbcd4c98d046ea24ccfbd2c5/certbot-2.7.1.tar.gz"
  sha256 "22604d6ab8e5b665ea1aa201d65840298f5e4f98a100d399f52cf30c6f5c7408"
  license "Apache-2.0"
  head "https://github.com/certbot/certbot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6856c82a05a823f71e47fa9ab656aed2ef288a58a161b93b8aa884375ca3bedb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42a576f963a01aaadc3a1d18fab6aabbfa0e18ce482aec91ff1ae80f16ddb38e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1eab356a7051017833828fe2281c8cb72f816aa799207ebc5369d45ed328aa2"
    sha256 cellar: :any_skip_relocation, sonoma:         "78af5ea7a7ee23446dfc15b136a966243da42077b3f2c076b4abd8943f2d6c71"
    sha256 cellar: :any_skip_relocation, ventura:        "4442c03ce8fb8beb4f57b52b93ff513521d1e8c533f6313c01bda9817384f025"
    sha256 cellar: :any_skip_relocation, monterey:       "c789917e514c5fed32109576f029320fd5a6a4d6c6ed6045d1bd2640542fbdf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec16e4305c09995451131286c0d347c56702cf07dacf8e93242fabe1146be2c1"
  end

  depends_on "augeas"
  depends_on "cffi"
  depends_on "dialog"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-pyparsing"
  depends_on "python-pytz"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"

  resource "acme" do
    url "https://files.pythonhosted.org/packages/fe/df/c99284c9e2be0a579831ee6bc2e18e70ff44b5deceafd9279a7dbe235e48/acme-2.7.1.tar.gz"
    sha256 "47aea91999434cb01a3530c7c76866f387fdb818097808704d6cfa98dbe4e966"
  end

  resource "certbot-apache" do
    url "https://files.pythonhosted.org/packages/5c/50/b122617bf1e2a7f66dc326008771ca628b0259dab3ae79203148de5f8233/certbot-apache-2.7.1.tar.gz"
    sha256 "6be6ba72458863eefa06070e74ef58f2447bda533b3a1c2c9b4f02c5666b2716"
  end

  resource "certbot-nginx" do
    url "https://files.pythonhosted.org/packages/1a/08/0c131b8c1a5cfdd6de7b4c10af7e90a70a4edef8c87c061dd2b73c78810a/certbot-nginx-2.7.1.tar.gz"
    sha256 "2125039d4672705f5e132db912abc3ad3bea22831a2c7042c4c61fbbb455c205"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
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
    url "https://files.pythonhosted.org/packages/f4/be/5c1d9decbd5e9cf97dccd40d13c5657bef936d87da03c9d7aeb67c1b5126/josepy-1.13.0.tar.gz"
    sha256 "8931daf38f8a4c85274a0e8b7cb25addfd8d1f28f9fb8fbed053dd51aec75dc9"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/be/df/75a6525d8988a89aed2393347e9db27a56cb38a3e864314fac223e905aef/pyOpenSSL-23.2.0.tar.gz"
    sha256 "276f931f55a452e7dea69c7173e984eb2a4407ce413c918aa34b55f82f9b8bac"
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
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  def install
    if build.head?
      head_packages = %w[acme certbot certbot-apache certbot-nginx]
      venv = virtualenv_create(libexec, "python3.11")
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
