class MermanCli < Formula
  desc "Mermaid.js, but headless, in Rust"
  homepage "https://frankorz.com/merman/"
  url "https://github.com/Latias94/merman/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "a2954c33ec9cfe1bcff8785fcb2d12e29c988075c6d5a3b962187f1665f3c373"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    manifest_sha256 "eeb93675c0c0ca36f34bb74aef8810ab83f9d0cfdeea7fba39272a23c9f17d19"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fae94fc4908e7371a6b1e1bcfee2b665cdb78c30fcf92468049a063217aa5587"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "754b137459f571d9d7ebfdf4dafb56b69686679eee7265364f804d81d681861c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b697a175675c84900d5b180e03e093d135a9b2c3696530bf280977852b5a0a94"
    sha256 cellar: :any,                 arm64_linux:       "8d7b2a33f6614721dfc63b50926d1894da2dd5c809afe6413935248e2d1ae31e"
    sha256 cellar: :any,                 x86_64_linux:      "aabe6cdce05dac6d0b15eeafb611d53b5d3b5e3df55f1d1442539a95968ab83f"
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
