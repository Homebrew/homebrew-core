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

    # shell completion and manpage support, upstream pr ref, https://github.com/mpalmer/action-validator/pull/82
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/ffcaead14f73c08531313dcb7c300918db576c3b/action-validator/0.6.0-completion-manpage.patch"
      sha256 "91b0f5170e52537f78e4b196e3b3dd580e3e56e6479f14ba59cdfcff556f4680"
    end
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2648c46a07251127841f4f96faf5cf42abf24d46346190aa7d7469f410fe107"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b9ea08105457a87d1571d8f8ab8c0309f198cbb1d39961fb4b6091f14f08239"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b19fed4dbbcd2f0b0e6b702a10a26a3dbd1ca84040008e26a733076adba004a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f065ef1e7dda660200a3f90f8c369dc60e36c5c4e9d2d2823373807440e62eb9"
    sha256 cellar: :any_skip_relocation, ventura:       "f162d3f6739bf01635bf4ca4287cae32c5b73da5a039bcf27a73e6a006ad81ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36f73c23f728058252e3f23614d34da1488470a4af9261d4718f7edb4b6fad18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07824bb882abb54d58d5ad90fa6987a363cfe474b2a5f5647153284244e232a1"
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

    bash_completion.install "completions/action-validator.bash" => "action-validator"
    fish_completion.install "completions/action-validator.fish"
    zsh_completion.install "completions/_action-validator"
    man1.install "man/action-validator.1"
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
