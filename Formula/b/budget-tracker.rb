class BudgetTracker < Formula
  desc "Feature rich TUI budget tracker app"
  homepage "https://github.com/Feromond/budget-tracker-tui"
  url "https://github.com/Feromond/budget-tracker-tui/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "13cf0bd4d77bea25fb91101962a3c339591586b0d3054903bd212028218903b8"
  license "GPL-3.0-only"
  head "https://github.com/Feromond/budget-tracker-tui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "25b6dd0b8d9db5c84048cc9ac0888801d653fccd53fbd4ec85f92a6b64724a44"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c4cb472fa4dd475a4d679943be3d735548e496a52a5ca7c0e3d7a92b52bc3682"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e75eac56c4b3fc457460cd76e9cb6f3f003483e8df443f9f624035c5efb93fbd"
    sha256 cellar: :any,                 arm64_linux:       "9be48669061adc2d1c917f2418b73bc0ea26b055bd345e56bbcf3c1b9459c2a6"
    sha256 cellar: :any,                 x86_64_linux:      "ce0086ca597ea2c52c34a2d441c682efa69beee2a2fc8dd8e8bd20f835e7fe99"
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
