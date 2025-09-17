class Afm < Formula
  desc "macOS server exposing Apple Foundation Models through OpenAI-compatible API"
  homepage "https://github.com/scouzi1966/maclocal-api"
  url "https://github.com/scouzi1966/maclocal-api/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "522665b0b43d4f1d26e6a0c43857444bcc7e11f50530e24ea1b9b0a979a77ab8"
  license "MIT"

  # Build requirements
  depends_on xcode: ["16.0", :build]

  # macOS-specific requirements
  depends_on arch: :arm64 # Apple Silicon only
  depends_on :macos

  # System requirements - let the build fail gracefully if Foundation Models unavailable

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/afm"
  end

  def caveats
    <<~EOS
      afm requires:
      • macOS Tahoe 26.0+ with Apple Intelligence enabled
      • Apple Silicon Mac (M1, M2, M3, or M4)
      • Apple Intelligence enabled in System Settings → Apple Intelligence & Siri

      Note: This formula requires macOS Tahoe (26.0) which limits compatibility
      to systems with the latest macOS version.

      Usage:
        afm                    # Start server on default port 9999
        afm --port 8080        # Custom port
        afm -s "prompt"        # Single prompt mode
        echo "text" | afm      # Pipe input support
    EOS
  end

  test do
    # Test version output
    assert_match version.to_s, shell_output("#{bin}/afm --version")

    # Test help output
    assert_match "USAGE:", shell_output("#{bin}/afm --help")

    # Test single prompt mode (will fail gracefully if Apple Intelligence not available)
    output = shell_output("#{bin}/afm -s 'test' 2>&1 || true")
    assert_match(/Foundation Models|not available|Apple Intelligence/, output)
  end
end
