class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https://www.github.com/langchain-ai/langgraph"
  url "https://files.pythonhosted.org/packages/85/b2/6cbdea914fa0f9d125884aab3af4fb4405785bf65a9a378cd0869f39d9d6/langgraph_cli-0.2.8.tar.gz"
  sha256 "9091aa12bf826572446cb5564604a8a6f750c9dcaa0cd9fb1067128a53ac2282"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b241fddc959b0db1e894b11bda211e720f4ba42833efcec531613cfacf433043"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b241fddc959b0db1e894b11bda211e720f4ba42833efcec531613cfacf433043"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b241fddc959b0db1e894b11bda211e720f4ba42833efcec531613cfacf433043"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfb8aa3486a2aeee634d885b06bbdadf2daf2da6c7b00071cb3bb1c9e947e4a1"
    sha256 cellar: :any_skip_relocation, ventura:       "cfb8aa3486a2aeee634d885b06bbdadf2daf2da6c7b00071cb3bb1c9e947e4a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b241fddc959b0db1e894b11bda211e720f4ba42833efcec531613cfacf433043"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b241fddc959b0db1e894b11bda211e720f4ba42833efcec531613cfacf433043"
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
