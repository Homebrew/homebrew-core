class Adrs < Formula
  desc "Architectural Decision Record tool in Rust"
  homepage "https://joshrotenberg.com/adrs/"
  url "https://github.com/joshrotenberg/adrs/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "f0346d44f941fda1083c316c59b5c95ab7c525548511dbf0486d19a6d9bbecce"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/joshrotenberg/adrs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d714b1becc16979e37fab60bfae79dbc08a3c364fc54c41268ee6c42db10691"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3be10e0fb5bd467e92973ef7cc0e37e339f56e41247ef40d31dcaecb5d53858"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1e16b66ed0657a49f4d99b82604b0d57e327b58449142a41b4854f0325f0666"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ccdd6df13ca408ea603414270f2c9cf14ec94fe7daff079be650491e41dea87"
    sha256 cellar: :any,                 arm64_linux:   "67728837d225a397604b16caf2ff9bf853bfd879ee86159cdc027408f7e92e65"
    sha256 cellar: :any,                 x86_64_linux:  "8277de1f027f6dbc547f52f5b374d16d7de51d7c422b1aa8fd9493b914efb6c4"
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
