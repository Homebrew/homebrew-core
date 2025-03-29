class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https://github.com/trycua/computer"
  url "https://github.com/trycua/computer/archive/refs/tags/lume-v0.1.19.tar.gz"
  sha256 "3e7b111c584e4dc46b7ad40132a0b8581d7224966bc69cadde93558d56aea58a"
  license "MIT"
  head "https://github.com/trycua/computer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:lume[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95cc90d102c2a3323cae439f2501c86a77387cd9c8e49f0dc121194e7eedb230"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b7c885b15fcbe32829b6dfa1fc0309e19484918bc9f990874a89d38263b6bf2"
  end

  depends_on arch: :arm64
  depends_on :macos

  uses_from_macos "swift" => :build, since: :sequoia

  def install
    cd "libs/lume" do
      system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "lume"
      system "/usr/bin/codesign", "-f", "-s", "-",
             "--entitlement", "resources/lume.entitlements",
             ".build/release/lume"
      bin.install ".build/release/lume"
    end
  end

  test do
    # Test ipsw command
    assert_match "Found latest IPSW URL", shell_output("#{bin}/lume ipsw")

    # Test management HTTP server
    # Serves 404 Not found if no machines created
    port = free_port
    fork { exec bin/"lume", "serve", "--port", port.to_s }
    sleep 5
    assert_match %r{^HTTP/\d(.\d)? (200|404)}, shell_output("curl -si localhost:#{port}/lume").lines.first
  end
end
