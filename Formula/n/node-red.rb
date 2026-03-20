class NodeRed < Formula
  desc "Low-code programming for event-driven applications"
  homepage "https://nodered.org/"
  url "https://registry.npmjs.org/node-red/-/node-red-4.1.7.tgz"
  sha256 "8b5873f70f67bb1f7baa7dcd40461c729786310b3e5c6b963d4c634a6363b72c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a7f8565b375b061456bdbc1c931bd3a29156a7b44a5e28e5f4aa8dcc089552f6"
    sha256 cellar: :any,                 arm64_sequoia: "9b11533dc843446931471101a7e9e1c763ad8d4a365ac710bf8aeaad4afb2d17"
    sha256 cellar: :any,                 arm64_sonoma:  "9b11533dc843446931471101a7e9e1c763ad8d4a365ac710bf8aeaad4afb2d17"
    sha256 cellar: :any,                 sonoma:        "d72984bfb86c3feddba9b25510566618b9f05536b14bedd4c84294c4b12abf1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb69ddc4d71b3097f47c434f8e49a9ea4cd18c013cd55f316df9ec58294a235c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "159c7b6951115a9e74d1698bfbd4d721c8c523897d69cb3ca5b562005dcd8ad1"
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
