class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https://www.github.com/langchain-ai/langgraph"
  url "https://files.pythonhosted.org/packages/86/f1/598f9e1784432d790a937de4c466ba8bed3d18ef6f56fe7394af6bc1f175/langgraph_cli-0.4.2.tar.gz"
  sha256 "074d93a2ebb9c60629a83bc4c149e837bd09e51222d48daacb498299d818ee9f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "07cf0151669ad29fd6dd0afcdfb634bb7a6212fd6a91dd798095817a7b67fffd"
    sha256 cellar: :any,                 arm64_sequoia: "7921e6376894243ee67572135470c67db2ecb3db4a9258f2bdc31d69a6c89576"
    sha256 cellar: :any,                 arm64_sonoma:  "a18c59d333aa4460c4305fd4a8d3509583eea47bc361260514f951105f57f504"
    sha256 cellar: :any,                 arm64_ventura: "9331169259bc9d532c689b7cbb729810a86faad5708bf4093702714d7c11609a"
    sha256 cellar: :any,                 sonoma:        "3d76c32a5a768bf8cf74a3348ff0f9a80111f7fcaed3743aaf1d0d81a86f3732"
    sha256 cellar: :any,                 ventura:       "393a1bc7cbd78bfa746c4be1eab0125ebae27d3957428a35b94ac05dd8e69047"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d06c760d92f1fe52c7d56d77d865554e4bf228c2f9537bcc8011a0dd9596898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "834e89cf4d461afdd6fe06341168b03680a636193aecf1620ddfc2b977bce8f1"
  end

  depends_on "rust" => :build # for orjson
  depends_on "python@3.13"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/f1/b4/636b3b65173d3ce9a38ef5f0522789614e590dab6a8d505340a4efe4c567/anyio-4.10.0.tar.gz"
    sha256 "3f3fae35c96039744587aa5b8371e7e8e603c0702999535961dd336026973ba6"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/dc/67/960ebe6bf230a96cda2e0abcf73af550ec4f090005363542f0765df162e0/certifi-2025.8.3.tar.gz"
    sha256 "e564105f78ded564e3ae7c923924435e1daa7463faeab5bb932bc53ffae63407"
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
    url "https://files.pythonhosted.org/packages/55/35/a1caf4fdb725adec30f1e9562f218524a92d8b675deb97be653687f086ee/langgraph_sdk-0.2.6.tar.gz"
    sha256 "7db27cd86d1231fa614823ff416fcd2541b5565ad78ae950f31ae96d7af7c519"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/be/4d/8df5f83256a809c22c4d6792ce8d43bb503be0fb7a8e4da9025754b09658/orjson-3.11.3.tar.gz"
    sha256 "1c0603b1d2ffcd43a411d64797a19556ef76958aef1c182f22dc30860152a98a"
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
