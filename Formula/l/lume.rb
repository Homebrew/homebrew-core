class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https://cua.ai"
  url "https://github.com/trycua/cua/archive/refs/tags/lume-v0.4.0.tar.gz"
  sha256 "5f7cb6d8789d5df77d907dec00e0de8e5758456fb8197470686d39252d2002bc"
  license "MIT"
  head "https://github.com/trycua/cua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:lume[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f6b8b598ae02efd006c409684cce4fd58d118a26b8f4444ea88e44391ad63d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5b5e5a7eec5c4789001390a0b1aba5db0f7a89f0f3b18ef2d67a7ba0454f683"
  end

  depends_on xcode: ["16.0", :build]
  depends_on arch: :arm64 # For Swift 6.0
  depends_on macos: :sequoia # Swift 6 actor isolation requires macOS 15 SDK

  def install
    cd "libs/lume" do
      system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "lume"
      system "/usr/bin/codesign", "-f", "-s", "-",
             "--entitlements", "resources/lume.local.entitlements", # Avoid SIGKILL with ad-hoc signing.
             ".build/release/lume"
      libexec.install ".build/release/lume", ".build/release/lume_lume.bundle"
      bin.write_exec_script libexec/"lume"
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
    # `setup --unattended` loads presets from `lume_lume.bundle`.
    # It should fail because the VM doesn't exist, not crash on missing resources.
    output = shell_output("#{bin}/lume setup does-not-exist --unattended tahoe 2>&1", 1)
    assert_match "Virtual machine not found", output

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
