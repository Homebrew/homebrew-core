class Khaos < Formula
  include Language::Python::Virtualenv

  desc "Kafka traffic simulator for observability and chaos engineering"
  homepage "https://github.com/aleksandarskrbic/khaos"
  url "https://files.pythonhosted.org/packages/7f/0c/932228842cb6c0357fa4f41c5e68afaf3b41b7698f0794af300533594432/khaos_cli-0.7.1.tar.gz"
  sha256 "f5eb232f427dab15bbaa7ff8200a17d04c036a695c1c614e862bf87d93917b20"
  license "Apache-2.0"
  revision 6
  head "https://github.com/aleksandarskrbic/khaos.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "991f76f181b31265260894a0ea7e540c4e96365c6479ee67c9ba4796a012c396"
    sha256 cellar: :any,                 arm64_sequoia: "5c645b1980106839948b61971ba477e1c07c449c7201609851c406f6ea5abf26"
    sha256 cellar: :any,                 arm64_sonoma:  "f6887e003ccdb92d8e6e01e4fb7cac4d7aff79c76239f390a5f4729939580aa4"
    sha256 cellar: :any,                 sonoma:        "1ea7c9c9376d393179e8469850abada3418f5faae6851e5fbbe3ed8a8c1f03b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8530e8f62e5ff34d8ede91057cad5d5208f4f84a5c0946362d1c03dcb309ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "468c4f84fb92ee3745c949eee54ca36fc6d7fa4f9aa7ba306f0a6420e5cf5c11"
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
    url "https://files.pythonhosted.org/packages/ff/e2/85f227594656000ff4d8adadae91a21f536d4a84c6c716a86bd6685874be/cachetools-7.1.1.tar.gz"
    sha256 "27bdf856d68fd3c71c26c01b5edc312124ed427524d1ddb31aa2b7746fe20d4b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "confluent-kafka" do
    url "https://files.pythonhosted.org/packages/40/52/2c71d8e0b2de51076f90cea05342dc9c20fa14ded11992827680db4bbdfa/confluent_kafka-2.14.0.tar.gz"
    sha256 "34efddfd06766d1153d10a70c23a98f6035e253a906db8ed04cb0249fc3b0fd2"
  end

  resource "faker" do
    url "https://files.pythonhosted.org/packages/7f/13/6741787bd91c4109c7bed047d68273965cd52ce8a5f773c471b949334b6d/faker-40.15.0.tar.gz"
    sha256 "20f3a6ec8c266b74d4c554e34118b21c3c2056c0b4a519d15c8decb3a4e6e795"
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
    url "https://files.pythonhosted.org/packages/05/b1/efac073e0c297ecf2fb33c346989a529d4e19164f1759102dee5953ee17e/idna-3.14.tar.gz"
    sha256 "466d810d7a2cc1022bea9b037c39728d51ae7dad40d480fc9b7d7ecf98ba8ee3"
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
    url "https://files.pythonhosted.org/packages/6b/6b/a0e95cad1ad7cc3f2c6821fcab91671bd5b78bd42afb357bb4765f29bc41/protobuf-7.34.1.tar.gz"
    sha256 "9ce42245e704cc5027be797c1db1eb93184d44d1cdd71811fb2d9b25ad541280"
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
