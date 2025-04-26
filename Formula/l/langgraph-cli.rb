class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https://www.github.com/langchain-ai/langgraph"
  url "https://files.pythonhosted.org/packages/fc/31/6461860062057b1ab65b853d38ada74b193f38e7ae06bcfba74b2079f29e/langgraph_cli-0.2.7.tar.gz"
  sha256 "6e4c6a3029d2768acfd1c8216fae99259202d0304174c5adcc128e8f8930812c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f47a578d36978b020a16c39d8c188ab6c805c1034f60357ffd32f621f1b43611"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f47a578d36978b020a16c39d8c188ab6c805c1034f60357ffd32f621f1b43611"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f47a578d36978b020a16c39d8c188ab6c805c1034f60357ffd32f621f1b43611"
    sha256 cellar: :any_skip_relocation, sonoma:        "121b96085daf821597772a7abc769a44cca09cbc1e21de9d4d63b06471231224"
    sha256 cellar: :any_skip_relocation, ventura:       "121b96085daf821597772a7abc769a44cca09cbc1e21de9d4d63b06471231224"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f47a578d36978b020a16c39d8c188ab6c805c1034f60357ffd32f621f1b43611"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f47a578d36978b020a16c39d8c188ab6c805c1034f60357ffd32f621f1b43611"
  end

  depends_on "python@3.13"

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  def install
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
