class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://files.pythonhosted.org/packages/c0/e9/5e637d66a9fe6d93c4c075d539a3b949244a9b795b3f07a0998951af9b00/certbot-2.11.0.tar.gz"
  sha256 "257ae1cb0a534373ca50dd807c9ae96f27660e41379c45afb9b50cab0e6a7a97"
  license "Apache-2.0"
  revision 2
  head "https://github.com/certbot/certbot.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d43dbc5f1e628eb2ba3894a310efc6654ea4413d9a64d55e74dfbb4caccf657"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d43dbc5f1e628eb2ba3894a310efc6654ea4413d9a64d55e74dfbb4caccf657"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d43dbc5f1e628eb2ba3894a310efc6654ea4413d9a64d55e74dfbb4caccf657"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdb165fa10408f92c0c20d0dcd2d6c1e0a97927c1fc53f3b85f6c621abf04774"
    sha256 cellar: :any_skip_relocation, ventura:       "fdb165fa10408f92c0c20d0dcd2d6c1e0a97927c1fc53f3b85f6c621abf04774"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49ffbe3832d70bad7240e04b17abdd289a1ab72e37b34d577262c2e35ba8ba7b"
  end

  depends_on "augeas"
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "dialog"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "acme" do
    url "https://files.pythonhosted.org/packages/4b/c8/b2dcfa573137a60f563a7122e539774be6d7b758928f85e4efbb9f339bd1/acme-2.11.0.tar.gz"
    sha256 "f4950015cf52ff0de12f37fc28034c7710aca63f64f1696253d2f6cb9f22645e"
  end

  resource "certbot-apache" do
    url "https://files.pythonhosted.org/packages/8a/71/4fa0513e0667b76f650a04b97e4727ef1bbf7ea5bd2dbbaf74a0e33cf19e/certbot_apache-2.11.0.tar.gz"
    sha256 "27d39c6ad4c95a5ee1d9d8c81e95c3379f8ba35ca181b4a0b64c2bd678983b43"
  end

  resource "certbot-nginx" do
    url "https://files.pythonhosted.org/packages/31/55/37778fb966ea4b225e29aebab56be283d5eb8f4483d0a8e0b9e6a12f86f9/certbot_nginx-2.11.0.tar.gz"
    sha256 "0d1fd009b38229d510fe2e33122758a4ae2ee790c324234ab99ec984211d4d6f"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
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
    url "https://files.pythonhosted.org/packages/5d/70/ff56a63248562e77c0c8ee4aefc3224258f1856977e0c1472672b62dadb8/pyopenssl-24.2.1.tar.gz"
    sha256 "4247f0dbe3748d560dcbb2ff3ea01af0f9a1a001ef5f7c4c647956ed8cbf0e95"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/83/08/13f3bce01b2061f2bbd582c9df82723de943784cf719a35ac886c652043a/pyparsing-3.1.4.tar.gz"
    sha256 "f86ec8d1a83f11977c9a6ea7598e8c27fc5cddfa5b07ea2241edbbde1d7bc032"
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
    url "https://files.pythonhosted.org/packages/3a/31/3c70bf7603cc2dca0f19bdc53b4537a797747a58875b552c8c413d963a3f/pytz-2024.2.tar.gz"
    sha256 "2aa355083c50a0f93fa581709deac0c9ad65cca8a9e9beac660adcbd493c798a"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
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
