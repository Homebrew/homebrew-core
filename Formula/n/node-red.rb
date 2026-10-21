class NodeRed < Formula
  desc "Low-code programming for event-driven applications"
  homepage "https://nodered.org/"
  url "https://registry.npmjs.org/node-red/-/node-red-5.0.8.tgz"
  sha256 "68c070f66d7149a0fb344c610a1b7753b1c01172d7271901aaa355e8c13f3dc3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "489c85430ca1f8c2715c23bf805537dc61632cc2829482cf081d426faf2e5e64"
    sha256 cellar: :any,                 arm64_tahoe:       "489c85430ca1f8c2715c23bf805537dc61632cc2829482cf081d426faf2e5e64"
    sha256 cellar: :any,                 arm64_sequoia:     "489c85430ca1f8c2715c23bf805537dc61632cc2829482cf081d426faf2e5e64"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "793d5825a3d6e18ebbf42fe0731eb59e6c7dea20ce374e277700d449b3732e7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ed6cedb259a29f8257269fef23981370b22440a3bbeaf1a9ccfccdf3c5111e76"
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
