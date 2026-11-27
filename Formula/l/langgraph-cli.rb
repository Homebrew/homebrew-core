class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https://www.github.com/langchain-ai/langgraph"
  url "https://files.pythonhosted.org/packages/01/45/5978998423533f4c21a6e4f835f790d88761d5e46176df7209ab09004055/langgraph_cli-0.4.44.tar.gz"
  sha256 "79b9708da0d0b2c64efc3f434720db67a844b9788fa6b02faf508232f3d8f644"
  license "MIT"

  bottle do
    manifest_sha256 "48ed995c8813b6ad2fc303148b1a968727ac81c68e96e972cebce3ee2da49317"
    sha256 cellar: :any, arm64_golden_gate: "3c2a1d718445e373dc88347ad6f6d4fc1f3fdf14e5d2205dd6671ae8855da3b9"
    sha256 cellar: :any, arm64_tahoe:       "961dd9b4cac057f8f6a33ffb4a2589d23e2d773bd0267602413efb838767fcd7"
    sha256 cellar: :any, arm64_sequoia:     "55910b704026e5523634e5eddb2d4ef5cd20aeb880776d141ceebab8b38248f7"
    sha256 cellar: :any, arm64_linux:       "0b23b52cdd0499db819fb7fa58f40fdc6d42e965a62f49b7f8863c17d8b94920"
    sha256 cellar: :any, x86_64_linux:      "e568d158f942303e7d19e4cd1f8049b479d97d38228a1ad591ddddaa9253266a"
  end

  depends_on "rust" => :build # for orjson
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"
  depends_on "xxhash"
  depends_on "zstd"

  pypi_packages exclude_packages: %w[certifi pydantic]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/c2/c3/cae6d3bdefd96a941ffc247c714ac4babc488a69012e11c058f6c17c6c47/charset_normalizer-3.5.3.tar.gz"
    sha256 "a250888753faa289e2997962fbb17c4960cbdb58575533ca6fceee68c224bdff"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
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

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/92/9d/df40b41f7db0370f82019820709244e7b660c52aa3da3c9e5c4e8141f6e6/httpcore2-2.16.2.tar.gz"
    sha256 "6c519d0f7b44f7269fa9bbb4d2763db395a4a2370f046d8e8e0a4b38227815d2"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/1c/77/6515121dc5ac3c743ad1bff5afe635bcd1a3f23cc40db3c5c89f7d02917d/httpx2-2.16.2.tar.gz"
    sha256 "748b615678f07d8e3b183efe81ad13b655ca88bfc56ce4589219b2d442860574"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/9c/b5/0236966b8a3d5b9bf147ea81932c0cd59358a77497bdb95d137e5ee3f080/jsonpatch-1.48.tar.gz"
    sha256 "81e9a03754137a1201d9b534ddd599cc0eb5983fe941bce238dc8a76e442bb94"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/46/cb/2c3112a061a718d93866c2555dad1e9d53865e4703d0f3be550d252b277b/jsonpointer-3.12.tar.gz"
    sha256 "7a3dcc11b64053eaa9c549e85e413f8d40a075215f793a331bed9182a14251ae"
  end

  resource "langchain-core" do
    url "https://files.pythonhosted.org/packages/8d/6c/467e7f073aa29d8b9338f699545b8618ec6fd221ec838711dea902455246/langchain_core-1.8.5.tar.gz"
    sha256 "f0391367c1058ccec34dc248238415d8fccfa42db1727b937357888ff1da75cb"
  end

  resource "langchain-protocol" do
    url "https://files.pythonhosted.org/packages/a2/5c/94ffa0c0b9445ac284bf7c0aebf2fa3a32bdf27c20aaf2f061746375b670/langchain_protocol-0.0.22.tar.gz"
    sha256 "61267bc9f478c9df35ccdafd9fdf556b2698435232d59def54b3809bb02585bb"
  end

  resource "langgraph-sdk" do
    url "https://files.pythonhosted.org/packages/28/4d/d26d0393fa9a305199ebc4fbc2550b9b5b4fd33603bd8bd149ad6b84616f/langgraph_sdk-0.4.14.tar.gz"
    sha256 "13eb1fee92504d87c1f0f43c8e213e7ba0a46bd23a07e3198e413d48efac5833"
  end

  resource "langsmith" do
    url "https://files.pythonhosted.org/packages/bb/6b/83233750eaa407df7d1c14df1fd0ed3be866fac5d185d7f879aa434b6b2f/langsmith-0.16.2.tar.gz"
    sha256 "991592265e5ae7087d5ce0b77545ea593f0e4648e8f23178b12bb44be4ac3f96"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/f2/72/380b97dc45bd162d23afe5194721ef678d9eac7cfaa549fe2873f7f0a518/orjson-3.13.0.tar.gz"
    sha256 "d1de5eb04485110c5da4c657e49168995d55e076b1ce60f1a042e254f4186c4f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c3/75/ffb1dc0ed12352139fb4ca0e3fde4325a23e3d0f3f40efe89717bc4f557b/packaging-26.4.tar.gz"
    sha256 "c4b671c41ddb9bf26e543c37723610d28fb6bf7affc4da17cf048d419d2c062a"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/74/26/2fbeedb218a787a5eea551c7532cac4e009f83d689dd2faa0d0353473f86/python_dotenv-1.2.4.tar.gz"
    sha256 "f0d53e69935a851c0dcc78f3ab7aaccd8cabef0b92382b576b824212902873c0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/76/b8/c0b780928e2fb1c87e9e375818c6f121da2398b071012d1747be300b83f4/pyyaml-6.0.4.tar.gz"
    sha256 "e24bf71af8a432d7808fabff134d38dfe16d3cbb41f2873bb4b1e42422de0a1a"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/82/9e/497c1c8ebe5a5b5d1d4a7511aea22c0bb1a97e3170d98abdef0e1b34265a/tenacity-9.2.1.tar.gz"
    sha256 "a606b5c808d0cded4a359d5b9932d867ff2a6a6b64d37350260fd01bbdf83839"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/ee/9f/c5201d42a484c061e528825fc8e2d565f5abd50a4ced6fb7d29c4ec99b2b/truststore-0.10.5.tar.gz"
    sha256 "30d36967ccaded5cbb38d602c433f53600036c79d502f4533a49b60a03bbefcd"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "uuid-utils" do
    url "https://files.pythonhosted.org/packages/f1/0f/cd9b3e495e514441e9af3a42c5c63436aee620f61412cafcce67e259228b/uuid_utils-0.19.0.tar.gz"
    sha256 "4b2996bb9d12da9b62f6f4c64a066b26926fa75dbe47b4f8e309e24e187abf1d"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/75/79/590c5f0cc7d1661195aeefccb0e342b79f4c77d368d526d028821a390332/websockets-17.4.tar.gz"
    sha256 "09d3939b70df0c8ad2da145ebd50978bccaee1d565e838b0e7921a34d38571eb"
  end

  resource "xxhash" do
    url "https://files.pythonhosted.org/packages/c9/b5/3d11d3830ace56d67ea83136c24385c3b07da5a9bc62b73b0b94ac096da3/xxhash-4.1.0.tar.gz"
    sha256 "c9b288e4c1f5dae54417bc8a05e6f6daf505783d916b4783f4dd2f2e7d5db486"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/fd/aa/3e0508d5a5dd96529cdc5a97011299056e14c6505b678fd58938792794b1/zstandard-0.25.0.tar.gz"
    sha256 "7713e1179d162cf5c7906da876ec2ccb9c3a9dcbdffef0cc7f70c3667a205f0b"
  end

  def install
    ENV["XXHASH_LINK_SO"] = "1"
    venv = virtualenv_install_with_resources without: "zstandard"

    resource("zstandard").stage do
      args = std_pip_args(prefix: false, build_isolation: true)
      args << "--config-settings=--build-option=--system-zstd"
      system venv.root/"bin/python", "-m", "pip", "install", *args, "."
    end

    generate_completions_from_executable(bin/"langgraph", shell_parameter_format: :click)
  end

  test do
    (testpath/"graph.py").write <<~PYTHON
      from langgraph.graph import StateGraph
      builder = StateGraph(list)
      builder.add_node("anode", lambda x: ["foo"])
      builder.add_edge("__start__", "anode")
      graph = builder.compile()
    PYTHON

    (testpath/"langgraph.json").write <<~JSON
      {
        "graphs": {
          "agent": "graph.py:graph"
        },
        "env": {},
        "dependencies": ["."]
      }
    JSON

    system bin/"langgraph", "dockerfile", "DOCKERFILE"
    assert_path_exists "DOCKERFILE"
    dockerfile_content = File.read("DOCKERFILE")
    assert_match "FROM", dockerfile_content, "DOCKERFILE should contain 'FROM'"
  end
end
