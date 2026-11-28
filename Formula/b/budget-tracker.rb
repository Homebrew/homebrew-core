class BudgetTracker < Formula
  desc "Feature rich TUI budget tracker app"
  homepage "https://github.com/Feromond/budget-tracker-tui"
  url "https://github.com/Feromond/budget-tracker-tui/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "df466ea2906f8bce1bc8d7e7b9b75b177da65f83bee30df7af6a664a37231b4f"
  license "GPL-3.0-only"
  head "https://github.com/Feromond/budget-tracker-tui.git", branch: "main"

  bottle do
    manifest_sha256 "79642a6974c9cdc3ad8fc6706facb15369c9546d0c8995eb4578119cafe2028e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1e6a5564d3a58f9dd01b4f96837b3b482f9beff6a3b38f4d40802f8a781cf2af"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c8ebb32eed3c535e517cd372e8aeb2deae78260e5ebeacf7bc278f98509cb873"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ae3913b6e167a0cc6119df9e60f19756e8fce999d84dd67aaa804a7996c80e9d"
    sha256 cellar: :any,                 arm64_linux:       "49c910bb008a3899037f4ee1501cb922216c6f442109433044691e479edcd2b6"
    sha256 cellar: :any,                 x86_64_linux:      "8285b4a660c4938eccadb514b0159092cc9aa9e6164ae313b2ce3a83a872bae3"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # budget-tracker is an interactive TUI with no non-interactive commands
    assert_match version.to_s, shell_output("#{bin}/budget-tracker --version")
  end
end
