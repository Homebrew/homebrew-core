class Adrs < Formula
  desc "Architectural Decision Record tool in Rust"
  homepage "https://joshrotenberg.com/adrs/"
  url "https://github.com/joshrotenberg/adrs/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "7f230f62d165a39af7d27eb631568ede659ebf8988b913fbfe80ff0a286dbb1a"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/joshrotenberg/adrs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25a8d71cdc87d5d3792f88d6344b4a38fab55382b8c8100dd3aca8bce438c881"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af435878d082dba204060157a50ac6a641dfbb9c716736b852d4083d8606869e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7add0f6863ddd48b4e4e5005ea83c7fcfde18514226aab7f524deed3b1df2096"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6cee37fb358e7389f884497a52ef755baa1d2203c364e0def0530c9d0df2e23"
    sha256 cellar: :any,                 arm64_linux:   "44f77564216bfbb72de0ab368ff934257a53a5d80dded67befc2ceee11978324"
    sha256 cellar: :any,                 x86_64_linux:  "e9ac2898367b53e304f8ad1fb59d07fda48af45a13284680b00b79697857a386"
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
