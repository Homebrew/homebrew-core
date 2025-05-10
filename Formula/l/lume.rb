class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https://github.com/trycua/computer"
  url "https://github.com/trycua/computer/archive/refs/tags/lume-v0.2.12.tar.gz"
  sha256 "3739c2c9b5cb630759916f51e09748296a51817ca9419d497010dc6c7ddbd290"
  license "MIT"
  head "https://github.com/trycua/computer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:lume[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b83fbec4d9ed2c096c3747bdb81ed62ec8e0ace350168042fbe3f72bf3e3b39e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b629c3c3d1389578de26ca4805f83adfa7bf7fbd136583c50c3a237c507c8be"
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
