class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://github.com/k1LoW/deck/archive/refs/tags/v1.24.5.tar.gz"
  sha256 "cc3684ca91f6ad7289a3f8f07a08a38fc30e6b500c2495b99f29e60e2d06c36b"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    manifest_sha256 "1122b7f04b9f059ba8548b5970cea35af7f443347e290108fcceb01a174430bb"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2ad01ff5f2ce3728472d429cfadcdc77768add1faedf6a904e0ae12539033e27"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2ad01ff5f2ce3728472d429cfadcdc77768add1faedf6a904e0ae12539033e27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2ad01ff5f2ce3728472d429cfadcdc77768add1faedf6a904e0ae12539033e27"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "545125b6bc3756f43b34a12ec79477d31da297bc6c2d1943e22deee7c6a8fee9"
    sha256 cellar: :any,                 x86_64_linux:      "952f95ac8e8d1f89ea88d8a685dc9b1230444080b006efc0360411da8c676a54"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/deck"

    generate_completions_from_executable(bin/"deck", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deck --version")
    assert_match "presentation ID is required", shell_output("#{bin}/deck export 2>&1", 1)
  end
end
