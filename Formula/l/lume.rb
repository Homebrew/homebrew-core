class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https://cua.ai"
  url "https://github.com/trycua/cua/archive/refs/tags/lume-v0.20.0.tar.gz"
  sha256 "dcdd4a0ce71dbb3fc114e80e870c7e141d77c33f070f6254f910160f31707eed"
  license "MIT"
  version_scheme 1
  head "https://github.com/trycua/cua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:lume[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0573a7f2e1232ff400aa10e4609f838e6805d40e240daaec8aba98131803316f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "be1e075f6f0ed0bd8d58940797ac3089634f84d342db233c6aa7b494724a095f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b291f279b0c9344395c80d831fb850fb0d3b68e441d188a947363539427a7238"
  end

  depends_on xcode: ["16.0", :build]
  depends_on arch: :arm64 # For Swift 6.0
  depends_on macos: :sequoia # Swift 6 actor isolation requires macOS 15 SDK

  def install
    cd "libs/lume" do
      system "swift", "build", "--product", "lume", *std_swift_args
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

    assert_match "No virtual machines found", shell_output("#{bin}/lume ls")

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
