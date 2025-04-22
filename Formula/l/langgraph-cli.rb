class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https://www.github.com/langchain-ai/langgraph"
  url "https://files.pythonhosted.org/packages/ab/bc/186b9445d5baea49b5a07bcaf45ad02e9508a3f5e32098fe51a77e8a7abe/langgraph_cli-0.2.5.tar.gz"
  sha256 "bd21b0fd4078c33ee8b51025d21f3f4fd78afddbba8bc99f2b13e1d176e1a0c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9692d331b507fa9eddbb57e5346c1f9b5893eacac414bb590b6c8ca99cc51b55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9692d331b507fa9eddbb57e5346c1f9b5893eacac414bb590b6c8ca99cc51b55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9692d331b507fa9eddbb57e5346c1f9b5893eacac414bb590b6c8ca99cc51b55"
    sha256 cellar: :any_skip_relocation, sonoma:        "70f418b32da8d9d1a07dab0f1f4b8041070baee5c713ce8a82e5f85a33204520"
    sha256 cellar: :any_skip_relocation, ventura:       "70f418b32da8d9d1a07dab0f1f4b8041070baee5c713ce8a82e5f85a33204520"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9692d331b507fa9eddbb57e5346c1f9b5893eacac414bb590b6c8ca99cc51b55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9692d331b507fa9eddbb57e5346c1f9b5893eacac414bb590b6c8ca99cc51b55"
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
