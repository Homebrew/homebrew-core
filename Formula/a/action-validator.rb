class ActionValidator < Formula
  desc "Tool to validate GitHub Action and Workflow YAML files"
  homepage "https://github.com/mpalmer/action-validator"
  license "GPL-3.0-only"

  stable do
    url "https://github.com/mpalmer/action-validator/archive/refs/tags/v0.8.0.tar.gz"
    sha256 "2a75ecde0a5e58b525623db1f270f7d0153e3707d3ad87adee73fd4ef6adeac6"

    # always pull the HEAD commit hash
    resource "schemastore" do
      url "https://github.com/SchemaStore/schemastore.git",
          revision: "d94af770cffaa34559f5279acbcc3a548bb0ea8c"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fca02f94098fb5318e9cf6a729e498a08788e7d165895f5dddfa321781d606a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c634f2face2954fa059011d97fd132eaa440aa712982913470b009a279384bd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e382a477d0f3078fd02333b9d333d6ee76405cd318d3c7f983732f0da2ff774"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "470f7ae27fb3bce14d1bcdee86558a353eb3fc847fc3e70c2b856177c7c24735"
    sha256 cellar: :any_skip_relocation, sonoma:        "728921173c7f6ec599d088e865b7db2e85de594dacf69961310b44462d54fc25"
    sha256 cellar: :any_skip_relocation, ventura:       "a6835560feda32a13dc86443867887fce516f7025cd8045e42de6ba8273047b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0541c834ef9cd4fc192f3babc34741dde6e5c0d428dc4266238a1072e13760de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94e49dda6b381d74167f63da53903bf8a3e7b243d456eeb6d305b91b1ec43d10"
  end

  head do
    url "https://github.com/mpalmer/action-validator.git", branch: "main"

    resource "schemastore" do
      url "https://github.com/SchemaStore/schemastore.git", branch: "master"
    end
  end

  depends_on "rust" => :build

  def install
    ENV["GEN_DIR"] = buildpath

    (buildpath/"src/schemastore").install resource("schemastore")

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
