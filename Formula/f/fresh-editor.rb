class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.76.tar.gz"
  sha256 "8a1ff544f754d560d35adfffd7938af69d48d2e46ca7e69e15fe71447f1fff03"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "499fc1b13b0149ec35463825ef3b137e552fbb87fc9d8b7113a253c7483480b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d7ee50f0ec455a728624aba00c0154649c34e4baff11ab1df2326a88a09f8c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c7ae7d445c81aa36f24f9d615a60a8aab6defc59411df3db69113b92255497e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d860fbf6aefc8b1e01f31a64f5a8128ae53eb4bc9e583954a95f1418125d92fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a81d04bf327104f3a7023ff20e801b2ffffbd50c33bceb06a2409a19773b2a52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b15c337370482874ca65931da3e6e660058b57ed75db0a23d1b03632575dc8b2"
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

    pipe_output("#{bin}/fresh --no-session test.txt --log-file fresh.log", commands)
    log_output = (testpath/"fresh.log").read.gsub(/\e\[\d+(;\d+)?m/, "")
    assert_match "INFO fresh: Editor starting", log_output
  end
end
