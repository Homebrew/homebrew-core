class ActionValidator < Formula
  desc "Tool to validate GitHub Action and Workflow YAML files"
  homepage "https://github.com/mpalmer/action-validator"
  # Using crates.io source as it includes schemastore submodule code
  url "https://static.crates.io/crates/action-validator/action-validator-0.9.0.crate"
  sha256 "e379b5be9a8a4659aaec855a3321e40d98c5216d6191bc362a24d5b605a2cbcb"
  license "GPL-3.0-only"
  head "https://github.com/mpalmer/action-validator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12edda1e1aa6916ec8afaab4e068395e3ec81d2ff319ef572fe2c4187309470d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6166f38a0e059a1a1d8c28ba7aee2656e9769182add2154703f636fee323a4cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14ab16254be123c6604ed9127ec2290858c83b338779f867e073c18646e8f931"
    sha256 cellar: :any_skip_relocation, sonoma:        "543d0e8f0e3a0fa20b7b1ded901d0112c4e2f52fb3e46400dca43b2d11e627d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e50f6621e00aa7e515d73a7765296a05c8fb0882734224c6fcc103d72a5fb9aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8f9021532e74756bad01482d0d435e1ec420429521c27c5c06e243c2108e3f5"
  end

  depends_on "rust" => :build

  def install
    ENV["GEN_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_action = testpath/"action.yml"
    test_action.write <<~YAML
      name: "Brew Test Action"
      description: "Test Action"
      inputs:
        test:
          description: "test input"
          default: "brew"
      runs:
        using: "node20"
        main: "index.js"
    YAML

    test_workflow = testpath/"workflow.yml"
    test_workflow.write <<~YAML
      name: "Brew Test Workflow"
      on: [push111]
      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/action-validator --verbose #{test_action}")
    assert_match "Treating action.yml as an Action definition", output

    output = shell_output("#{bin}/action-validator --verbose #{test_workflow} 2>&1", 1)
    assert_match "Fatal error validating #{test_workflow}", output
    assert_match "Type of the value is wrong", output
  end
end
