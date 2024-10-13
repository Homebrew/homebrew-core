class ActionValidator < Formula
  desc "Tool to validate GitHub Action and Workflow YAML files"
  homepage "https://github.com/mpalmer/action-validator"
  license "GPL-3.0-only"

  stable do
    url "https://github.com/mpalmer/action-validator/archive/refs/tags/v0.6.0.tar.gz"
    sha256 "bdec75f6383a887986192685538a736c88be365505e950aab262977c8845aa88"

    # always pull the HEAD commit hash
    resource "schemastore" do
      url "https://github.com/SchemaStore/schemastore.git",
          revision: "7bf746bd90d7e88cd11f0a9dc4bc34c91fbbf7b4"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "217670580f0191e931fb0881a7aeef50e1077537a2305e74de8c1b6960216871"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "347c3544b0c5726c557d949e4169d7e31e8e9b6ddb8d10fe30cd763dc7df030f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d788de5edb5dcc71093119528a77e9cdbfe62a3de062e42f437057c7c46d70b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70fad7c8608b4e2ed2940a68b94a527cc609c279a422c326c18fae57e20095bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2c2aa5d31932a9b2e40c136da4608b0db775aa60b730b70131ee7f1a81cf9ad"
    sha256 cellar: :any_skip_relocation, ventura:        "36815305c61bb8943c8393f98dcf53495ce9164a736108ca97aee7c70c57342f"
    sha256 cellar: :any_skip_relocation, monterey:       "8e6f2d8e17962160c4b61ce9401decef9dc6d062a3da67838192e9d185277a65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "151521ccea42db3b37dcd607c8fa70bf3b974d6fe03050ec0538c8ecea4d6c49"
  end

  head do
    url "https://github.com/mpalmer/action-validator.git", branch: "main"

    resource "schemastore" do
      url "https://github.com/SchemaStore/schemastore.git", branch: "master"
    end
  end

  depends_on "rust" => :build

  def install
    (buildpath/"src/schemastore").install resource("schemastore")

    system "cargo", "install", *std_cargo_args
  end

  test do
    test_action = testpath/"action.yml"
    test_action.write <<~EOS
      name: "Brew Test Action"
      description: "Test Action"
      inputs:
        test:
          description: "test input"
          default: "brew"
      runs:
        using: "node20"
        main: "index.js"
    EOS

    test_workflow = testpath/"workflow.yml"
    test_workflow.write <<~EOS
      name: "Brew Test Workflow"
      on: [push111]
      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v4
    EOS

    output = shell_output("#{bin}/action-validator --verbose #{test_action}")
    assert_match "Treating action.yml as an Action definition", output

    output = shell_output("#{bin}/action-validator --verbose #{test_workflow} 2>&1", 1)
    assert_match "Fatal error validating #{test_workflow}", output
    assert_match "Type of the value is wrong", output
  end
end
