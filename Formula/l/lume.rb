class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https://github.com/trycua/computer"
  url "https://github.com/trycua/computer/archive/refs/tags/lume-v0.1.30.tar.gz"
  sha256 "e16b24a35c92f87799d608c9d435f8e1502093c1fcac99431ea68926949bdd41"
  license "MIT"
  head "https://github.com/trycua/computer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:lume[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e0962908b3d2eeadb5261705c63c967093b1ac2ddc52a433f1da1f5f779106a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a4ecc864e008c8553ca1f58057c5dd359438b017fe71ac5e11dc580e2dbe703"
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
