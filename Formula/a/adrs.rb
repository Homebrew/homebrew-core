class Adrs < Formula
  desc "Architectural Decision Record tool in Rust"
  homepage "https://joshrotenberg.com/adrs/"
  url "https://github.com/joshrotenberg/adrs/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "25490a7a205afd9a9c6b65c31011984a6594f8f7c8b61d28220903fcfd25ec24"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/joshrotenberg/adrs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "170183456bc2c7954d8bbc69e88103b9b7cee394dfaf74477fd9cfaf785f4d2f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "70961f29588ff096b94de221c6f75c5e226e5bab5c0c53c7792022522edb778e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4f876dc19293d4771888e5814c0a618e3a51ab0730c50e39737616c5684915e6"
    sha256 cellar: :any,                 arm64_linux:       "bde4c1165336591332d41050e8e204c2c8637bd0d47107615721d177167a5157"
    sha256 cellar: :any,                 x86_64_linux:      "a051d5b9003ae0a33dfd9166584f58f8d9b6b1d0a50ca65c306108283d3d0c7c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/adrs")
    generate_completions_from_executable(bin/"adrs", "completions")
  end

  test do
    # Exercise `adrs doctor` as a CI lint gate: it exits 0 for advisory findings
    # and non-zero for structural errors. Drive a sample ADR through the
    # advisory path — ADR014 (advisory: placeholder text left in a fresh template)
    system bin/"adrs", "init", "docs/decisions"

    # init seeds a Nygard-format ADR; drop it so the demo below is MADR-only.
    (testpath/"docs/decisions/0001-record-architecture-decisions.md").unlink

    system bin/"adrs", "new", "--format", "madr", "--no-edit",
           "Use Homebrew for software installation"
    assert_match "ADR014", shell_output("#{bin}/adrs doctor")

    assert_match version.to_s, shell_output("#{bin}/adrs --version")
  end
end
