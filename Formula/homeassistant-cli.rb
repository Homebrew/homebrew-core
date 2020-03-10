class HomeassistantCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line utility for Home Assistant"
  homepage "https://github.com/home-assistant/home-assistant-cli"
  url "https://files.pythonhosted.org/packages/63/ad/e02ef2951ebeb871a1f7e13a1975683520a18c9dddfd9b94cc6fec6ff3ca/homeassistant-cli-0.8.0.tar.gz"
  sha256 "1610c91ce23fda460d95d2937f898360bfff8a9ef80fc7bbfa9966a0c4120463"
  revision 2
  head "https://github.com/home-assistant/home-assistant-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "577de4e084789c32b7722a90b83039f1d858729bc18037cb06a45405c5bc9990" => :catalina
    sha256 "8c35c7ac779508f0eef5519c68dd660ab685b1ad799526c1a739eb15bb1fee4a" => :mojave
    sha256 "6161df03584c4230a7b2c671aef41bdf59d8971f9b2cc42fd3e09a210ed67d8e" => :high_sierra
  end

  depends_on "python@3.8"

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/00/94/f9fa18e8d7124d7850a5715a0b9c0584f7b9375d331d35e157cee50f27cc/aiohttp-3.6.2.tar.gz"
    sha256 "259ab809ff0727d0e834ac5e8a283dc5e3e0ecc30c4d80b3cd17a4139ce1f326"
  end

  resource "async_timeout" do
    url "https://files.pythonhosted.org/packages/a1/78/aae1545aba6e87e23ecab8d212b58bb70e72164b67eb090b81bb17ad38e3/async-timeout-3.0.1.tar.gz"
    sha256 "0c3c816a028d47f659d6ff5c745cb2acf1f966da1fe5c19c77a70282b25f4c5f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/98/c3/2c227e66b5e896e15ccdae2e00bbc69aa46e9a8ce8869cc5fa96310bf612/attrs-19.3.0.tar.gz"
    sha256 "f7b7ce16570fe9965acd6d30101a28f62fb4a7f9e926b3bbc9b61f8b04247e72"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/41/bf/9d214a5af07debc6acf7f3f257265618f1db242a3f8e49a9b516f24523a6/certifi-2019.11.28.tar.gz"
    sha256 "25b64c7da4cd7479594d035c08c2d809eb4aab3a26e5a990ea98cc450c320f1f"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f8/5c/f60e9d8a1e77005f664b76ff8aeaee5bc05d0a91798afd7f53fc998dbc47/Click-7.0.tar.gz"
    sha256 "5b94b49521f6456670fdb30cd82a4eca9412788a93fa6dd6df72c94d5a8ff2d7"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/22/44/3d73579b547f0790a2723728088c96189c8b52bd2ee3c3de8040efc3c1b8/click-log-0.3.2.tar.gz"
    sha256 "16fd1ca3fc6b16c98cea63acf1ab474ea8e676849dc669d86afafb0ed7003124"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/b9/50/118d342bca64addaccf54cb2fda64454d5c5b9c520d7201b5139d60d6f92/dateparser-0.7.2.tar.gz"
    sha256 "e1eac8ef28de69a554d5fcdb60b172d526d61924b1a40afbbb08df459a36006b"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/dc/c3/9d378af09f5737cfd524b844cd2fbb0d2263a35c11d712043daab290144d/decorator-4.4.1.tar.gz"
    sha256 "54c38050039232e1db4ad7375cfce6748d7b41c29e95a081c8a6d2c30364a2ce"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "ifaddr" do
    url "https://files.pythonhosted.org/packages/9f/54/d92bda685093ebc70e2057abfa83ef1b3fb0ae2b6357262a3e19dfe96bb8/ifaddr-0.1.6.tar.gz"
    sha256 "c19c64882a7ad51a394451dabcbbed72e98b5625ec1e79789924d5ea3e3ecb93"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7b/db/1d037ccd626d05a7a47a1b81ea73775614af83c2b3e53d86a0bb41d8d799/Jinja2-2.10.3.tar.gz"
    sha256 "9fe95f19286cfefaa917656583d020be14e7859c6b0252588391e47db34527de"
  end

  resource "jsonpath-rw" do
    url "https://files.pythonhosted.org/packages/71/7c/45001b1f19af8c4478489fbae4fc657b21c4c669d7a5a036a86882581d85/jsonpath-rw-1.4.0.tar.gz"
    sha256 "05c471281c45ae113f6103d1268ec7a4831a2e96aa80de45edc89b11fac4fbec"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/34/68/38290d44ea34dae6d52719f0c94bd09951387cec75e36cdce6805b5f27e9/multidict-4.7.1.tar.gz"
    sha256 "d7b6da08538302c5245cd3103f333655ba7f274915f1f5121c4f4b5fbdb3febe"
  end

  resource "netdisco" do
    url "https://files.pythonhosted.org/packages/ae/73/2a60ac3292203ac75528b1ae9a475fac6fff690e906cbc13e744701b2436/netdisco-2.6.0.tar.gz"
    sha256 "2b3aca14a1807712a053f11fd80dc251dd821ee4899aefece515287981817762"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/82/c3/534ddba230bd4fbbd3b7a3d35f3341d014cca213f369a9940925e7e5f691/pytz-2019.3.tar.gz"
    sha256 "b02c06db6cf09c12dd25137e563b31700d3b80fcc4ad23abb7a315f2789819be"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8c/db/4b29a0adec5881542cd81cb5d1929b5c0787003c5740b3c921e627d9c2e5/regex-2019.12.9.tar.gz"
    sha256 "77a3799152951d6d14ae5720ca162c97c64f85d4755da585418eac216b736cad"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/01/62/ddcf76d1d19885e8579acb1b1df26a852b03472c0e46d2b959a714c90608/requests-2.22.0.tar.gz"
    sha256 "11e007a8a2aa0323f5a921e9e6a2d7e4e67d9877e85773fba9ba6419025cbeb4"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/de/76/cf97d739365eff258e2af0457a150bf2818f3eaa460328610eafeed0894a/ruamel.yaml-0.16.5.tar.gz"
    sha256 "412a6f5cfdc0525dee6a27c08f5415c7fd832a7afcb7a0ed7319628aed23d408"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/92/28/612085de3fae9f82d62d80255d9f4cf05b1b341db1e180adcf28c1bf748d/ruamel.yaml.clib-0.2.0.tar.gz"
    sha256 "b66832ea8077d9b3f6e311c4a53d06273db5dc2db6e8a908550f3c14d67e718c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/3e/edcf6fef41d89187df7e38e868b2dd2182677922b600e880baad7749c865/six-1.13.0.tar.gz"
    sha256 "30f610279e8b2578cab6db20741130331735c781b56053c59c4076da27f06b66"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/c4/41/523f6a05e6dc3329a5660f6a81254c6cd87e5cfb5b7482bae3391d86ec3a/tabulate-0.8.6.tar.gz"
    sha256 "5470cc6687a091c7042cee89b2946d9235fe9f6d49c193a4ae2ac7bf386737c8"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/c6/52/5ec375d4efcbe4e31805f3c4b301bdfcff9dcbdb3605d4b79e117a16b38d/tzlocal-2.0.0.tar.gz"
    sha256 "949b9dd5ba4be17190a80c0268167d7e6c92c62b30026cf9764caf3e308e5590"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ad/fc/54d62fa4fc6e675678f9519e677dfc29b8964278d75333cf142892caf015/urllib3-1.25.7.tar.gz"
    sha256 "f3c5fd51747d450d4dcf6f923c81f78f811aab8205fda64b0aba34a4e48b0745"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/d6/67/6e2507586eb1cfa6d55540845b0cd05b4b77c414f6bca8b00b45483b976e/yarl-1.4.2.tar.gz"
    sha256 "58cd9c469eced558cd81aa3f484b2924e8897049e06889e8ff2510435b7ef74b"
  end

  resource "zeroconf" do
    url "https://files.pythonhosted.org/packages/35/1a/63df0e17b10f55d5e352048705ba6d4a2a8afb622914441b98b6f966743f/zeroconf-0.24.0.tar.gz"
    sha256 "b5542321c8f5344a806593e47a11b04d6c9d240cfc10492b6287ae9a0b1d1f3e"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/hass-cli"
  end

  test do
    # test shell completion output
    completion_token = "_hass_cli_completion"
    assert_match completion_token, shell_output("#{bin}/hass-cli completion bash")
    assert_match completion_token, shell_output("#{bin}/hass-cli completion zsh")
  end
end
