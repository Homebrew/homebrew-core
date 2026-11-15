class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://files.pythonhosted.org/packages/fa/a3/a06463a47466d0fd140784fe038acdf56efc5679aebe13efe5d966de50fc/certbot-5.10.0.tar.gz"
  sha256 "522517720f39b5ddb5a2841bda87f27693a1f58e9fa90d6823c288822cc9a204"
  license "Apache-2.0"
  head "https://github.com/certbot/certbot.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "31f847afd66bf3f9e491a23f768d21d5c72f80bc4a6c238a7f6a570fb65e1f1c"
    sha256 cellar: :any, arm64_tahoe:       "0e4b3472d7aa0c3e19fd73ab5e6b00b5e849510a33101dfc42363a5a4f72d025"
    sha256 cellar: :any, arm64_sequoia:     "bab021a95242b7a2db3b9ef19c08e00ca01fa5cff4ae5cfcab696562dd7ef1fb"
    sha256 cellar: :any, arm64_linux:       "0df96a12f480bc4c5ec9c23a6aed23c012d201ff51ff51ac3b9b2399ed86df1a"
    sha256 cellar: :any, x86_64_linux:      "613ccbac26efd1cc9e1af9872e2bc40ab2396ab4166f8e5ea7a490f8c5621b67"
  end

  depends_on "augeas"
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"

  uses_from_macos "libffi"

  pypi_packages exclude_packages: ["certifi", "cryptography", "pydantic"],
                extra_packages:   ["certbot-apache", "certbot-nginx", "certbot-dns-cloudflare"]

  resource "acme" do
    url "https://files.pythonhosted.org/packages/6b/be/4ca266e21a1a3755b9c661a3c1bbfdac8b16aed08dfb846a291f09e17c11/acme-5.10.0.tar.gz"
    sha256 "12f7de98431d39028e02daafe512a82a1496964cbebcfe6d9a115147c9ad1861"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
  end

  resource "certbot-apache" do
    url "https://files.pythonhosted.org/packages/b6/8e/9e3a511920a68667bf7127001d2f8e15a106f84305ef7c86e1e81108c04c/certbot_apache-5.10.0.tar.gz"
    sha256 "357368f77046e4024ae4b6222fb9552882bc93c4d0d09631949b25e7c49c2d69"
  end

  resource "certbot-dns-cloudflare" do
    url "https://files.pythonhosted.org/packages/3a/d3/9788021b444f74571fae50400849734d09ebacfa95acfb17a9025cd44ae9/certbot_dns_cloudflare-5.10.0.tar.gz"
    sha256 "517e24e413687cacbd9147e2d8c2a586f8742e1dbaea23851bdbb25d26849533"
  end

  resource "certbot-nginx" do
    url "https://files.pythonhosted.org/packages/95/b3/9d99f1293fdb9b0183f5fe7acafa4e2cc211354b3adc884ad2e2566190f4/certbot_nginx-5.10.0.tar.gz"
    sha256 "2240b57f00bcda150a39da8a88cc1c24a68374e1dc6988b21822cd8163cebc0b"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "cloudflare" do
    url "https://files.pythonhosted.org/packages/0c/e8/5188c42b346a29f018b397d3b4cd587cf386902b459d04bed5774915c525/cloudflare-5.10.0.tar.gz"
    sha256 "3e1ac8f71f5098dc3541bfd77ae0d3abd710aebef48093021e7d37f6bb584ca0"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/bc/d9/c591a80cf3335de7820c6762f8ee9298a43da5319803d319e16657b6fdf2/configargparse-1.9.0.tar.gz"
    sha256 "48d9c22affe4ac419b4dd0691fa929d759e1f99574be41826785f2dbf3da63a5"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "josepy" do
    url "https://files.pythonhosted.org/packages/8d/6f/c1b17c5a4978f80d10fc46257ef84fa09648265df0939639ce50d5896886/josepy-2.3.0.tar.gz"
    sha256 "64084a17845cb8c0c18abe3c66eb74d61e44c19c9bd45d21cd279749a7ac109a"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/3f/e8/7325d258199b159eb2c03fe32107533e2832e70e63f4fb88a6aa00023201/pyopenssl-26.4.0.tar.gz"
    sha256 "28dfcce0162b9211413e26dfbfdf1d24317fbeba18fc93c12400a1856b2a0bc7"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/e4/11/b213bebff182584360cb8d17c72c1677fec5c5c228de439e63bcf8ab1c8f/pyparsing-3.3.3.tar.gz"
    sha256 "928ae7e20211f3b6f3915a72f06a0cfd29ab9d24279dd6346b6b1a7146397d36"
  end

  resource "pyrfc3339" do
    url "https://files.pythonhosted.org/packages/80/7a/0e5227aa1c831fdaf579073a0ebb5ca11fc352a43fce8d2639e3ff87ff74/pyrfc3339-2.1.1.tar.gz"
    sha256 "b144d63819bd4c1ebf9cb57e12f4cba567fcf23d6e8f2f829ba9c7810ea4b951"
  end

  resource "python-augeas" do
    url "https://files.pythonhosted.org/packages/44/f6/e09619a5a4393fe061e24a6f129c3e1fbb9f25f774bfc2f5ae82ba5e24d3/python-augeas-1.2.0.tar.gz"
    sha256 "d2334710e12bdec8b6633a7c2b72df4ca24ab79094a3c9e699494fdb62054a10"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    if build.head?
      head_packages = %w[acme certbot certbot-apache certbot-nginx certbot-dns-cloudflare]
      venv = virtualenv_create(libexec, python3)
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
