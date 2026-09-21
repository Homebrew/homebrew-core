class Mado < Formula
  desc "Fast Markdown linter written in Rust"
  homepage "https://github.com/akiomik/mado"
  url "https://github.com/akiomik/mado/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "6df6348a59170c19858d24512ba0a7eba9a5b5ec51f3f2bfa14e32327cc0f806"
  license "Apache-2.0"
  head "https://github.com/akiomik/mado.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "51e7a325a3cf1c4c6d4036b19b2eaf0fa5251d01e64e4712c03c01b84d650531"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "65f0d9a8e62a8aea7fce32f3c10c2584576fc43952806ac227a88e98c74e7136"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e25f5f469af9b354dbc02c95d8562f4092fb65fcdefc3f47a3ff94e789a42dcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "acce475fd922bb159194a0ee548a11ccfc9c654507032006fd3fa9dd4b4e7822"
    sha256 cellar: :any,                 arm64_linux:       "bbc4813fb317a1d3f94d0bb8004944e4c04035ce8f52df857de4ff40e67b04f8"
    sha256 cellar: :any,                 x86_64_linux:      "5892d80be8169dbef04f505ff17bc48fa1fda3fb66e39f86464147ae5252dcd1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mado --version")

    (testpath/"bad.md").write <<~MARKDOWN
      # Heading 1
      body without blank line
    MARKDOWN
    refute_empty shell_output("#{bin}/mado check #{testpath}/bad.md 2>&1", 1)

    (testpath/"good.md").write <<~MARKDOWN
      # Heading 1

      body with blank line
    MARKDOWN
    assert_match "All checks passed!", shell_output("#{bin}/mado check #{testpath}/good.md")
  end
end
