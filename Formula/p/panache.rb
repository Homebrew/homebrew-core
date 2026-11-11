class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://github.com/jolars/panache/archive/refs/tags/v3.18.0.tar.gz"
  sha256 "a2f2ddc185cb127dc582026806775b661ce2dc6d4fc87f15628cb6de9344fc39"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1612fcfd516edd107606ce1e042938784ad54cb48062cbf08c847f6866b33706"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e861f5b9e933d46bb98a56f9e171ad83071b9b09b2bb1c1c1c958e6ad53e2661"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "61bbf87b7086e0e2300eff1cfec48fae6dfd2919efde623591d4839af4e8473e"
    sha256 cellar: :any,                 arm64_linux:       "33365196d2d99e8d50d2f375a4191631fcbce6090e967ba6e482687795e9bfc2"
    sha256 cellar: :any,                 x86_64_linux:      "0b14812e7b87e93b77d18fbe132c81f3a24785f8cf3c15251bf138fed905d087"
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
