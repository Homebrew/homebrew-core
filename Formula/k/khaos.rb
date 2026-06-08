class Khaos < Formula
  include Language::Python::Virtualenv

  desc "Kafka traffic simulator for observability and chaos engineering"
  homepage "https://github.com/aleksandarskrbic/khaos"
  url "https://files.pythonhosted.org/packages/7f/0c/932228842cb6c0357fa4f41c5e68afaf3b41b7698f0794af300533594432/khaos_cli-0.7.1.tar.gz"
  sha256 "f5eb232f427dab15bbaa7ff8200a17d04c036a695c1c614e862bf87d93917b20"
  license "Apache-2.0"
  revision 7
  head "https://github.com/aleksandarskrbic/khaos.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "364f6e05c223912fb6ed034a3eaf38cdb494af08ce0de45e445bb75dbcf97e4a"
    sha256 cellar: :any,                 arm64_sequoia: "f80e4c9815160d80ed11ce19e179afb755bb66eea9db9c0a6d085ac7ead92f88"
    sha256 cellar: :any,                 arm64_sonoma:  "a856a27af7ea20db50a9481fdcb5a3aacf7facc1454cfc1c03121a3dcd5cb537"
    sha256 cellar: :any,                 sonoma:        "d9d5e17c4238bd4c49cecdbd58f2cb34d5a7dc3386c583ebfff267c756f240da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9bec973f137bbf7ab0a967b22cf0b6671f3a810c658128e17d8c6fee8a9a509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3eae40f3737c82a464acbb699bb184850b3c42f64bd867bf1142af469146ec75"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "librdkafka"
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "authlib" do
    url "https://files.pythonhosted.org/packages/36/98/7d93f30d029643c0275dbc0bd6d5a6f670661ee6c9a94d93af7ab4887600/authlib-1.7.2.tar.gz"
    sha256 "2cea25fefcd4e7173bdf1372c0afc265c8034b23a8cd5dcb6a9164b826c64231"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/8f/c1/67cfb86aa21144796ff51068326d467fbef8ee42f8d08a3a8a926106cf0c/cachetools-7.1.3.tar.gz"
    sha256 "135cfe944bc3c1e805505f65dae0bef375a2f96261171ab66c79ef77d0bda39d"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/23/e4/796662cd90cf80e3a363c99db2b88e0e394b988a575f60a17e16440cd011/click-8.4.0.tar.gz"
    sha256 "638f1338fe1235c8f4e008e4a8a254fb5c5fbdcbb40ece3c9142ebb78e792973"
  end

  resource "confluent-kafka" do
    url "https://files.pythonhosted.org/packages/40/52/2c71d8e0b2de51076f90cea05342dc9c20fa14ded11992827680db4bbdfa/confluent_kafka-2.14.0.tar.gz"
    sha256 "34efddfd06766d1153d10a70c23a98f6035e253a906db8ed04cb0249fc3b0fd2"
  end

  resource "faker" do
    url "https://files.pythonhosted.org/packages/18/06/70886e82d8f1d2b73454f3a7c1b7405300128df22e70d85a828951366932/faker-40.18.0.tar.gz"
    sha256 "2207575c0e8f90e6ccd6dbef764de875c614d16d3db4eee9712d9a00087f2e70"
  end

  resource "fastavro" do
    url "https://files.pythonhosted.org/packages/6e/5b/ccb338db71f347e3bc031d268bf6dc41e5ead63b6997b8e72af92f05e18e/fastavro-1.12.2.tar.gz"
    sha256 "3c79502d56cf6b76210032e1c53494ddfbc73c140bccf2ef4092b3f0825323ab"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/b5/c8/f439cffde755cffa462bfbb156278fa6f9d09119719af9814b858fd4f81f/googleapis_common_protos-1.75.0.tar.gz"
    sha256 "53a062ff3c32552fbd62c11fe23768b78e4ddf0494d5e5fd97d3f4689c75fbbd"
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
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
  end

  resource "joserfc" do
    url "https://files.pythonhosted.org/packages/3b/dc/5f768c2e391e9afabe5d18e3221346deb5fb6338565f1ccc9e7c6d7befdd/joserfc-1.6.5.tar.gz"
    sha256 "1482a7db78fb4602e44ed89e51b599d052e091288c7c532c5b694e20149dec48"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/60/fd/5b1491d9e4b586d621c54f4c36b888714164b6875f8d6afa3f9072906a51/protobuf-7.35.0.tar.gz"
    sha256 "a2efd84605f41e559f1881b0912b44099d0a2ac9bf46b3474823f10fb393b0e6"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/e4/51/9aed62104cea109b820bbd6c14245af756112017d309da813ef107d42e7e/typer-0.25.1.tar.gz"
    sha256 "9616eb8853a09ffeabab1698952f33c6f29ffdbceb4eaeecf571880e8d7664cc"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"khaos", shell_parameter_format: :typer)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/khaos --version")
    assert_match "Available Scenarios", shell_output("#{bin}/khaos list")
  end
end
