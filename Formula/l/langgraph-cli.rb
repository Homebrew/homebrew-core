class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https://www.github.com/langchain-ai/langgraph"
  url "https://files.pythonhosted.org/packages/08/04/0764d07b1c5601cdb73f6949fab80ce867983684d024f3de48cce1d8aba2/langgraph_cli-0.4.12.tar.gz"
  sha256 "7aa6ca37d6f60c75f2ea310f4cae233f59fe0026e5ef43dab34c04d1cb61c7a6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6e086e899704421dc025c4406b7a56a42dff0b3ca62f550785cb745000afbb7d"
    sha256 cellar: :any,                 arm64_sequoia: "f9b6838f85b9b5a3ac0eb545d439c38b9dc19c34ae9f5a3682ccdba01942d348"
    sha256 cellar: :any,                 arm64_sonoma:  "532191a179fb40feffc343698578d801f5505539d387f4e8bf80232190d78207"
    sha256 cellar: :any,                 sonoma:        "4368812c75eba029edd37ca8e0e26a646688ec083d7d88946a5e1b5a859f9316"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c4ea5ce3891212aabdaee8b6c1b78ada0068ee752fb21c8e4f100c9607c23b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0522212faec929604844b72fb1d9ac5a9b678e3080ab9752ea846e5cf8ce60b8"
  end

  depends_on "rust" => :build # for orjson
  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/96/f0/5eb65b2bb0d09ac6776f2eb54adee6abe8228ea05b20a5ad0e4945de8aac/anyio-4.12.1.tar.gz"
    sha256 "41cfcc3a4c85d3f05c932da7c26d0201ac36f72abd4435ba90d0464a3ffed703"
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
    url "https://files.pythonhosted.org/packages/c3/0f/ed0634c222eed48a31ba48eab6881f94ad690d65e44fe7ca838240a260c1/langgraph_sdk-0.3.3.tar.gz"
    sha256 "c34c3dce3b6848755eb61f0c94369d1ba04aceeb1b76015db1ea7362c544fb26"
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
