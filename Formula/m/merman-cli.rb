class MermanCli < Formula
  desc "Mermaid.js, but headless, in Rust"
  homepage "https://frankorz.com/merman/"
  url "https://github.com/Latias94/merman/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "2a0ac43e793446215d6f0ab0efdd1850eb8faeb460cc9a7ab89a9e7079b928a4"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b3d94446d385a61a166d48bd5a00b19522b2cb5cac6a212003f558c75033b86c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dcec18f2aa4e63d743cfa7a7922b99bd768a4422ae11d7125247399091184ba1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9a57d3ca85a04ab78560c8fc6ddda1b69de1ced65005670f1571564969edd01f"
    sha256 cellar: :any,                 arm64_linux:       "7b8f8086f3ae930f0939301b6eba5460dbdaade0d8ad6f567e440a6e1a363e6f"
    sha256 cellar: :any,                 x86_64_linux:      "a218ddd04cfb83302fa705303ad99ee73c4009c3fdc85bd6826d96b5b14e59b2"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/merman-cli")

    generate_completions_from_executable(bin/"merman-cli", "completion", shells: [:bash, :zsh, :fish, :pwsh])
    man1.install Dir["crates/merman-cli/assets/man/*.1"]
  end

  test do
    mermaid = <<~MMD
      flowchart TD
        A[Start] --> B{Decision}
        B -->|Yes| C[Do thing]
        B -->|No| D[Do other thing]
    MMD
    testdata = testpath/"sample.mmd"
    testdata.write(mermaid)
    assert_match "svg", shell_output("#{bin}/merman-cli render --format svg --output - #{testdata}")
  end
end
