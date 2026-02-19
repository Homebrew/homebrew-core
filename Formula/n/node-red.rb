class NodeRed < Formula
  desc "Low-code programming for event-driven applications"
  homepage "https://nodered.org/"
  url "https://registry.npmjs.org/node-red/-/node-red-4.1.5.tgz"
  sha256 "01f999f22f0e5358728617fe52b9f879153855e91b243c7787607862ed615414"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3bfeba9e4a14341e5c0423f63ada4a54568197a6d20cf5f57516048d6df64611"
    sha256 cellar: :any,                 arm64_sequoia: "7949b8216052d27db108d2337766596234293ddf6e3c7caddaa6c105cbc1ba51"
    sha256 cellar: :any,                 arm64_sonoma:  "7949b8216052d27db108d2337766596234293ddf6e3c7caddaa6c105cbc1ba51"
    sha256 cellar: :any,                 sonoma:        "37b14d9eae68e9dceed7c75908c0bcf564d663b57960cc7c156c512ddf0b2656"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d96904598f9e0ba73f62bc66c3ea05c357ea0b0eb291c4dfa160c19a68ed8f74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51bb65a09fe04784204c0089372a2ed170da680d6cdbf402e99700f9fdb3715c"
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
