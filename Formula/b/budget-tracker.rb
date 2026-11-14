class BudgetTracker < Formula
  desc "Feature rich TUI budget tracker app"
  homepage "https://github.com/Feromond/budget-tracker-tui"
  url "https://github.com/Feromond/budget-tracker-tui/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "94df80a938e4e9365956dcaabe85c6bb62e6aed8f5133a5c8c01ceb06a12371d"
  license "GPL-3.0-only"
  head "https://github.com/Feromond/budget-tracker-tui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "466d09481ea98e1fb853183ac34d7dd5660f5dad15360976e888b8b7b85415e1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a78c44f92c20db8fa11120ad83a4a5311deb2e27da2b2ba426ead9b3d4a072fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "193f228724eb8f383b65f2209708eef997f62748a6e6f302a46f4109ef4142f0"
    sha256 cellar: :any,                 arm64_linux:       "c01fa0f215a4d2ca6e2c364341a5d71e7678c1ad29e9f1f2530d4e706d1c5e5f"
    sha256 cellar: :any,                 x86_64_linux:      "a2d0c9e1ad40f2b5a6805bbfeda23f5a3f7059d3a8f46e479f27fc4ea5e1a801"
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
