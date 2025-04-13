class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://files.pythonhosted.org/packages/00/91/a7acb7a9f7f065bf7f4aa356ecae039f229798eeceed205f397f329cd666/certbot-4.0.0.tar.gz"
  sha256 "a867bfbb5126516c12d4c8a93909ef1e4d5309fc4e9f5b97b2d987b0ffd4bbe3"
  license "Apache-2.0"
  head "https://github.com/certbot/certbot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebb58721365d9eb126a45edb91c53793adf27cb07eeb1bf96cb39af4e7e122cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebb58721365d9eb126a45edb91c53793adf27cb07eeb1bf96cb39af4e7e122cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ebb58721365d9eb126a45edb91c53793adf27cb07eeb1bf96cb39af4e7e122cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "bca6a25dd14a0bd3b8fda4c5ec90b88e7d048193e9b3ffcc9349f0c08117ce1e"
    sha256 cellar: :any_skip_relocation, ventura:       "bca6a25dd14a0bd3b8fda4c5ec90b88e7d048193e9b3ffcc9349f0c08117ce1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebb58721365d9eb126a45edb91c53793adf27cb07eeb1bf96cb39af4e7e122cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebb58721365d9eb126a45edb91c53793adf27cb07eeb1bf96cb39af4e7e122cb"
  end

  depends_on "augeas"
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "dialog"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "acme" do
    url "https://files.pythonhosted.org/packages/c6/aa/8d598e7338fb9677a9084c27d86e51f3732c541be161d77a24e28f23b6f2/acme-4.0.0.tar.gz"
    sha256 "972d6e0b160000ae833aaa9619901896336e5dc7ca82003fa6ff465bafcbdf52"
  end

  resource "certbot-apache" do
    url "https://files.pythonhosted.org/packages/0a/93/6136841f9550fcfa7d7fee47854e359fc906e12446617b31c277c3e02dfc/certbot_apache-4.0.0.tar.gz"
    sha256 "507f9a336bd95c25548f449d8307eead6f875186a13049de173d6833371910a2"
  end

  resource "certbot-nginx" do
    url "https://files.pythonhosted.org/packages/06/a8/4ab3316ded812c91521c926ea3887ee6698cb656febd4e0f3ccc18dea64f/certbot_nginx-4.0.0.tar.gz"
    sha256 "4478c3e13e04b49f95675d83adaacdcf1356f8fac0824e236f893f2f5a1d991c"
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
    url "https://files.pythonhosted.org/packages/a9/29/e7c14150f200c5cd49d1a71b413f61b97406f57872ad693857982c0869c9/josepy-2.0.0.tar.gz"
    sha256 "e7d7acd2fe77435cda76092abe4950bb47b597243a8fb733088615fa6de9ec40"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/9f/26/e25b4a374b4639e0c235527bbe31c0524f26eda701d79456a7e1877f4cc5/pyopenssl-25.0.0.tar.gz"
    sha256 "cd2cef799efa3936bb08e8ccb9433a575722b9dd986023f1cabc4ae64e9dac16"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/bb/22/f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60f/pyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
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
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
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
