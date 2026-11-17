class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://github.com/jolars/panache/archive/refs/tags/v3.19.0.tar.gz"
  sha256 "acc41224c7d5437827aee10aa9fb95f199eca9ce10317866e2d18bd29e0bb680"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0e64c0fd7d9dbecd82ba3faa0d0d8d6d6215210307abec937ee17cd0c72c85ed"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "916b8de7c74def8a453053c9699c41da7b892f95ceadddd39a2591dcec47cde0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "63d4e623fc5513110e2138ed65f05f7645907b5ce9aa755227f3c76b196fb3c3"
    sha256 cellar: :any,                 arm64_linux:       "3a9b618095fe67d717929ee779e06d99b37b59f1a3adccdc8be9217e8329952a"
    sha256 cellar: :any,                 x86_64_linux:      "8c73428170ffab936552fe94c4db52aee88fad69251e6c1febdc20ffb6eb9bb4"
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
