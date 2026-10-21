class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://github.com/jolars/panache/archive/refs/tags/v3.17.0.tar.gz"
  sha256 "cee13860512aa33dbbba621f683f949b021df04d78c8c623c4409cd62fbab84f"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eb1c37830277cf1c66b57b75716a51a5e3fb3248d92f3b034b45ffe7fe4d1630"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bf652bdb502b2e12e9ddcd44983dcc527650d6911ebe89c9f9b91a35eff38149"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e5c5053e35127075011767cea7ba56e16f03584437d0430b826ddc6f769ed12f"
    sha256 cellar: :any,                 arm64_linux:       "dbd9271aa478700f544be64ef4dfe4236595ae5a7b02d6f0c8651d5699f65983"
    sha256 cellar: :any,                 x86_64_linux:      "557ca87a7665730c3562d7472554fe8170e60d8b02600d4232e9db982e5fe986"
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
