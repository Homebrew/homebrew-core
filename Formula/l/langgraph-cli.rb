class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https://www.github.com/langchain-ai/langgraph"
  url "https://files.pythonhosted.org/packages/aa/73/c581ff48ea039404619f56e0628eaa0e5327d9bee43ff2d3ae579b231d06/langgraph_cli-0.4.7.tar.gz"
  sha256 "51dc5c7bfd0ce957162facea5ef93ffe9778e8d9ec993354f19aec9dd0161470"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "717001cba8611ddcf026258f7bb335b09a21a915ae63c00b430d016e8222db23"
    sha256 cellar: :any,                 arm64_sequoia: "8bc6e70d0178cf8bc4a5ef01c96f84ae33911e56d6214a8cf29ddd741947aa8d"
    sha256 cellar: :any,                 arm64_sonoma:  "7e19faa2c9f4f453f9004da2f7bc13c4b1039205545308a3dd543dc5d8d1b399"
    sha256 cellar: :any,                 sonoma:        "6ef3b428b051ed1208896fa2e09bc3e12edc96562397353aafca0c0078b5c03c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c63b9335e26ed0e9b13be7ef1e4e546a4943ef57484d705fa22e72fd9065bbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fed6e371a32ec562eb7d7f68f275ae7a7088e6645b7fb753bd029f179ee14e1"
  end

  depends_on "rust" => :build # for orjson
  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/c6/78/7d432127c41b50bccba979505f272c16cbcadcc33645d5fa3a738110ae75/anyio-4.11.0.tar.gz"
    sha256 "82a8d0b81e318cc5ce71a5f1f8b5c4e63619620b63141ef8c995fa0db95a57c4"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
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

  resource "langgraph-sdk" do
    url "https://files.pythonhosted.org/packages/23/d8/40e01190a73c564a4744e29a6c902f78d34d43dad9b652a363a92a67059c/langgraph_sdk-0.2.9.tar.gz"
    sha256 "b3bd04c6be4fa382996cd2be8fbc1e7cc94857d2bc6b6f4599a7f2a245975303"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/c6/fe/ed708782d6709cc60eb4c2d8a361a440661f74134675c72990f2c48c785f/orjson-3.11.4.tar.gz"
    sha256 "39485f4ab4c9b30a3943cfe99e1a213c4776fb69e8abd68f66b83d5a0b0fdc6d"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  def install
    virtualenv_install_with_resources

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
