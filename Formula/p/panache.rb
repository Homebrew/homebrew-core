class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://github.com/jolars/panache/archive/refs/tags/v2.52.0.tar.gz"
  sha256 "a72905e249a2186600b79489ab734c420dac39dec1b724365a78448fe33e2e2f"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc37ef943b2554f887be8b6c08a88a6435bc111d7a2fc557b354c28bb6035f6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b994b4fc4b404f4e9490595be880cc54da03aecca63e1ef15dc39fd37be5b7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4382fd4309a717cd2b5ed069404a3b764dd5f712cc625bddcc75ec0cffa48395"
    sha256 cellar: :any_skip_relocation, sonoma:        "268cacc2c68cf0380b9c3ef15d4d6b340901d197fe841ba0a84e410a4061ab6c"
    sha256 cellar: :any,                 arm64_linux:   "ed43645bf0313432f3c125ebcaecbeacd815e15f0f8421b14804d9ae10d943ff"
    sha256 cellar: :any,                 x86_64_linux:  "d6b78dd50eae5d1e66ed71311a53190273f5011eca1450106a578e0474ed69a9"
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
