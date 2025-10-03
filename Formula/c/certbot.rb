class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://files.pythonhosted.org/packages/42/7f/fd22e1bda654356e572e524762d4ee473d32a2c506960201d413073e5579/certbot-5.0.0.tar.gz"
  sha256 "4e9e4680e812037b582cef7335570074390b455d24a3e09bcaa2fdc473dbcc0a"
  license "Apache-2.0"
  head "https://github.com/certbot/certbot.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "35ecb33584eeae2560760a8b49d02068df51e07829414cb61487f1d7f358c9d4"
    sha256 cellar: :any,                 arm64_sequoia: "d913f2592e1efaa3c63c1b14efc1e87100322542285ee0a2a3960ad9caca5a31"
    sha256 cellar: :any,                 arm64_sonoma:  "3234eca1fb5d1cb43dbb50ad599c1257a0f907181e7e31fa61a38329c86c576a"
    sha256 cellar: :any,                 sonoma:        "b5e4c8b0bb5183bc1fe2843793910a4cd4809257de44da5399cc1fdc730acc62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70fc1d4fc1a4116c8d78a8fc6bdff4cc2c0512a74b0a558d1582cf81a879055a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da2355ad5c7de8067662765d4b9c92479d1cdf35576a53607a30641842cc6c8e"
  end

  depends_on "augeas"
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "acme" do
    url "https://files.pythonhosted.org/packages/9f/11/2a8767ea1bac25ca73d952ca1d8bd701a65c84057e4ead8bda82fb086d9c/acme-5.0.0.tar.gz"
    sha256 "b701b23e66d3c58352896a72caa13523d9f72b183a0ba1cde93e6713a450a391"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "certbot-apache" do
    url "https://files.pythonhosted.org/packages/25/b0/6b9b6cc1e94d802ca361e7f0d64966dee85b4885ca344a14c407b201e62f/certbot_apache-5.0.0.tar.gz"
    sha256 "c438b6cb4fda2fef5868b7111d130a96233ccccf5538c292e642a04a47c9dbb6"
  end

  resource "certbot-dns-cloudflare" do
    url "https://files.pythonhosted.org/packages/a9/96/6afc38a2f491b779f59cc547cd797dc2b6e0a2bca494a202732dc0029d20/certbot_dns_cloudflare-5.0.0.tar.gz"
    sha256 "84c01b06b2b0055f1b551eb3c0bc82c0a275063207cf9ea7ddc1b67129c728a4"
  end

  resource "certbot-nginx" do
    url "https://files.pythonhosted.org/packages/50/0f/b4e296e2b38a227f57347b3ebe6742271aec72e0e4728ce1b8266b6302c1/certbot_nginx-5.0.0.tar.gz"
    sha256 "c8e4b86d2537a5d9de5801a6e3a8cf17fa4f12777479192d0e2978cbc6b18305"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "cloudflare" do
    url "https://files.pythonhosted.org/packages/9b/8f/d3a435435c42d4b05ce2274432265c5890f91f6047e6dab52e50c811a4ea/cloudflare-2.19.4.tar.gz"
    sha256 "3b6000a01a237c23bccfdf6d20256ea5111ec74a826ae9e74f9f0e5bb5b2383f"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/85/4d/6c9ef746dfcc2a32e26f3860bb4a011c008c392b83eabdfb598d1a8bbe5d/configargparse-1.7.1.tar.gz"
    sha256 "79c2ddae836a1e5914b71d58e4b9adbd9f7779d4e6351a637b7d2d9b6c46d3d9"
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
    url "https://files.pythonhosted.org/packages/9d/19/4ebe24c42c341c5868dff072b78d503fc1b0725d88ea619d2db68f5624a9/josepy-2.1.0.tar.gz"
    sha256 "9beafbaa107ec7128e6c21d86b2bc2aea2f590158e50aca972dca3753046091f"
  end

  resource "jsonlines" do
    url "https://files.pythonhosted.org/packages/35/87/bcda8e46c88d0e34cad2f09ee2d0c7f5957bccdb9791b0b934ec84d84be4/jsonlines-4.0.0.tar.gz"
    sha256 "0c6d2c09117550c089995247f605ae4cf77dd1533041d366351f6f298822ea74"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/04/8c/cd89ad05804f8e3c17dea8f178c3f40eeab5694c30e0c9f5bcd49f576fc3/pyopenssl-25.1.0.tar.gz"
    sha256 "8d031884482e0c67ee92bf9a4d8cceb08d92aba7136432ffb0703c5280fc205b"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/98/c9/b4594e6a81371dfa9eb7a2c110ad682acf985d96115ae8b25a1d63b4bf3b/pyparsing-3.2.4.tar.gz"
    sha256 "fff89494f45559d0f2ce46613b419f632bbb6afbdaed49696d322bcf98a58e99"
  end

  resource "pyrfc3339" do
    url "https://files.pythonhosted.org/packages/b4/7f/3c194647ecb80ada6937c38a162ab3edba85a8b6a58fa2919405f4de2509/pyrfc3339-2.1.0.tar.gz"
    sha256 "c569a9714faf115cdb20b51e830e798c1f4de8dabb07f6ff25d221b5d09d8d7f"
  end

  resource "python-augeas" do
    url "https://files.pythonhosted.org/packages/44/f6/e09619a5a4393fe061e24a6f129c3e1fbb9f25f774bfc2f5ae82ba5e24d3/python-augeas-1.2.0.tar.gz"
    sha256 "d2334710e12bdec8b6633a7c2b72df4ca24ab79094a3c9e699494fdb62054a10"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    if build.head?
      head_packages = %w[acme certbot certbot-apache certbot-nginx certbot-dns-cloudflare]
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
