class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https://cua.ai"
  url "https://github.com/trycua/cua/archive/refs/tags/lume-v0.19.0.tar.gz"
  sha256 "7d293bec0aa983ef8734890537b673894abcc2b8df103a5668644a146d8bd5c7"
  license "MIT"
  head "https://github.com/trycua/cua.git", branch: "main"

  livecheck do
    url "https://cua.ai/lume/install.sh"
    regex(/^LUME_BAKED_VERSION="v?(\d+(?:\.\d+)+)" # x-release-please-version$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f157e4a87e4969ec546d72d2e0b94bae2ef083746652febbc730da422f37dabc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f1995d6827018fda0baa1faf48cb9cc7d81d6e8d6316dc6598b0d4e3ce70c32"
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
