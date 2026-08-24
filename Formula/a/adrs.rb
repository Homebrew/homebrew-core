class Adrs < Formula
  desc "Architectural Decision Record tool in Rust"
  homepage "https://joshrotenberg.com/adrs/"
  url "https://github.com/joshrotenberg/adrs/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "b609798f653c9360782d522bd2103dde1a4268b5248637c26f7406e0c9c85526"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/joshrotenberg/adrs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "110097fe1ffe798286c6afaf77b7e82735f651dc2cf876c1789d66ada2553b5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3c01d6b208c1c6670d748738d7e040bc60873928a437a002627f04b48162d3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a27d02f232e8f125b4df8b36f1ea05371ea0f1ae04fa697a3b95b56f37ff09f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9db659e9cc91449b7742d14964b92a7410d4f111ab8255c0fe254a3010f36015"
    sha256 cellar: :any,                 arm64_linux:   "af178dfa47d4b531b0808e830dd834da55b53f789d65f11fa63dc49530c362a4"
    sha256 cellar: :any,                 x86_64_linux:  "ff9db01d8a768304e48bf8b4591b52d1e2d62d699282ab2fcb4cc2d19d9fc4ca"
  end

  depends_on "rust" => :build

  deny_network_access! [:postinstall, :test]

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
