class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https://www.github.com/langchain-ai/langgraph"
  url "https://files.pythonhosted.org/packages/ae/d9/43f4c5083a9be70edf2add6d46c20bf8f6b69fca55d9e61a42ccd846886d/langgraph_cli-0.4.18.tar.gz"
  sha256 "843f5990c18e425924b7fe34a164a13fb902d29ac92ceda9d21aa4b56057a91e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e0a202ddb18360d46856fbf6d9fa24a047b287ca551c38f3f5b84d1b28ee6631"
    sha256 cellar: :any,                 arm64_sequoia: "faba20bf4e619ff030424ef7575b93ee4ce73229043ed815d1d4301240cb5dfd"
    sha256 cellar: :any,                 arm64_sonoma:  "b2b70566fd7c54f4a72acd4a61a7a4045d62119e72f511e8affa70e551428947"
    sha256 cellar: :any,                 sonoma:        "44a66177234be4860459b686baf0034caedec15ad392d09fd80f34e5107d6ec6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd667bc798f3d43b36adb7ff93a0733c50e335271fa6addbf0e40624be31fda0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea0082ab44ed997bae52f77683767bd6c60e7d82d682f831ab556a3edc438d03"
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
    url "https://files.pythonhosted.org/packages/35/cd/a019f1b1e97c519f2425593f9bccd3ac463a18fb5d2111cff59ce1ef62fe/langgraph_sdk-0.3.11.tar.gz"
    sha256 "3640134835d89d2c7c8bb7de73bd10673d4b282db3ff0e2fdaf1cee9e50cb1eb"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/53/45/b268004f745ede84e5798b48ee12b05129d19235d0e15267aa57dcdb400b/orjson-3.11.7.tar.gz"
    sha256 "9b1a67243945819ce55d24a30b59d6a168e86220452d2c96f4d1f093e71c0c49"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
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
