class BudgetTracker < Formula
  desc "Feature rich TUI budget tracker app"
  homepage "https://github.com/Feromond/budget-tracker-tui"
  url "https://github.com/Feromond/budget-tracker-tui/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "18c12f3d3c6e0eed58039c4c1a1c8206609beeeb9152c6104420afa82e459b7c"
  license "GPL-3.0-only"
  head "https://github.com/Feromond/budget-tracker-tui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f7cea8c20184c7c05b8871d992bb355b91221203f34a02bcb80a56fd39de267c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "86f05e40fa0184e940c933f44db07c2491d6d683f0aa5e8d90f13733badb81cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8b90afe5b163aba2cf3435d64dfad4831d0666a25e2540a4fba6e0f217297737"
    sha256 cellar: :any,                 arm64_linux:       "47cccef915733f939d369e169c3e84f7160e1e13960625a5effd69deaad3c6e0"
    sha256 cellar: :any,                 x86_64_linux:      "f8ed2aed650765450cc52036ea71de566d87e70ee170749b0429b5e03a3d573d"
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
