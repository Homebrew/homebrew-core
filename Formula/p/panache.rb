class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://github.com/jolars/panache/archive/refs/tags/v3.20.0.tar.gz"
  sha256 "081168a9cd0bcc66c48c0090216528703e41ce5747121a42628123879cf7d55c"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    manifest_sha256 "03960e3b76d0c4962a5f1a348ddcdea7425472b2516eedb1da477b3432bc775d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0c15d0878399d78768c40870aaef1585c3165e3a2829bb764241a258a2d02474"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "52a5e6bed83e3e20bca9795c1aa24af7a806e7c8605524f9632a3423cae0a1e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "84fa684b42085ff6a8e2d9a1d9903e8efe24a32ffbbb60b11f7bd0d960555088"
    sha256 cellar: :any,                 arm64_linux:       "2cb4849376eafefa47e6347228f094224c27526639c19c0ba9848231e3761467"
    sha256 cellar: :any,                 x86_64_linux:      "e4893676e85336d18cccda38662aaacc865052c56153db5d0d3a88c5183d1f5c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
