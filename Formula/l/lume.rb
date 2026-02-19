class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https://github.com/trycua/cua"
  url "https://github.com/trycua/cua/archive/refs/tags/lume-v0.2.81.tar.gz"
  sha256 "752c3cbd7c2e1f6e7027a3e4870fc5723d7b6723a45632bed514c5537eab2723"
  license "MIT"
  head "https://github.com/trycua/cua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:lume[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "630f5b6ef3ab907e39e5eb1495f53ba7202cd194c9c11c105620b67b82d13949"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d3343228b0f5af12e695b9287f7031187cf5ff89f725d065b9b32908abe99f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baa4c0355a0c868ec42fa98480f5d30cdc95b7b85fcac1e5dd995ade0d6d327e"
  end

  depends_on xcode: ["16.0", :build]
  depends_on arch: :arm64 # For Swift 6.0
  depends_on :macos

  def install
    cd "libs/lume" do
      system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "lume"
      system "/usr/bin/codesign", "-f", "-s", "-",
             "--entitlements", "resources/lume.local.entitlements", # Avoid SIGKILL with ad-hoc signing.
             ".build/release/lume"
      bin.install ".build/release/lume"
    end
  end

  service do
    run [opt_bin/"lume", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/lume.log"
    error_log_path var/"log/lume.log"
  end

  test do
    # Test ipsw command
    assert_match "Found latest IPSW URL", shell_output("#{bin}/lume ipsw")

    # Test management HTTP server
    port = free_port
    pid = spawn bin/"lume", "serve", "--port", port.to_s
    sleep 5
    begin
      # Serves 404 Not found if no machines created
      assert_match %r{^HTTP/\d(.\d)? (200|404)}, shell_output("curl -si localhost:#{port}/lume").lines.first
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
