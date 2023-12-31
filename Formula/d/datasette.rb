class Datasette < Formula
  include Language::Python::Virtualenv
  desc "Open source multi-tool for exploring and publishing data"
  homepage "https://docs.datasette.io/en/stable/"
  url "https://files.pythonhosted.org/packages/c8/7d/667e3bfceef9e428e38117b8d9704f502395fddc1effb7ef760b2dd0c4e6/datasette-0.64.6.tar.gz"
  sha256 "85ca3aabca64fd9560052042aec27d3b32a1f85303853da3550434866d0fa539"
  license "Apache-2.0"
  head "https://github.com/simonw/datasette.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "008c1337e9fa824845072a352b6ddce2e629207f8f17237b16d8bb99e3fc7c17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bbfa65a4cd46f769ec8670122738663eb7ffd89a1ec8c268e604e8d8ded32f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7d14c33232c703e2e9c17025226dc9c7a68f53dfc5eb28a73c1de2a7dc675e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e9c65787da35dccdc3d6f66988846ad76e62b5801d35b6a16e9b88e718957a2"
    sha256 cellar: :any_skip_relocation, ventura:        "c53c26fbd0308ef8e23889b2797a680b5bde3a9ebdfe471fa79683f40d34e3d0"
    sha256 cellar: :any_skip_relocation, monterey:       "82c69a3b02cf3e912cb687a98b0d0f3c31be4a2b69ddf8c9e89472f6ac3c1fd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04e0673b9a5c0ad39244a208270c1d9357b503338f6bbfa48b166cac94b5f8c0"
  end

  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-markupsafe"
  depends_on "python-setuptools"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"
  depends_on "uvicorn"

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/af/41/cfed10bc64d774f497a86e5ede9248e1d062db675504b41c320954d99641/aiofiles-23.2.1.tar.gz"
    sha256 "84ec2218d8419404abcb9f0c02df3f34c6e0a68ed41072acfb1cef5cbc29051a"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/2d/b8/7333d87d5f03247215d86a86362fd3e324111788c6cdd8d2e6196a6ba833/anyio-4.2.0.tar.gz"
    sha256 "e1875bb4b4e2de1669f4bc7869b6d3f54231cdced71605e6e64c9be77e3be50f"
  end

  resource "asgi-csrf" do
    url "https://files.pythonhosted.org/packages/29/9c/13d880d7ebe13956c037864eb7ac9dbcd0260d4c47844786f07ccca897e1/asgi-csrf-0.9.tar.gz"
    sha256 "6e9d3bddaeac1a8fd33b188fe2abc8271f9085ab7be6e1a7f4d3c9df5d7f741a"
  end

  resource "asgiref" do
    url "https://files.pythonhosted.org/packages/12/19/64e38c1c2cbf0da9635b7082bbdf0e89052e93329279f59759c24a10cc96/asgiref-3.7.2.tar.gz"
    sha256 "9e0ce3aa93a819ba5b45120216b23878cf6e8525eb3848653452b4192b92afed"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/18/56/78a38490b834fa0942cbe6d39bd8a7fd76316e8940319305a98d2b320366/httpcore-1.0.2.tar.gz"
    sha256 "9fc092e4799b26174648e54b74ed5f683132a464e95643b226e00c2ed2fa6535"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/bd/26/2dc654950920f499bd062a211071925533f821ccdca04fa0c2fd914d5d06/httpx-0.26.0.tar.gz"
    sha256 "451b55c30d5185ea6b23c2c793abf9bb237d2a7dfb901ced6ff69ad37ec1dfaf"
  end

  resource "hupper" do
    url "https://files.pythonhosted.org/packages/42/3d/70bef845298bb4746b94418efde81bcfe0fad479169c2e9649f95630bfa7/hupper-1.12.tar.gz"
    sha256 "18b1653d9832c9f8e7d3401986c7e7af2ae6783616be0bc406bfe0b14134a5c6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
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

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/3a/41/580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270/mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "pint" do
    url "https://files.pythonhosted.org/packages/02/41/002d020f140db35d971f4bdd73407d69fdf56c5ba5fcccc10776e27d3a6c/Pint-0.23.tar.gz"
    sha256 "e1509b91606dbc52527c600a4ef74ffac12fff70688aff20e9072409346ec9b4"
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

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[uvicorn].map { |p| Formula[p].opt_libexec/site_packages }
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")

    generate_completions_from_executable(bin/"datasette", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match "15", shell_output("#{bin}/datasette --get '/_memory.json?sql=select+3*5'")
    assert_match "<title>Datasette:", shell_output("#{bin}/datasette --get '/'")
  end
end
