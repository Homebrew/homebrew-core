class BudgetTracker < Formula
  desc "Feature rich TUI budget tracker app"
  homepage "https://github.com/Feromond/budget-tracker-tui"
  url "https://github.com/Feromond/budget-tracker-tui/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "7d97021b93dc1299976a1059ebb0b78453148095987eda9453ea2aa2146134e4"
  license "GPL-3.0-only"
  head "https://github.com/Feromond/budget-tracker-tui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89cdcf0f6e1003d90f71cbf3176885afb3e7f8ea7152def8f36cf33f69263f2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee557f0989f9156b80497ef9faf5d93e87fd3f98e192f9ab0f9d3f2c47828482"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2168ac075d19d9ce3c4bac7290e8d0bdb602d743a5efbfc25136e9b3905f9f44"
    sha256 cellar: :any,                 arm64_linux:   "8e04cd3c141117a9ad0be6774d201783f8ffde0d8035006b3bf43e1bf62c0445"
    sha256 cellar: :any,                 x86_64_linux:  "8e5fb315fbd8b9998e4e02fbbee8494cc127b7ebb294c7f61df57293610005c5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # budget-tracker is an interactive TUI with no non-interactive commands
    assert_match version.to_s, shell_output("#{bin}/budget-tracker --version")
  end
end
