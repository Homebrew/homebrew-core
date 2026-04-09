class NodeRed < Formula
  desc "Low-code programming for event-driven applications"
  homepage "https://nodered.org/"
  url "https://registry.npmjs.org/node-red/-/node-red-4.1.8.tgz"
  sha256 "b7e1cf516894553232ad0d4513909d0620a6d57211a485948237b4772db461fe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f8efe181bea87ae6c768ce4a32896f04e2de07815be620df32d533fb3466ed15"
    sha256 cellar: :any,                 arm64_sequoia: "0d732f7d02a891ce3f24103311d4a670366d64f82bcd63be7c58859f38de0882"
    sha256 cellar: :any,                 arm64_sonoma:  "0d732f7d02a891ce3f24103311d4a670366d64f82bcd63be7c58859f38de0882"
    sha256 cellar: :any,                 sonoma:        "1cd2097e307ec44755587d8298151287cb2fb7b0fb5e0d4187b11abd98171706"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91fee4696149a5534321e9d0cf2eea282a8aba4ec12fe1970c9ad0ed53fcb798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e02a9298376794732281a52789ef6aaef72d9a7efe8b53e2e084d8a01605072"
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
