class NodeRed < Formula
  desc "Low-code programming for event-driven applications"
  homepage "https://nodered.org/"
  url "https://registry.npmjs.org/node-red/-/node-red-5.0.4.tgz"
  sha256 "1acc0ed42023c9170100e2d5596b9db012d0de11f5457f52bed343b67eefbe4a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "083bba7887975a790a3d17a281014c0f5ada119627e1d94d17e9f4f7dbc4d62f"
    sha256 cellar: :any,                 arm64_sequoia: "083bba7887975a790a3d17a281014c0f5ada119627e1d94d17e9f4f7dbc4d62f"
    sha256 cellar: :any,                 arm64_sonoma:  "083bba7887975a790a3d17a281014c0f5ada119627e1d94d17e9f4f7dbc4d62f"
    sha256 cellar: :any,                 sonoma:        "5dd05342772224ad3282aae7117327b57079f2b14c18305e6df134a2f2adfd19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01f6b1bfd3a162367287bfb39c7bba4539dcc9bb364aac9929215f0f26897bac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd1f96e227942be506ee36e269c342260e2c1901b86a34443038cf6c284a1b27"
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
