class NodeRed < Formula
  desc "Low-code programming for event-driven applications"
  homepage "https://nodered.org/"
  url "https://registry.npmjs.org/node-red/-/node-red-4.1.11.tgz"
  sha256 "3fe4c5de7c3bf90b8faeb7d4692b877f7d4515cd21a81cb0ce5a310e27afa6fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "878c39e6ba00772d96b6eb196044208c98f66ec68ec4b283b9541b59c7bc2791"
    sha256 cellar: :any,                 arm64_sequoia: "531a82fc4820c6f660036ff5678fb537f65a8e4fe640fad00c15480c276fe2ae"
    sha256 cellar: :any,                 arm64_sonoma:  "531a82fc4820c6f660036ff5678fb537f65a8e4fe640fad00c15480c276fe2ae"
    sha256 cellar: :any,                 sonoma:        "7cda3242f01c87183a2151c3b5142029eb203801e7a8b4d160ffa074c202f801"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b96bc9c308adf728cefbd1774af19ec247926f4ea5f04e61dd031e6aebe32e72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5da0046102e7cf8b9909bac8f5c1b656b76411fb4cfa31e47b7a559823e8ced7"
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
