class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https://www.github.com/langchain-ai/langgraph"
  url "https://files.pythonhosted.org/packages/f3/88/d37da5787048b4f964ee841da42abab0b4b1a1b93fc2bcecb8cb98efda0a/langgraph_cli-0.1.68.tar.gz"
  sha256 "03916187041c5aee7826898657d91de4ad0699fc753b512bb658690b6cfe5b90"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c596ce28b4df02d09e2138a37a9963ccaf37ec7acf4fb671b096b05e5d36d6b4"
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
