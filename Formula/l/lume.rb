class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https://github.com/trycua/lume"
  url "https://github.com/trycua/lume/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "13f8e9a55af4860512aff31f12dadf6ef45f2121bf8df4497122ad8c6a315d13"
  license "MIT"
  head "https://github.com/trycua/lume.git", branch: "main"

  depends_on arch: :arm64
  depends_on :macos

  uses_from_macos "swift" => :build
  uses_from_macos "curl" => :test

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "lume"
    system "/usr/bin/codesign", "-f", "-s", "-", "--entitlement", "resources/lume.entitlements", ".build/release/lume"
    bin.install ".build/release/lume"
  end

  test do
    # Test ipsw command
    assert_match "Found latest IPSW URL", shell_output("#{bin}/lume ipsw")

    # Test management HTTP server
    # Serves 404 Not found if no machines created
    port = free_port
    fork { exec bin/"lume", "serve", "--port", port.to_s }
    sleep 5
    assert_match(/404|200/, shell_output("curl -s -w '%{http_code}' localhost:#{port}/lume"))
  end
end
