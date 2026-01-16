class NodeRed < Formula
  desc "Low-code programming for event-driven applications"
  homepage "https://nodered.org/"
  url "https://registry.npmjs.org/node-red/-/node-red-4.1.3.tgz"
  sha256 "88b21a94a765bd436e73d2cc3b966140835a48fe2720905a33c48248b7235d2f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "366122ba428bddd8c5a562888c98ec86817d33a5f383c0c1f2777dfd44de2fe2"
    sha256 cellar: :any,                 arm64_sequoia: "2380feeffc891a0d99be149845f1337f0946c4ccaea3daa47cc0096364e9bc13"
    sha256 cellar: :any,                 arm64_sonoma:  "2380feeffc891a0d99be149845f1337f0946c4ccaea3daa47cc0096364e9bc13"
    sha256 cellar: :any,                 sonoma:        "ed8d348218efe5434889b5b6df8e9bfd5ffffed2283103d4c54dd773d3369039"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "895e26f26527cc6b30bf644aef2a3ee88764ddbecb9030f33bf271e5832e7203"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4bfda3c2d224fead43d484cafdcaba7d808f12e7c8513b36432f3b885b087fe"
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
