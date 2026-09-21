class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://github.com/jolars/panache/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "30e69acfd3c859d992dbc9926b84c615056c2155986877a723203505cbeac162"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c683c5921132d8c8ebddd78d464efb840bff168f4ddd443566e93606617095ed"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c2185695d2913a8a08dd3478129de31fdf3b046b63828a325ed9ec9512ed9899"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aee8d6e8f1de8e8a8a19376a071479dfb688f4fb5ec6f3688460518839e1e938"
    sha256 cellar: :any,                 arm64_linux:       "47cd1245dcc35aacc6be65ebb1da811eabafd73980b3dbccf599d53d9061f599"
    sha256 cellar: :any,                 x86_64_linux:      "ce083dd67a5915c455080d96ce2a58d0f681e52adabb5912e856ede794a139c3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input = <<~MARKDOWN
      # Heading

      * one
      * two
    MARKDOWN

    output = pipe_output("#{bin}/panache format -", input)
    assert_match "- one", output
    assert_match "- two", output
  end
end
