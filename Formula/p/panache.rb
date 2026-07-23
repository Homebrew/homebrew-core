class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://github.com/jolars/panache/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "6b61d93bd55f571b4f75db617987960703a5215d2c12898d78661cec3f7508f5"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bce05b72cc29c72a9454fe737869d473226e27c83b990680100d9a950b17a5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8c854d1e8969b139d58691834f38744aba051fc2dee57fbd3828364c1bdd230"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4362ec9455e008d4e8f7b14d06a5bc473fecee035eec39c5fc0fecdfc2372f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e495743ca1506c38f219203a37adc81f0d0beadf83ea1078edcc058b103b4115"
    sha256 cellar: :any,                 arm64_linux:   "8dd3b67bdc59a0a8351c107814754a00497fdb5131ea33b5425217ae28dcddfc"
    sha256 cellar: :any,                 x86_64_linux:  "4c0cb67e28384053aeceb8ed2bcccea07a1e28b7c3e47fa1d20ba1990cae0019"
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
