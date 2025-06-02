class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https://www.github.com/langchain-ai/langgraph"
  url "https://files.pythonhosted.org/packages/8d/5e/b12bc8140cd4f797ad7f596bf90558994fd6891df8974bc3fc4747eabdc7/langgraph_cli-0.2.10.tar.gz"
  sha256 "0c215b364daeaf10de681e4960ecaafc7c9cd2a4100b41052d78d95cababf422"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07a250dd1c29400cfef5c7da506224617b487ff1beeabc0c5832157036456a8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07a250dd1c29400cfef5c7da506224617b487ff1beeabc0c5832157036456a8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07a250dd1c29400cfef5c7da506224617b487ff1beeabc0c5832157036456a8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "25c261b92fc1711046a983453b8af2bd1ccec43724e591ce93c226f532ec6ca8"
    sha256 cellar: :any_skip_relocation, ventura:       "25c261b92fc1711046a983453b8af2bd1ccec43724e591ce93c226f532ec6ca8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07a250dd1c29400cfef5c7da506224617b487ff1beeabc0c5832157036456a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07a250dd1c29400cfef5c7da506224617b487ff1beeabc0c5832157036456a8e"
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
