class HomeassistantCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line utility for Home Assistant"
  homepage "https://github.com/home-assistant-ecosystem/home-assistant-cli"
  # 0.9.6 artifact is missing in pypi, https://github.com/home-assistant-ecosystem/home-assistant-cli/issues/393
  url "https://github.com/home-assistant-ecosystem/home-assistant-cli/archive/refs/tags/0.9.6.tar.gz"
  sha256 "f971ac78a74922f4555ee7f77e327d8008819a8a83db1ad8037c0601e74a40ba"
  license "Apache-2.0"
  head "https://github.com/home-assistant-ecosystem/home-assistant-cli.git", branch: "dev"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6664597c67833ace3ecb5bd6c441aab36259ff548346361231e3563fd26e848"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e7924a158d09df90498d3ff6518e569d79c380acc5d9345ea733eab160cf9c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b3e6d3d62946e64d67cdf5dec80371607d519a34e949295d8b347e313148c83"
    sha256 cellar: :any_skip_relocation, ventura:        "779f8bd041f0047a28a112d17a8baf29cf1892da42d60a63cc0412bdbd670c45"
    sha256 cellar: :any_skip_relocation, monterey:       "c2002eb681ad753dd3256df39793a6312ee81e68e4a7a9492c38e2285f196880"
    sha256 cellar: :any_skip_relocation, big_sur:        "20bcf5d0ce8f8f60730b73bdb76731ada7956e67316514dfaa2c582f1478c365"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cd2c5525ce23b8003987a413e3abf1d182b632870382e0c5047a5a5cde1a635"
  end

  depends_on "python-tabulate"
  depends_on "python@3.11"
  depends_on "six"

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/ff/4f/62d9859b7d4e6dc32feda67815c5f5ab4421e6909e48cbc970b6a40d60b7/aiohttp-3.8.3.tar.gz"
    sha256 "3828fb41b7203176b82fe5d699e0d845435f2374750a44b480ea6b930f6be269"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/54/6e/9678f7b2993537452710ffb1750c62d2c26df438aa621ad5fa9d1507a43a/async-timeout-4.0.2.tar.gz"
    sha256 "2163e1640ddb52b7a8c80d0a67a08587e5d245cc9c553a74a847056bc2976b15"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/32/32/228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260/click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/86/6e/9a47cf3841bcfd1dd07a20b2aca42d4e02822ea7121aeb022869855b8d2f/dateparser-0.7.6.tar.gz"
    sha256 "e875efd8c57c85c2d02b238239878db59ff1971f5a823457fcc69e493bf6ebfa"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/e9/10/d629476346112b85c912527b9080944fd2c39a816c2225413dbc0bb6fcc0/frozenlist-1.3.3.tar.gz"
    sha256 "58bcc55721e8a90b88332d6cd441261ebb22342e238296bb330968952fbb3a6a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "ifaddr" do
    url "https://files.pythonhosted.org/packages/e8/ac/fb4c578f4a3256561548cd825646680edcadb9440f3f68add95ade1eb791/ifaddr-0.2.0.tar.gz"
    sha256 "cc0cbfcaabf765d44595825fb96a99bb12c79716b73b44330ea38ee2b0c4aed4"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jsonpath-ng" do
    url "https://files.pythonhosted.org/packages/cd/c2/5cd85d8a7de7818892fd8f751d30b6d050a8471c6647d2fda47cc542f9b4/jsonpath-ng-1.5.3.tar.gz"
    sha256 "a273b182a82c1256daab86a313b937059261b5c5f8c4fa3fc38b882b344dd567"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/b5/5b/1dd3b9cf73c474ea1d0f0b1f8b7b712b0f13817493fd93101256ec856b59/multidict-6.0.3.tar.gz"
    sha256 "2523a29006c034687eccd3ee70093a697129a3ffe8732535d3b2df6a4ecc279d"
  end

  resource "netdisco" do
    url "https://files.pythonhosted.org/packages/65/ca/f9263e384128a973595dda4022c96cb89afab8a9a83435bc955ec6f23358/netdisco-3.0.0.tar.gz"
    sha256 "4dbb590482f377ccc461e01742707ccbe8f1d2d1b28578af91dc9b7febcdcbd2"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/6d/37/54f2d7c147e42dc85ffbc6910862bb4f141fb3fc14d9a88efaa1a76c7df2/pytz-2022.7.tar.gz"
    sha256 "7ccfae7b4b2c067464a6733c6261673fdb8fd1be905460396b97a073e9fa683a"
  end

  resource "pytz-deprecation-shim" do
    url "https://files.pythonhosted.org/packages/94/f0/909f94fea74759654390a3e1a9e4e185b6cd9aa810e533e3586f39da3097/pytz_deprecation_shim-0.1.0.post0.tar.gz"
    sha256 "af097bae1b616dde5c5744441e2ddc69e74dfdcb0c263129610d85b87445a59d"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/27/b5/92d404279fd5f4f0a17235211bb0f5ae7a0d9afb7f439086ec247441ed28/regex-2022.10.31.tar.gz"
    sha256 "a3a98921da9a1bf8457aeee6a551948a83601689e5ecdd736894ea9bbec77e83"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/5b/30/b7abfb11be6642d26de1c1840d25e8d90333513350ad0ebc03101d55e13b/tzdata-2022.7.tar.gz"
    sha256 "fe5f866eddd8b96e9fcba978f8e503c909b19ea7efda11e52e39494bad3a7bfa"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/7d/b9/164d5f510e0547ae92280d0ca4a90407a15625901afbb9f57a19d9acd9eb/tzlocal-4.2.tar.gz"
    sha256 "ee5842fa3a795f023514ac2d801c4a81d1743bbe642e3940143326b3a00addd7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c2/51/32da03cf19d17d46cce5c731967bf58de9bd71db3a379932f53b094deda4/urllib3-1.26.13.tar.gz"
    sha256 "c083dd0dce68dbfbe1129d5271cb90f9447dea7d52097c6e0126120c521ddea8"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/c4/1e/1b204050c601d5cd82b45d5c8f439cb6f744a2ce0c0a6f83be0ddf0dc7b2/yarl-1.8.2.tar.gz"
    sha256 "49d43402c6e3013ad0978602bf6bf5328535c48d192304b91b97a3c6790b1562"
  end

  resource "zeroconf" do
    url "https://files.pythonhosted.org/packages/a9/d2/b757f96f39ce1cd088dac2ebe87742f50d42c1ec41a73fda0772da861814/zeroconf-0.44.0.tar.gz"
    sha256 "eb9bae4e8833833ab1fb6dfee8c9bbd620c45858ab2934b3cbce1b792830a5c6"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/hass-cli"
    generate_completions_from_executable(bin/"hass-cli", base_name:              "hass-cli",
                                                         shells:                 [:fish, :zsh],
                                                         shell_parameter_format: :click)
  end

  test do
    output = shell_output("#{bin}/hass-cli info 2>&1", 3)
    assert_match "Trying to locate Home Assistant on local network", output
    assert_match "warning: Found no Home Assistant on local network. Using defaults", output

    assert_match "hass-cli, version #{version}", shell_output("#{bin}/hass-cli --version")
  end
end
