class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://github.com/jolars/panache/archive/refs/tags/v2.61.0.tar.gz"
  sha256 "fd491db3506b4112f80a572b50e8bbd22ccb7b976f9ea4c19973499af8074726"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "153192ceee9bdf2659ac6ee41d9e01518fb6b2f7c4008a2349cf15054168aa66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cab89ec3d9e746413c3c2b952238ad07bab5f7cc9d1f9766916c3b17265ea384"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73c92d6dcbc0acae0d5cfb77d8f79afcd77a9874cd434358c3cd2166f77bcd6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d811f03be587d83f0e9ccbabb924adf6de7f16dbbb5c5e07889253223e100a5"
    sha256 cellar: :any,                 arm64_linux:   "139a986917092c5a182748b562e2a6ba9175385d11623f9a910566dd18ebd386"
    sha256 cellar: :any,                 x86_64_linux:  "9610483223bdf3805640631c783bd243f42be2a0b879c82fcfa0bc82421a8102"
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
