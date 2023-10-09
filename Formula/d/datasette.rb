class Datasette < Formula
  include Language::Python::Virtualenv
  desc "Open source multi-tool for exploring and publishing data"
  homepage "https://docs.datasette.io/en/stable/"
  url "https://files.pythonhosted.org/packages/44/69/2c4e85d5409ca9d162a51312d284676eb7ba4293aff6c3d427523fef116d/datasette-0.64.5.tar.gz"
  sha256 "df917896f181ce57e26c6b3b78ff7fdfdc46c322c46673b2276fae1d8e7f19e2"
  license "Apache-2.0"
  head "https://github.com/simonw/datasette.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d036f0f2737151dab03d273868a8f1fff1e6502964b363d2182b731c642f542"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d17003498c2a4cf52a2f04cab7314fbe82a4febce11bef69c258f93f66b5fc5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82afad6be11cebc602671f16725bcd0a40a195b513e4f12029bc19750bb0a719"
    sha256 cellar: :any_skip_relocation, sonoma:         "b79fd6245fa471dc51ee0a3e63b7af76062610e78cad995e6ff2e6c21245f6bc"
    sha256 cellar: :any_skip_relocation, ventura:        "9b893995a03d9b7fede062e079e203bfb2e3418d068cb48d373c063a22cf4317"
    sha256 cellar: :any_skip_relocation, monterey:       "65c0dd000ac6ddaca34f295742fc18cb39e13aecabe0af400813441a6f2d3daf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb232ea2ab3ab8b133e4068cafaf16de3325c42730ae3acae4d10a2f55b6155c"
  end

  depends_on "python-certifi"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/af/41/cfed10bc64d774f497a86e5ede9248e1d062db675504b41c320954d99641/aiofiles-23.2.1.tar.gz"
    sha256 "84ec2218d8419404abcb9f0c02df3f34c6e0a68ed41072acfb1cef5cbc29051a"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/74/17/5075225ee1abbb93cd7fc30a2d343c6a3f5f71cf388f14768a7a38256581/anyio-4.0.0.tar.gz"
    sha256 "f7ed51751b2c2add651e5747c891b47e26d2a21be5d32d9311dfe9692f3e5d7a"
  end

  resource "asgi-csrf" do
    url "https://files.pythonhosted.org/packages/29/9c/13d880d7ebe13956c037864eb7ac9dbcd0260d4c47844786f07ccca897e1/asgi-csrf-0.9.tar.gz"
    sha256 "6e9d3bddaeac1a8fd33b188fe2abc8271f9085ab7be6e1a7f4d3c9df5d7f741a"
  end

  resource "asgiref" do
    url "https://files.pythonhosted.org/packages/12/19/64e38c1c2cbf0da9635b7082bbdf0e89052e93329279f59759c24a10cc96/asgiref-3.7.2.tar.gz"
    sha256 "9e0ce3aa93a819ba5b45120216b23878cf6e8525eb3848653452b4192b92afed"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/23/b6/d71729dc09e5a5b361b655ae18e85fbf97e5e27a076c4f9b4606b4eb0340/httpcore-0.18.0.tar.gz"
    sha256 "13b5e5cd1dca1a6636a6aaea212b19f4f85cd88c366a2b82304181b769aab3c9"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/a5/24/dbc981590a8b72ddd5f954fbddb1da010ae844a1cde904bca3c9380ccb1d/httpx-0.25.0.tar.gz"
    sha256 "47ecda285389cb32bb2691cc6e069e3ab0205956f681c5b2ad2325719751d875"
  end

  resource "hupper" do
    url "https://files.pythonhosted.org/packages/42/3d/70bef845298bb4746b94418efde81bcfe0fad479169c2e9649f95630bfa7/hupper-1.12.tar.gz"
    sha256 "18b1653d9832c9f8e7d3401986c7e7af2ae6783616be0bc406bfe0b14134a5c6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/7f/a1/d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08/itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "janus" do
    url "https://files.pythonhosted.org/packages/b8/a8/facab7275d7d3d2032f375843fe46fad1cfa604a108b5a238638d4615bdc/janus-1.0.0.tar.gz"
    sha256 "df976f2cdcfb034b147a2d51edfc34ff6bfb12d4e2643d3ad0e10de058cb1612"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/3a/41/580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270/mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "pint" do
    url "https://files.pythonhosted.org/packages/2c/4b/f06c9975298765c64ac9ca6f36be072e65e1437a03a472f5fabc5327ef4e/Pint-0.22.tar.gz"
    sha256 "2d139f6abbcf3016cad7d3cec05707fe908ac4f99cf59aedfd6ee667b7a64433"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/2d/23/abcfad10c3348cb6358400f8adbc21b523bbc6c954494fd0974428068672/python_multipart-0.0.6.tar.gz"
    sha256 "e9925a80bb668529f1b67c7fdb0a5dacdd7cbfc6fb0bff3ea443fe22bdd62132"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/4c/b3/aa7eb8367959623eef0527f876e371f1ac5770a3b31d3d6db34337b795e6/uvicorn-0.23.2.tar.gz"
    sha256 "4d3cc12d7727ba72b64d12d3cc7743124074c0a69f7b201512fc50c3e3f1569a"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"datasette", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match "15", shell_output("#{bin}/datasette --get '/_memory.json?sql=select+3*5'")
    assert_match "<title>Datasette:", shell_output("#{bin}/datasette --get '/'")
  end
end
