class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.47.tar.gz"
  sha256 "6547043ab6c0593975d401547c2cc1a055e5b646a25327f053a6da9ac1ff8485"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0a14b9a3053da07e5583184dbe7693c18355a224b23224bd53eee141b854e9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36de2058d924bb765015710648e568d95f90f270f35262d9c143cae8568e6feb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22af908c3466f124a64f1bf28046a5262491ab8be26de317c07c153aa210a258"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1c61f258249f8d1dc9b6c871d06fe4e596c0fbc2d86117f3b93c5d0cd1f274e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a95e907570b22f50345d3a7bc58d22382e7dd5080afab496fd88a4edbb1c5c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2542215545fdeb23d375df9bccb3aaaaa4d0ce35f212d8f52ec4cad2e23980e5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    # Test script mode: type text, save, and quit
    commands = <<~JSON
      {"type":"type_text","text":"Hello from Homebrew"}
      {"type":"key","code":"s","modifiers":["ctrl"]}
      {"type":"quit"}
    JSON

    pipe_output("#{bin}/fresh --script-mode --no-session test.txt", commands)
    assert_match "Hello from Homebrew", (testpath/"test.txt").read
  end
end
