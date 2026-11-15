class MermanCli < Formula
  desc "Mermaid.js, but headless, in Rust"
  homepage "https://frankorz.com/merman/"
  url "https://github.com/Latias94/merman/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "4a213990d7b329e1ddb7de5710cc4530a505f967d148afd54b9d3741ca15f3b9"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a64d376bab9ed3d8fa14e09f1457b062ad9377d997cbafa3adabd9cc04a9ba9d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "428762d59fd47abc4714acd42ccd15b57c577544bb29b2eb2ea072aaa19a6a35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e3eca9ef714367cd51f2cfc2914151c6afc22d45308204256b018fbd5f5aaf04"
    sha256 cellar: :any,                 arm64_linux:       "4fbcad46a21d660434a2a6cc56c0f756da4fe8014cb773bb1835c44b72bb310b"
    sha256 cellar: :any,                 x86_64_linux:      "145eb6dc7f7552c7c2374571d300325198f2bf8510f0351091f41a42b475355a"
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
