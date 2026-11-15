class NodeRed < Formula
  desc "Low-code programming for event-driven applications"
  homepage "https://nodered.org/"
  url "https://registry.npmjs.org/node-red/-/node-red-5.0.9.tgz"
  sha256 "1f88a60af9cf305f0e94b9045ee2451abdbefe98a33e9a71acb468affbf6d126"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "ec8f771fdd6e57f35c966ea4466b83ff964f41500e152e4f1ad9c3780f2e920f"
    sha256 cellar: :any,                 arm64_tahoe:       "ec8f771fdd6e57f35c966ea4466b83ff964f41500e152e4f1ad9c3780f2e920f"
    sha256 cellar: :any,                 arm64_sequoia:     "ec8f771fdd6e57f35c966ea4466b83ff964f41500e152e4f1ad9c3780f2e920f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "345b3462a4c71fdb3164097733ac044ec4389aa3de76a6e9c1dd96e9375151f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1ad1d1a986aa99e494edba9949b7bf8c2c000e747f56943d2c26446d36e50604"
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
