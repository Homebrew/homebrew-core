class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https://www.github.com/langchain-ai/langgraph"
  url "https://files.pythonhosted.org/packages/94/2a/b5d51df0db49bf5dc8860f6f66605ff2f44da664d645b6287ceb24223df4/langgraph_cli-0.4.11.tar.gz"
  sha256 "c38c531510ace1c2d90f8a15f4bb5b874ca9d07c0564cbda7590730da2b0dff3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c00989174774e91133bcd7a5443ab2747ee1df7524dc4c1ceeb5730ddcfb94fd"
    sha256 cellar: :any,                 arm64_sequoia: "bda8f2eef679c74de02152ac0b3e4042d43f10c0dbf58123edfc5666ba958d23"
    sha256 cellar: :any,                 arm64_sonoma:  "c8a894a3f3bd49b0756f6f9b4823b105a0563581f24feec0e2a33dad7e911fed"
    sha256 cellar: :any,                 sonoma:        "939fee87494baa64e891efa593205ad3f7bdb9e7c77e0435716c7adea2116c2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b002310177b783d6e2f1656612b6a44d7c43df49de64337484fd78eecd5e1481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d955cf16d0e6963a77dc54f8196b859fb77c693304a4c0fd472d8d4ecff785eb"
  end

  depends_on "rust" => :build # for orjson
  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/16/ce/8a777047513153587e5434fd752e89334ac33e379aa3497db860eeb60377/anyio-4.12.0.tar.gz"
    sha256 "73c693b567b0c55130c104d0b43a9baf3aa6a31fc6110116509f27bf75e21ec0"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
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
    url "https://files.pythonhosted.org/packages/2b/1b/f328afb4f24f6e18333ff357d9580a3bb5b133ff2c7aae34fef7f5b87f31/langgraph_sdk-0.3.0.tar.gz"
    sha256 "4145bc3c34feae227ae918341f66d3ba7d1499722c1ef4a8aae5ea828897d1d4"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/04/b8/333fdb27840f3bf04022d21b654a35f58e15407183aeb16f3b41aa053446/orjson-3.11.5.tar.gz"
    sha256 "82393ab47b4fe44ffd0a7659fa9cfaacc717eb617c93cde83795f14af5c2e9d5"
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
