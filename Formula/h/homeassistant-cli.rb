class HomeassistantCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line utility for Home Assistant"
  homepage "https://github.com/home-assistant-ecosystem/home-assistant-cli"
  url "https://files.pythonhosted.org/packages/b2/98/fd5e7beb7cc135f80d78b32c85ac15f3ba9219063b794b1d184fb07fd84b/homeassistant-cli-0.9.6.tar.gz"
  sha256 "9b9b705eaf6ee40dc6a732f3458c78ba37b62b7330bc17b132e6fee385ec8606"
  license "Apache-2.0"
  revision 12
  head "https://github.com/home-assistant-ecosystem/home-assistant-cli.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "372b4d8d1af99c8573083a7ddcfa84f38b98f65269246a1c773b661f97957d7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "973b296937c5b3457bf569a1bbc5b2a8c64ea8fc418d771c364f99398fc23344"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d731ebc5f152aa5bdc52d06c44ad880c1b04dbf6595846418cb904f726734bb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "25750a10e52d0bf30cd501aad952d108df7f2a71034b115820a196a20fd55db8"
    sha256 cellar: :any_skip_relocation, ventura:       "de173c8cf63ddce080902a4420941ab696af4f4ed27e0686299acdc3bf3c3123"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fa0b8a135770666decdac696c96d195ff30d5ac39339b5ca2b8876856b428f9"
  end

  depends_on "python@3.13"

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/bc/69/2f6d5a019bd02e920a3417689a89887b39ad1e350b562f9955693d900c40/aiohappyeyeballs-2.4.3.tar.gz"
    sha256 "75cf88a15106a5002a8eb1dab212525c00d1f4c0fa96e551c9fbe6f09a621586"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/17/7e/16e57e6cf20eb62481a2f9ce8674328407187950ccc602ad07c685279141/aiohttp-3.10.10.tar.gz"
    sha256 "0631dd7c9f0822cc61c88586ca76d5b5ada26538097d0f1df510b082bad3411a"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/b0/ee/9b19140fe824b367c04c5e1b369942dd754c4c5462d5674002f75c4dedc1/certifi-2024.8.30.tar.gz"
    sha256 "bec941d2aa8195e248a60b31ff9f0558284cf01a52591ceda73ea9afffd69fd9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/32/32/228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260/click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/86/6e/9a47cf3841bcfd1dd07a20b2aca42d4e02822ea7121aeb022869855b8d2f/dateparser-0.7.6.tar.gz"
    sha256 "e875efd8c57c85c2d02b238239878db59ff1971f5a823457fcc69e493bf6ebfa"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/cf/3d/2102257e7acad73efc4a0c306ad3953f68c504c16982bbdfee3ad75d8085/frozenlist-1.4.1.tar.gz"
    sha256 "c037a86e8513059a2613aaba4d817bb90b9d9b6b69aace3ce9c877e8c8ed402b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "ifaddr" do
    url "https://files.pythonhosted.org/packages/e8/ac/fb4c578f4a3256561548cd825646680edcadb9440f3f68add95ade1eb791/ifaddr-0.2.0.tar.gz"
    sha256 "cc0cbfcaabf765d44595825fb96a99bb12c79716b73b44330ea38ee2b0c4aed4"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "jsonpath-ng" do
    url "https://files.pythonhosted.org/packages/2a/58/a31c70d23cbab69129e72be2d70c7d525ee1bd7825e6312e7c09517a01a0/jsonpath-ng-1.6.1.tar.gz"
    sha256 "086c37ba4917304850bd837aeab806670224d3f038fe2833ff593a672ef0a5fa"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b4/d2/38ff920762f2247c3af5cbbbbc40756f575d9692d381d7c520f45deb9b8f/markupsafe-3.0.1.tar.gz"
    sha256 "3e683ee4f5d0fa2dde4db77ed8dd8a876686e3fc417655c2ece9a90576905344"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/d6/be/504b89a5e9ca731cd47487e91c469064f8ae5af93b7259758dcfc2b9c848/multidict-6.1.0.tar.gz"
    sha256 "22ae2ebf9b0c69d206c003e2f6a914ea33f0a932d4aa16f236afc049d9958f4a"
  end

  resource "netdisco" do
    url "https://files.pythonhosted.org/packages/65/ca/f9263e384128a973595dda4022c96cb89afab8a9a83435bc955ec6f23358/netdisco-3.0.0.tar.gz"
    sha256 "4dbb590482f377ccc461e01742707ccbe8f1d2d1b28578af91dc9b7febcdcbd2"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/a9/4d/5e5a60b78dbc1d464f8a7bbaeb30957257afdc8512cbb9dfd5659304f5cd/propcache-0.2.0.tar.gz"
    sha256 "df81779732feb9d01e5d513fad0122efb3d53bbc75f61b2a4f29a020bc985e70"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/3a/31/3c70bf7603cc2dca0f19bdc53b4537a797747a58875b552c8c413d963a3f/pytz-2024.2.tar.gz"
    sha256 "2aa355083c50a0f93fa581709deac0c9ad65cca8a9e9beac660adcbd493c798a"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/f9/38/148df33b4dbca3bd069b963acab5e0fa1a9dbd6820f8c322d0dd6faeff96/regex-2024.9.11.tar.gz"
    sha256 "6c188c307e8433bcb63dc1915022deb553b4203a70722fc542c363bf120a01fd"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/d1/d6/eb2833ccba5ea36f8f4de4bcfa0d1a91eb618f832d430b70e3086821f251/ruamel.yaml-0.17.40.tar.gz"
    sha256 "6024b986f06765d482b5b07e086cc4b4cd05dd22ddcbc758fa23d54873cf313d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/46/fe/2ca2e5ef45952f3e8adb95659821a4e9169d8bbafab97eb662602ee12834/yarl-1.14.0.tar.gz"
    sha256 "88c7d9d58aab0724b979ab5617330acb1c7030b79379c8138c1c8c94e121d1b3"
  end

  resource "zeroconf" do
    url "https://files.pythonhosted.org/packages/6b/18/fc7cd696bbe46bfab306cfd7fe8111af5c30d7f77204c9e86f5ed2f39e6b/zeroconf-0.135.0.tar.gz"
    sha256 "9424551ef5a8d91fa8296bb1791e83b31afcd17a336a071928d4a978d7b96b72"
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
