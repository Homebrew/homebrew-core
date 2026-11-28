class NodeRed < Formula
  desc "Low-code programming for event-driven applications"
  homepage "https://nodered.org/"
  url "https://registry.npmjs.org/node-red/-/node-red-5.0.10.tgz"
  sha256 "3575bea4be2308a890a4510194ba475304eb12c6deef82c3c9f10fa7ea1690d3"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "cce4b43e6933721cbdf1645e701c6523b04a74e3895179d05b6576cb0b1c9daa"
    sha256 cellar: :any,                 arm64_golden_gate: "8ce7c6b03c511ae21e0036037d1bdfcb815bc10c0a1d419ec7ff5e903a8da538"
    sha256 cellar: :any,                 arm64_tahoe:       "8ce7c6b03c511ae21e0036037d1bdfcb815bc10c0a1d419ec7ff5e903a8da538"
    sha256 cellar: :any,                 arm64_sequoia:     "8ce7c6b03c511ae21e0036037d1bdfcb815bc10c0a1d419ec7ff5e903a8da538"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d210bbc604886af5e342fcf98a3824c3ef44b2f9180b1290c867286689496167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4d7c5a2535f030aa16d40366f5d8edf49fa706cf6120c7ba846cbfa1d5f2f88e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  service do
    run [opt_bin/"node-red", "--userDir", var/"node-red"]
    keep_alive true
    require_root true
    working_dir var/"node-red"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/node-red --version")

    port = free_port
    pid = fork do
      system bin/"node-red", "--userDir", testpath, "--port", port
    end

    begin
      sleep 5
      output = shell_output("curl -s http://localhost:#{port}").strip
      assert_match "<title>Node-RED</title>", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
