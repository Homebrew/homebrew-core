class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://files.pythonhosted.org/packages/51/91/36333487ecdd801cc641bbf07f3e798f1cf715078a6fb64f3b46f715ab80/certbot-3.1.0.tar.gz"
  sha256 "0ac0bacc74af1802eeb13f4008f0cb2eaccb0432a07224f5c8554ba6f135c2df"
  license "Apache-2.0"
  head "https://github.com/certbot/certbot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f87b2827ef410983a48376f512b31b109f53ced2499b85e630d5384e15349152"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f87b2827ef410983a48376f512b31b109f53ced2499b85e630d5384e15349152"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f87b2827ef410983a48376f512b31b109f53ced2499b85e630d5384e15349152"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd8ce1457f1e4f3b875c43b92a61a762cda3f3a2fcd7087c83d37b965ea19742"
    sha256 cellar: :any_skip_relocation, ventura:       "bd8ce1457f1e4f3b875c43b92a61a762cda3f3a2fcd7087c83d37b965ea19742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f87b2827ef410983a48376f512b31b109f53ced2499b85e630d5384e15349152"
  end

  depends_on "augeas"
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "dialog"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "acme" do
    url "https://files.pythonhosted.org/packages/56/66/cf2dc843eb075caedc5407190ba41e837fabd5d8536380c68601e40ea325/acme-3.1.0.tar.gz"
    sha256 "39ae0032834585e5c893d7865a5867af01598b5ebef688edb54e9f11cb89ccd9"
  end

  resource "certbot-apache" do
    url "https://files.pythonhosted.org/packages/f6/59/0b250f85d1b46d10a9e882bc87cdaf49cca209bc01bdd803fbb5189dba83/certbot_apache-3.1.0.tar.gz"
    sha256 "9e006bc67ae45419473f69c50592991b874c43ee2ff515bab5bacd85e99492b0"
  end

  resource "certbot-nginx" do
    url "https://files.pythonhosted.org/packages/e5/ae/ca27399c43eeb4eb04dac939a1087475c972b9a9c3b107158b31d9704d2c/certbot_nginx-3.1.0.tar.gz"
    sha256 "dc90d102533cc0ea8bc377c003eecb96be8a6c7cae30082749bcc00a7c97b515"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
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
    url "https://files.pythonhosted.org/packages/c1/d4/1067b82c4fc674d6f6e9e8d26b3dff978da46d351ca3bac171544693e085/pyopenssl-24.3.0.tar.gz"
    sha256 "49f7a019577d834746bc55c5fce6ecbcec0f2b4ec5ce1cf43a9a173b8138bb36"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/8b/1a/3544f4f299a47911c2ab3710f534e52fea62a633c96806995da5d25be4b2/pyparsing-3.2.1.tar.gz"
    sha256 "61980854fd66de3a90028d679a954d5f2623e83144b5afe5ee86f43d762e5f0a"
  end

  resource "pyrfc3339" do
    url "https://files.pythonhosted.org/packages/f0/d2/6587e8ec3951cbd97c56333d11e0f8a3a4cb64c0d6ed101882b7b31c431f/pyrfc3339-2.0.1.tar.gz"
    sha256 "e47843379ea35c1296c3b6c67a948a1a490ae0584edfcbdea0eaffb5dd29960b"
  end

  resource "python-augeas" do
    url "https://files.pythonhosted.org/packages/af/cc/5064a3c25721cd863e6982b87f10fdd91d8bcc62b6f7f36f5231f20d6376/python-augeas-1.1.0.tar.gz"
    sha256 "5194a49e86b40ffc57055f73d833f87e39dce6fce934683e7d0d5bbb8eff3b8c"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/3a/31/3c70bf7603cc2dca0f19bdc53b4537a797747a58875b552c8c413d963a3f/pytz-2024.2.tar.gz"
    sha256 "2aa355083c50a0f93fa581709deac0c9ad65cca8a9e9beac660adcbd493c798a"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  def install
    if build.head?
      head_packages = %w[acme certbot certbot-apache certbot-nginx]
      venv = virtualenv_create(libexec, "python3.13")
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
