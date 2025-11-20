class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://files.pythonhosted.org/packages/3d/d7/358779f99a2336010a27e12c9fc99b14602b9a5410f890390fa3be08e598/certbot-5.1.0.tar.gz"
  sha256 "d652a598f67af78ecf122860e85cd2e9c19a2bbe79a71775eccf6e8d642a4fca"
  license "Apache-2.0"
  head "https://github.com/certbot/certbot.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "c09b2ea3fc550f751eb1d5ad0d52eafb175b27f3a1458c2001513d2a334782ca"
    sha256 cellar: :any,                 arm64_sequoia: "40bdade7dec7114f9a424fd6c3dc55f18edcefd986156c038ba008a972f7c7d8"
    sha256 cellar: :any,                 arm64_sonoma:  "d24e51faa94e7ea253adaa5fdf41f8b2843e36ad508e501168535d99ca92269e"
    sha256 cellar: :any,                 sonoma:        "fbf8e8f6985f305ee4589bf1926b53b2d29f6ba6cd924e956cf887af18ee5d9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2288efdba2a92d39631903b55483e892520ca1a943e78f8aaef53886e5c66c0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86ee16d7ddaa6c48cb7f9e8b37482c7b3c2795758076fbcafb1aae42a3da6aad"
  end

  depends_on "augeas"
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  uses_from_macos "libffi"

  pypi_packages exclude_packages: ["certifi", "cryptography"],
                extra_packages:   ["certbot-apache", "certbot-nginx", "certbot-dns-cloudflare"]

  resource "acme" do
    url "https://files.pythonhosted.org/packages/07/f6/897be0abeb0e64f0e6136a8a6369a54d2a603a44cb7a411f6d77dbafb4ac/acme-5.1.0.tar.gz"
    sha256 "7b97820857d9baffed98bca50ab82bb6a636e447865d7a013a7bdd7972f03cda"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "certbot-apache" do
    url "https://files.pythonhosted.org/packages/dd/83/a38084ea9df81a1eda38b98fecf32ad2affa323487d752835e79ed5a8b9c/certbot_apache-5.1.0.tar.gz"
    sha256 "83f7e7578bb06c57b3d27f82ebd3c113e6f7fc8a41dc722cdc143ac98064b0ef"
  end

  resource "certbot-dns-cloudflare" do
    url "https://files.pythonhosted.org/packages/30/a4/c2b7ed26d6704ea9126e2fb4d2be97d0afc2fedaa88a80ce61a6a8fec0d2/certbot_dns_cloudflare-5.1.0.tar.gz"
    sha256 "6fea3d5e2c3db018f83bc074315a48588fb680c900f7fef3349eae6a2cfc4c6c"
  end

  resource "certbot-nginx" do
    url "https://files.pythonhosted.org/packages/fb/8a/08667f1f55ba95cbb2231a5cbb9f6dcdde0c3eca4f16194074016a98ec6c/certbot_nginx-5.1.0.tar.gz"
    sha256 "fe41cdd8f54b0587b65b686aa142191ad1bf4f7abaa708a79d5ad662757fb07a"
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
    url "https://files.pythonhosted.org/packages/80/be/97b83a464498a79103036bc74d1038df4a7ef0e402cfaf4d5e113fb14759/pyopenssl-25.3.0.tar.gz"
    sha256 "c981cb0a3fd84e8602d7afc209522773b94c1c2446a3c710a75b06fe1beae329"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f2/a5/181488fc2b9d093e3972d2a472855aae8a03f000592dbfce716a512b3359/pyparsing-3.2.5.tar.gz"
    sha256 "2df8d5b7b2802ef88e8d016a2eb9c7aeaa923529cd251ed0fe4608275d4105b6"
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
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
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
      venv = virtualenv_create(libexec, "python3.14")
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
