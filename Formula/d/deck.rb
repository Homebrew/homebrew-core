class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://github.com/k1LoW/deck/archive/refs/tags/v1.24.5.tar.gz"
  sha256 "cc3684ca91f6ad7289a3f8f07a08a38fc30e6b500c2495b99f29e60e2d06c36b"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fce8157a5275770e5c73064cf444fb1e31b0127100fa23820bc41b55be060262"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fce8157a5275770e5c73064cf444fb1e31b0127100fa23820bc41b55be060262"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fce8157a5275770e5c73064cf444fb1e31b0127100fa23820bc41b55be060262"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "16b9f3562e99593f54cd24987b24caad1829c34734c6f27ec22db30c6583e549"
    sha256 cellar: :any,                 x86_64_linux:      "67d304ee51626b2e8ec7ef60ce448c3ff6d06a7e6525b7c13572f384abfbcafa"
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
