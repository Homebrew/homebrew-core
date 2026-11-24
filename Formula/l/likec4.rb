class Likec4 < Formula
  desc "Architecture modeling tool with live diagrams from code"
  homepage "https://likec4.dev"
  url "https://registry.npmjs.org/likec4/-/likec4-1.61.1.tgz"
  sha256 "5d778c7adf94c81deef7c586c5585bfea9bf7a75478547cc80dfae5aa58f16ca"
  license "MIT"

  bottle do
    manifest_sha256 "379a8ef640abc96468593842796194555ba7fe87986833686da0fa771bc105db"
    sha256 cellar: :any,                 arm64_golden_gate: "da03e66527c4acd001aff966b682f6837db125a07e5c484bae098c35644ec1eb"
    sha256 cellar: :any,                 arm64_tahoe:       "da03e66527c4acd001aff966b682f6837db125a07e5c484bae098c35644ec1eb"
    sha256 cellar: :any,                 arm64_sequoia:     "da03e66527c4acd001aff966b682f6837db125a07e5c484bae098c35644ec1eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "684be4547db5cd7adfc63d24db64297467caec0addd1aa04ffb0d31c87371248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0d88f1bdbbaeb9983b7f94a048e6695e687210c254f12665c73fcf126f55b9d7"
  end

  depends_on "graphviz"
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"likec4", "completion", shells: [:bash, :zsh])

    deuniversalize_machos if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/likec4 --version")

    (testpath/"test.c4").write <<~C4
      specification {
        element system
        element component
      }
      model {
        sys = system 'Test System' {
          api = component 'API'
          db = component 'Database'
        }
        api -> db 'queries'
      }
      views {
        view index {
          include *
        }
      }
    C4

    system bin/"likec4", "validate", testpath

    system bin/"likec4", "export", "json", "-o", testpath/"output.json", testpath
    json_output = JSON.parse((testpath/"output.json").read)
    assert json_output.key?("views"), "Expected JSON export to contain views"
    assert json_output.key?("elements"), "Expected JSON export to contain elements"

    system bin/"likec4", "gen", "mermaid", "-o", testpath/"output", testpath
    assert_path_exists testpath/"output"
    mermaid_files = Dir[testpath/"output/**/*.mmd"]
    assert mermaid_files.any?, "Expected at least one .mmd file to be generated"
  end
end
