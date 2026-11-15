class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://github.com/jolars/panache/archive/refs/tags/v3.18.0.tar.gz"
  sha256 "a2f2ddc185cb127dc582026806775b661ce2dc6d4fc87f15628cb6de9344fc39"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "93e4fd8517994f94520831d0b043e5a9a34ea74803706430df75756349b84bc0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "69203d0ffa3418b2b0d46551c2ff80f525c4df8ff1c1c7f8f974ab5f9a195cfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "88908ce76649a834f796352bcdbd86537f8395f27a9facc34d73bda861dccaa5"
    sha256 cellar: :any,                 arm64_linux:       "1099d8c130886fecf52d8d700038370e17768080139b1df79d3365e7075f61c4"
    sha256 cellar: :any,                 x86_64_linux:      "9793e390877c01e9b576368821954dfa291c461327073aba6613ac83830463b9"
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
