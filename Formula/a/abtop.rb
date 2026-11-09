class Abtop < Formula
  desc "Terminal monitor for AI coding agent sessions"
  homepage "https://github.com/graykode/abtop"
  url "https://github.com/graykode/abtop/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "6664cec768299277085dcebdca6d07fcd57137cbb3ff4fe61c222fa9ca6b34d1"
  license "MIT"
  head "https://github.com/graykode/abtop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5e2f6e40a84305c167bc3fed7b5b96d9ccd239c475ed4e38d29857fcde07e36c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "60d31368845bac83d23861c4dfda9a66a7f8b188c96ed6b9b121077fe934d069"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "12607220722e4b8568aa02e6bc49c9a355c8906f53ebd6efa50f88c54af6ad27"
    sha256 cellar: :any,                 arm64_linux:       "a9b47f063bd1db0eb5e7df82ae404f6441de5c63c7918f093011db9d5415799d"
    sha256 cellar: :any,                 x86_64_linux:      "d692bd8f243224237948254ee2861f49949713f55976a18af7a45f20b47ae581"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Homebrew manages upgrades, so disable the self-update command.
    # Upstream feature request: https://github.com/graykode/abtop/issues/186
    inreplace "src/lib.rs", "return run_update();",
              'eprintln!("abtop is managed by Homebrew; run `brew upgrade abtop` instead."); return Ok(());'

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/abtop --version")
    assert_match "run `brew upgrade abtop` instead", shell_output("#{bin}/abtop --update 2>&1")
    snapshot = JSON.parse(shell_output("#{bin}/abtop --json --demo"))
    assert snapshot.fetch("sessions").any? { |session| session.fetch("project_name") == "webshop" }
    assert snapshot.fetch("sessions").any? { |session| session.fetch("agent_cli") == "claude" }
  end
end
