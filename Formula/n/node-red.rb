class NodeRed < Formula
  desc "Low-code programming for event-driven applications"
  homepage "https://nodered.org/"
  url "https://registry.npmjs.org/node-red/-/node-red-4.1.10.tgz"
  sha256 "a91656cb5c97b98655540e0d557aeebbfad9a2134ac48c9d47eb3798803ae3d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "23594ca739c36c492a890fd518aa9cdb2e53cdb221804c60b671b2b41bad9b00"
    sha256 cellar: :any,                 arm64_sequoia: "7a2230e23af080f58b7c5beed90013348885f8a20ac9d516be2c8f6c1e3844a6"
    sha256 cellar: :any,                 arm64_sonoma:  "7a2230e23af080f58b7c5beed90013348885f8a20ac9d516be2c8f6c1e3844a6"
    sha256 cellar: :any,                 sonoma:        "c8d84c2009b7703d3aa0f089519b0ca1482cc5cfd509526f0fa81f3b9f25b886"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27420d13d1f053ad225e77af853f62e8b1a68c9557eb90ee87d5c0903641c90e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffca3b081ef1357cf321577bd9565848b2b83fc6c793afb7386914830938da5e"
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
