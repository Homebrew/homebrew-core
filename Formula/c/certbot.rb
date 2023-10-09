class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://files.pythonhosted.org/packages/0a/22/72343a33d64b73f75e5be06c4ec0c9f168552640cc2e934ea8d87bbcd39e/certbot-2.7.0.tar.gz"
  sha256 "274329918656db82fb314e2ecb12a9b276a1df820e28e36e8ecca8c3a0563c1c"
  license "Apache-2.0"
  head "https://github.com/certbot/certbot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6559e838615c8e460887731e3ed77cce8ff3f07328fdb02a21fa0bc3315a3a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4180cbbc56f20c659fc8e199fe46e3c3b52b2378b7de54597474567aab1c46d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28dfc3bc16226506b5f74233f8f3cbf2b2e053a1cd83e428854bf4706f27c042"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c911049187d1903a94ef3e7df7861d3ee7f8d9ccdb3bc80f98794e12a73a717"
    sha256 cellar: :any_skip_relocation, ventura:        "bd8003c921f4402fb8ebb9b6f17a11295a9108494004185a2e70290f5553dc66"
    sha256 cellar: :any_skip_relocation, monterey:       "37192637d2494c5e1f88fd8844ef87b2b40523a8f28ea528882efc46a07bd67d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ea105e82f802c5ed0ef055a049dbf92fced3efacbf658609035e0a2a7d64f1c"
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
    url "https://files.pythonhosted.org/packages/53/fe/d25df0985f17d48fbe5ae2aa7281152693bf6f70727a0f5031d2656fd616/acme-2.7.0.tar.gz"
    sha256 "7aeaf0886322ca5569bc532828086ff2a7fc5b66a29a0a5d3270363d448af228"
  end

  resource "certbot-apache" do
    url "https://files.pythonhosted.org/packages/8d/29/68a11f444e63ae7b0041fdba89b27672aa0ec8d124c452e240b30abb4dce/certbot-apache-2.7.0.tar.gz"
    sha256 "de34a8d20aa44b539ef2e6b82dc5beea98e06e808da3bd22081d0c24e2bc42d5"
  end

  resource "certbot-nginx" do
    url "https://files.pythonhosted.org/packages/69/73/3b68c3629b98539ad3be706bf2a305091640323322c09a7e49b86e0b2d05/certbot-nginx-2.7.0.tar.gz"
    sha256 "137896f84988708e0cda6a422d1d803109dacbf24afc6c83d972957426cb04bd"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "ConfigArgParse" do
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

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/be/df/75a6525d8988a89aed2393347e9db27a56cb38a3e864314fac223e905aef/pyOpenSSL-23.2.0.tar.gz"
    sha256 "276f931f55a452e7dea69c7173e984eb2a4407ce413c918aa34b55f82f9b8bac"
  end

  resource "pyRFC3339" do
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
