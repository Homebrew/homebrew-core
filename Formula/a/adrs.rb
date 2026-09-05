class Adrs < Formula
  desc "Architectural Decision Record tool in Rust"
  homepage "https://joshrotenberg.com/adrs/"
  url "https://github.com/joshrotenberg/adrs/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "f8c66465ba16f8f28f5123c59a365b5b08ebb02ef6918e1e9c003bd822989bd9"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/joshrotenberg/adrs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea2c0f491539b3b2af9d2dd7f13c5966566ac916f61518a4ae424eb73fcb79f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20aa317e45b40c32168842ef9125a3720e5432066f157a51992403c8dff8cd6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a08a1893db70f4958c138f1d119d82daafc7d5c391b5ff7f99785f3591b07edc"
    sha256 cellar: :any,                 arm64_linux:   "560007d9abbbe8a85c5980122d58eaa69d45be0982f0dad2a1a6796c886dd453"
    sha256 cellar: :any,                 x86_64_linux:  "8039eb4148b671acda2e31f37302166ceba9521f725ea046476efbd31acdc94a"
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
