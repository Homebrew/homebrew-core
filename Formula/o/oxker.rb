class Oxker < Formula
  desc "Terminal User Interface (TUI) to view & control docker containers"
  homepage "https://github.com/mrjackwills/oxker"
  url "https://github.com/mrjackwills/oxker/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "ef6813b4f5e471c217d68acbeed67de3567f6c40723c8cb0ba029c42be5779dc"
  license "MIT"
  head "https://github.com/mrjackwills/oxker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ba35d0ecce5b45249e6928e819a1bb0fde2ef98d91db206c43cfd78996c854f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e052db3aaa3fdaee1f65c35e92ed57db5cdf138424e9a54118e9891bf885184"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a5133c8dd798b90b47e6fde4f0404d760b37a734441499af1b33403fd53d4c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4f8c3934c5860763464c028fd385ffa63e8607f13a8c3fbca4657bbdcc5bd4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09c4d3508a740824be8a6552713dd1c3121d53c42a15c1345f85adfd030f2cbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1678a89b3eb740b50ddf910eaf33191e287fda1b2d95ccb7fe0979b953d7d37e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxker --version")

    assert_match "a value is required for '--host <HOST>' but none was supplied",
      shell_output("#{bin}/oxker --host 2>&1", 2)
  end
end
