class NodeRed < Formula
  desc "Low-code programming for event-driven applications"
  homepage "https://nodered.org/"
  url "https://registry.npmjs.org/node-red/-/node-red-4.0.9.tgz"
  sha256 "d8548204752c8ed7c1c5648e6fe2843342797ff5f0214647bdd1078366811cba"
  license "Apache-2.0"
  head "https://github.com/node-red/node-red.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ef1c67c28407a8a57ed82cbc8c1da9a0535dc4432be1db15b815fb4bd6920fc5"
    sha256 cellar: :any,                 arm64_sonoma:  "ef1c67c28407a8a57ed82cbc8c1da9a0535dc4432be1db15b815fb4bd6920fc5"
    sha256 cellar: :any,                 arm64_ventura: "ef1c67c28407a8a57ed82cbc8c1da9a0535dc4432be1db15b815fb4bd6920fc5"
    sha256 cellar: :any,                 sonoma:        "d48c0d73840489fe500398d2a58cce5d112c62ccbd8ce1f294688a43562045fc"
    sha256 cellar: :any,                 ventura:       "d48c0d73840489fe500398d2a58cce5d112c62ccbd8ce1f294688a43562045fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0eebad2f551bf8639e8bb5eb9e52cc6cb97518d8902e06d712b80c517b1a4d46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94b147afe0b47f633a38f2055292a62dcfd78d7a31a4f336e7f84b29879d57f1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
