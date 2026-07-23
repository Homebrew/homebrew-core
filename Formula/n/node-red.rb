class NodeRed < Formula
  desc "Low-code programming for event-driven applications"
  homepage "https://nodered.org/"
  url "https://registry.npmjs.org/node-red/-/node-red-5.0.1.tgz"
  sha256 "07c176dcc2fccf2d37c727da3de6baa82a328ca96052f0f2982a92f042f8ac77"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b98cd8cc857b58460da370292df74ea36543137eac235e12c1ad152b83fc312c"
    sha256 cellar: :any,                 arm64_sequoia: "96a9d329d8dcde0c9735b5e3871ba52afa9191fcb6528fe80321ae900dab075b"
    sha256 cellar: :any,                 arm64_sonoma:  "96a9d329d8dcde0c9735b5e3871ba52afa9191fcb6528fe80321ae900dab075b"
    sha256 cellar: :any,                 sonoma:        "91089594a3df434c845f562ea8d82c9a3edae1f0a9b5403f77104db44806fbeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7eb23dc67ab230c2d809b531d5cf0be5f425cec73ecd4b4ecf1e04feb48a30b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98b766e533ce30c7f7b6860c8f35d0abd368d6a6079ce19562f3a82be04d4692"
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
