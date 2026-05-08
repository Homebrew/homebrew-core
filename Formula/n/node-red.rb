class NodeRed < Formula
  desc "Low-code programming for event-driven applications"
  homepage "https://nodered.org/"
  url "https://registry.npmjs.org/node-red/-/node-red-4.1.9.tgz"
  sha256 "50414203af0e2350f0eb7e025e67c03cf0159ddb7c36b448ffe8a246fb94dd00"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "878af3a910144fe13839ddd1d83b50bf77aa84793e5cf4e396e746bab5a348b8"
    sha256 cellar: :any,                 arm64_sequoia: "56d8eb1be50f6abc434a3573bbc4475056dc2cccfdd75d4e5a31bb5227b1ad98"
    sha256 cellar: :any,                 arm64_sonoma:  "56d8eb1be50f6abc434a3573bbc4475056dc2cccfdd75d4e5a31bb5227b1ad98"
    sha256 cellar: :any,                 sonoma:        "4de7f8684b8c26e4e04ee194aca3fe01c686979e2e51f1e4fcfdf9f53e3b5f63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b3b4fdb9c56c9498df31fb7c5e74c976908916e40a588b621c8ce0b7992d824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cce64b6ab634cf7bee2e5ba6c2fc604c64a5974969eea522f399ac7bacdf72b"
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
