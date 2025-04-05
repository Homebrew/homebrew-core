class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https://github.com/trycua/computer"
  url "https://github.com/trycua/computer/archive/refs/tags/lume-v0.1.23.tar.gz"
  sha256 "a492ee73b454f1da720709e91bdb93acb6415d2c6c78b891156a84947bd3a64f"
  license "MIT"
  head "https://github.com/trycua/computer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:lume[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37fb9321ebef26f6851b5ae063f9b76f17214759769dc155ddef0359a326844d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2758ed679193cc2dc8fa02959c78980f7ed2b8469e9298baf94fdfc955436577"
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
