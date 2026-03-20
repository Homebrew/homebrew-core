class Khaos < Formula
  include Language::Python::Virtualenv

  desc "Kafka traffic simulator for observability and chaos engineering"
  homepage "https://github.com/aleksandarskrbic/khaos"
  url "https://files.pythonhosted.org/packages/7f/0c/932228842cb6c0357fa4f41c5e68afaf3b41b7698f0794af300533594432/khaos_cli-0.7.1.tar.gz"
  sha256 "f5eb232f427dab15bbaa7ff8200a17d04c036a695c1c614e862bf87d93917b20"
  license "Apache-2.0"
  revision 3
  head "https://github.com/aleksandarskrbic/khaos.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d100d4b759b70a7077fbd5503a3330d4f75daea455bc5efacd142c232d0d26b0"
    sha256 cellar: :any,                 arm64_sequoia: "2dd383b9578810c0a17537f36f873f0ee8bff2c7c5da7b8cf4ad38ff25912d26"
    sha256 cellar: :any,                 arm64_sonoma:  "f983d8d1f84571e49fffc1c068cec478447b641c1569308a5795b8494f864da8"
    sha256 cellar: :any,                 sonoma:        "92ea4005eaa23d98ab9c04327ec90aa8f42758574f2fda0fec9f6b8e04e5f1ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "863274b31f823b05f0fced994f96754584eacf28bb752ae844753fb1e5caecb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c95e9bb487ffb2aff3684d7e553d24d7a83a09e86ee48d0420bf04febb478db8"
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
    url "https://files.pythonhosted.org/packages/96/f0/5eb65b2bb0d09ac6776f2eb54adee6abe8228ea05b20a5ad0e4945de8aac/anyio-4.12.1.tar.gz"
    sha256 "41cfcc3a4c85d3f05c932da7c26d0201ac36f72abd4435ba90d0464a3ffed703"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "authlib" do
    url "https://files.pythonhosted.org/packages/af/98/00d3dd826d46959ad8e32af2dbb2398868fd9fd0683c26e56d0789bd0e68/authlib-1.6.9.tar.gz"
    sha256 "d8f2421e7e5980cc1ddb4e32d3f5fa659cfaf60d8eaf3281ebed192e4ab74f04"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/6c/c7/342b33cc6877eebc6c9bb45cb9f78e170e575839699f6f3cc96050176431/cachetools-7.0.2.tar.gz"
    sha256 "7e7f09a4ca8b791d8bb4864afc71e9c17e607a28e6839ca1a644253c97dbeae0"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "confluent-kafka" do
    url "https://files.pythonhosted.org/packages/7a/38/f5855cae6d328fa66e689d068709f91cbbd4d72e7e03959998bd43ac6b26/confluent_kafka-2.13.2.tar.gz"
    sha256 "619d10d1d77c9821ba913b3e42a33ade7f889f3573c7f3c17b57c3056e3310f5"
  end

  resource "faker" do
    url "https://files.pythonhosted.org/packages/70/03/14428edc541467c460d363f6e94bee9acc271f3e62470630fc9a647d0cf2/faker-40.8.0.tar.gz"
    sha256 "936a3c9be6c004433f20aa4d99095df5dec82b8c7ad07459756041f8c1728875"
  end

  resource "fastavro" do
    url "https://files.pythonhosted.org/packages/65/8b/fa2d3287fd2267be6261d0177c6809a7fa12c5600ddb33490c8dc29e77b2/fastavro-1.12.1.tar.gz"
    sha256 "2f285be49e45bc047ab2f6bed040bb349da85db3f3c87880e4b92595ea093b2b"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/e5/7b/adfd75544c415c487b33061fe7ae526165241c1ea133f9a9125a56b39fd8/googleapis_common_protos-1.72.0.tar.gz"
    sha256 "e55a601c1b32b52d7a3e65f43563e2aa61bcd737998ee672ac9b951cd49319f5"
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
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/ba/25/7c72c307aafc96fa87062aa6291d9f7c94836e43214d43722e86037aac02/protobuf-6.33.5.tar.gz"
    sha256 "6ddcac2a081f8b7b9642c09406bc6a4290128fce5f471cddd165960bb9119e5c"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/f5/24/cb09efec5cc954f7f9b930bf8279447d24618bb6758d4f6adf2574c41780/typer-0.24.1.tar.gz"
    sha256 "e39b4732d65fbdcde189ae76cf7cd48aeae72919dea1fdfc16593be016256b45"
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
