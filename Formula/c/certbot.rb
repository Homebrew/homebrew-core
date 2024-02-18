class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://files.pythonhosted.org/packages/f3/f8/16e8d798f5ad191be67f7369c83ab9e51da9c35e4bcc310073c37dc4debe/certbot-2.9.0.tar.gz"
  sha256 "3eafe967523704dac854df36bcca5e5fa949cdd9df835651b0f3712b1cd90c05"
  license "Apache-2.0"
  head "https://github.com/certbot/certbot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67f6e19c6f2c2ba539b1d22abbaf6479c7683adf7fa79e7f5c180c1183e71c02"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a42cf5de7de2075631ca6ea34da5c9455d25af005ef112fe334095e0596c05fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "572ebaf8856c768c5d10d43cd8828633f366a3c08c6e15d013863e3eb1a7d251"
    sha256 cellar: :any_skip_relocation, sonoma:         "525ca7a0fe99389c1f418630e983d719cc002f5ea282e0fc159b68cf1c41279f"
    sha256 cellar: :any_skip_relocation, ventura:        "87d3b76a9ecf4eeeee18d727e127b669b75652c7ac525478e8c5fca4e82a99f7"
    sha256 cellar: :any_skip_relocation, monterey:       "6a8fc99e1180ceda0cd05fc0505f6b2587e43a434e4783681aa91f8b96ce089d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79dc4a5dbe07379fd6c4c9ded464df087b040b992ee596227b8a96946f519025"
  end

  depends_on "python-setuptools" => :build
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
    url "https://files.pythonhosted.org/packages/d2/b4/a4a923e7dd24733b522fdd23a7ce5ba6105b5f41acacc8890adedc3ebb4c/acme-2.9.0.tar.gz"
    sha256 "f7fb2aa4f7ccd132f4ece307d9de6d30b94b2a08c302531f4f43f85ed18673ea"
  end

  resource "certbot-apache" do
    url "https://files.pythonhosted.org/packages/10/6c/0ed888988b0464ed8299a022c7db4f920884a2c9788091f88f5e0a3d0541/certbot-apache-2.9.0.tar.gz"
    sha256 "cf1ece833a599dae903c2203d12ea0d1692399dfa4a965428056b3ae6fe50170"
  end

  resource "certbot-nginx" do
    url "https://files.pythonhosted.org/packages/bc/4b/6d3910df30820f075ffe63b93b597e6ccf2b692ef8f0ecb5419c78149d08/certbot-nginx-2.9.0.tar.gz"
    sha256 "b8200a4c9ca8165feb70c07d8eb8907f904bc9c742a6f8f71e780bc16b72eb57"
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
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
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
    url "https://files.pythonhosted.org/packages/eb/81/022190e5d21344f6110064f6f52bf0c3b9da86e9e5a64fc4a884856a577d/pyOpenSSL-24.0.0.tar.gz"
    sha256 "6aa33039a93fffa4563e655b61d11364d01264be8ccb49906101e02a334530bf"
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
    url "https://files.pythonhosted.org/packages/e2/cc/abf6746cc90bc52df4ba730f301b89b3b844d6dc133cb89a01cfe2511eb9/urllib3-2.2.0.tar.gz"
    sha256 "051d961ad0c62a94e50ecf1af379c3aba230c66c710493493560c0c223c49f20"
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
