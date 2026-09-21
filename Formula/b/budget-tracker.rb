class BudgetTracker < Formula
  desc "Feature rich TUI budget tracker app"
  homepage "https://github.com/Feromond/budget-tracker-tui"
  url "https://github.com/Feromond/budget-tracker-tui/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "a32fc7263d470b6a8d6d7f178a818aa3b46fdb1eef35268cb3c46c8223efc427"
  license "GPL-3.0-only"
  head "https://github.com/Feromond/budget-tracker-tui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "51485c2bca9da7d2113ed46768be93f3c5390e6e13401e5abb1cb7096dcad0be"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "334899aa19329cc24990f4f5bc460f0591c05df1ced63303ea04f02e534d169e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "40bb135e2e7bdc1f9a2e24577d2b66bd3a7b7c50dc22509f8ee7a225673ecbe1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "5e1f37610879508d330383342dcf862d9b05dfd96840516a2864c139423e2c24"
    sha256 cellar: :any,                 arm64_linux:       "cd9758d8a2e1ca54c782655f532ec633d7b99891e0965ca3fd5182b7f9c91d34"
    sha256 cellar: :any,                 x86_64_linux:      "59dc33b48f1e210870642fc7c170b0e0e7fc6dc5fea1c3529ffa05833f74bda1"
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
