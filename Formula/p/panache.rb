class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://github.com/jolars/panache/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "09a1b4ac77b5961b2eb663d5beaf1cc17d3f5db003b8583c79b0e20e26cd8a8d"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1da514eb8ed5d8a70d3b627d58cc7ace2fb9d2e12dfab4202478c9f9d2ef2cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a8962aa84dd0f39e2ef937a36a0da3a73d5bc006f935cd67f93d691926f0a66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98b7a5ff125d7d159f2b808cd6b360ac59a0ae69cc19aecfc04646ef40813559"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8d0c7d8c890b97e3643dfda375aee7c26d96ced470821f60a1ee12da07aa026"
    sha256 cellar: :any,                 arm64_linux:   "94fbdc46369ffc0d74d4ee569df557057afd680bf2fc4dec289ffcf0fdbd32a4"
    sha256 cellar: :any,                 x86_64_linux:  "cea75903ba9361f303cbc18e0aae4806003a04d3338414e30cac39437b5fc260"
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
