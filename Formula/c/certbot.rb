class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://files.pythonhosted.org/packages/d7/7e/5155b8a7837fb433acee0bfd87e950bab96ab7e02ece21cc9c7d3d5effc4/certbot-2.10.0.tar.gz"
  sha256 "892aa57d4db74af174aec5e4bb7f7537b200de2545a066c049d03a53215f0e4e"
  license "Apache-2.0"
  revision 1
  head "https://github.com/certbot/certbot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e567441173a622a11704ec3afc0e63039dc9f8c5ad3e1455f5656c9b3095333f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e567441173a622a11704ec3afc0e63039dc9f8c5ad3e1455f5656c9b3095333f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e567441173a622a11704ec3afc0e63039dc9f8c5ad3e1455f5656c9b3095333f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5bce25566dd52ede60b99d258973989aa78950736b2c5061f338acbb1297073"
    sha256 cellar: :any_skip_relocation, ventura:        "b5bce25566dd52ede60b99d258973989aa78950736b2c5061f338acbb1297073"
    sha256 cellar: :any_skip_relocation, monterey:       "b5bce25566dd52ede60b99d258973989aa78950736b2c5061f338acbb1297073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ba70c042dd0b3b79a9add8db10699528aa6b851e23e013cc23967ff1252df3d"
  end

  depends_on "python-setuptools" => :build
  depends_on "augeas"
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "dialog"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "acme" do
    url "https://files.pythonhosted.org/packages/f1/eb/7731d7e3c099adaaa814ecf12bd1f6741605b8d80e9b33b69a51849cf280/acme-2.10.0.tar.gz"
    sha256 "de110d6550f22094c920ad6022f4b329380a6bd8f58dd671135c6226c3a470cc"
  end

  resource "certbot-apache" do
    url "https://files.pythonhosted.org/packages/0a/df/9841fa889b4209708004930c9e2c96082ee55ac8bff728b555a3a716ea4e/certbot-apache-2.10.0.tar.gz"
    sha256 "c7a46ff67eac2834a3e3b975e7a1d1bc7a7be889f51c2cdc87825abd5ccc825a"
  end

  resource "certbot-nginx" do
    url "https://files.pythonhosted.org/packages/98/90/a7416a2602889819948a457169c5faa43606a77d25e9e12070cf1a016bba/certbot-nginx-2.10.0.tar.gz"
    sha256 "9add7e8b7005fe6d8405cb74fd868d4b3689a572957a9112d654a5ac1e7f4d91"
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
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
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
    url "https://files.pythonhosted.org/packages/91/a8/cbeec652549e30103b9e6147ad433405fdd18807ac2d54e6dbb73184d8a1/pyOpenSSL-24.1.0.tar.gz"
    sha256 "cabed4bfaa5df9f1a16c0ef64a0cb65318b5cd077a7eda7d6970131ca2f41a6f"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/46/3a/31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842/pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "pyrfc3339" do
    url "https://files.pythonhosted.org/packages/00/52/75ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7/pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  resource "python-augeas" do
    url "https://files.pythonhosted.org/packages/af/cc/5064a3c25721cd863e6982b87f10fdd91d8bcc62b6f7f36f5231f20d6376/python-augeas-1.1.0.tar.gz"
    sha256 "5194a49e86b40ffc57055f73d833f87e39dce6fce934683e7d0d5bbb8eff3b8c"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/90/26/9f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738/pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4d/5b/dc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83d/setuptools-69.2.0.tar.gz"
    sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
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
