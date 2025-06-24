class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https://www.github.com/langchain-ai/langgraph"
  url "https://files.pythonhosted.org/packages/f0/c2/53aaae208a3a08f727ef9d03edfd8f499403e017fc451c8ca5b52e95c930/langgraph_cli-0.3.3.tar.gz"
  sha256 "120adc44064786bb11f1376a7b324b2125276a2e2c3a04bbfab7b8c1622ad4d7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0c337ec1f2313eeea92353e45f016b050aaa8b61086d4180102fd6a9394e24a5"
    sha256 cellar: :any,                 arm64_sonoma:  "7313d3d95934df27276303d5b14bffca4399261c093fec4c6d830f02f4768928"
    sha256 cellar: :any,                 arm64_ventura: "92514486b663d6fa03ace892975fcbccf54d2d678beb1f660a6668e53fb16360"
    sha256 cellar: :any,                 sonoma:        "5cd5c362eb4a354cebc473047007d1844294127445665c6055da89bfa5f3bd8a"
    sha256 cellar: :any,                 ventura:       "0939c84dfcbfed14b9cbdb6a63b7517160d2073687b5ffa36bba74f382885c3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffb9a63ad3e2f498fb6bf8a8104953b4af89eb8754602681773dde91732fc59e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f90ae17f8ef6a8c54a7a3d030c499ed97f693fdf1ce37474d59847e169d5956f"
  end

  depends_on "maturin" => :build # for orjson
  depends_on "python@3.13"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/95/7d/4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840/anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/e8/9e/c05b3920a3b7d20d3d3310465f50348e5b3694f4f88c6daf736eef3024c4/certifi-2025.4.26.tar.gz"
    sha256 "0a816057ea3cdefcef70270d2c515e4506bbc954f417fa5ade2021213bb8f0c6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
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
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "langgraph-sdk" do
    url "https://files.pythonhosted.org/packages/c1/dd/c074adf91d2fe67f00dc3be4348119f40a9d0ead9e55c958f81492c522c0/langgraph_sdk-0.1.70.tar.gz"
    sha256 "cc65ec33bcdf8c7008d43da2d2b0bc1dd09f98d21a7f636828d9379535069cf9"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/81/0b/fea456a3ffe74e70ba30e01ec183a9b26bec4d497f61dcfce1b601059c60/orjson-3.10.18.tar.gz"
    sha256 "e8da3947d92123eda795b68228cafe2724815621fe35e8e320a9e9593a4bcd53"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  def install
    # Prevent maturin from automatically installing Rust toolchains
    ENV["MATURIN_NO_INSTALL_RUST"] = "1"

    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"langgraph", shells: [:fish, :zsh], shell_parameter_format: :click)
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
