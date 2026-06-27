class NodeRed < Formula
  desc "Low-code programming for event-driven applications"
  homepage "https://nodered.org/"
  url "https://registry.npmjs.org/node-red/-/node-red-5.0.0.tgz"
  sha256 "e4ddc33df8d6b81a6fef6cb1b4bb88edd8673db955004ec7a90cd6ed865fad44"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3e9c3f8165abcf848716cffe4806793c83b71d152697b63bea7eecea8d2cd6da"
    sha256 cellar: :any,                 arm64_sequoia: "4dc36ee56c6a4bec615724661ac5309abe94b3d398fd12fa830f7b3bd70515d7"
    sha256 cellar: :any,                 arm64_sonoma:  "4dc36ee56c6a4bec615724661ac5309abe94b3d398fd12fa830f7b3bd70515d7"
    sha256 cellar: :any,                 sonoma:        "a6f8088757c5557cc7e3a4e9e6d244bf373b4863e63e8c4c9c6f5297a9cdc318"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efe2e841b1837d87ba8c43c851dbf47c6c305cbd1898f1496f29fa0a0dcc6001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69b1804f45e2cdb24727f14b244d1a856a819af70f7db9111db1b61225723acd"
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
