class NodeRed < Formula
  desc "Low-code programming for event-driven applications"
  homepage "https://nodered.org/"
  url "https://registry.npmjs.org/node-red/-/node-red-4.1.0.tgz"
  sha256 "eb72d0d4327bd7d08736e08f5bd4950c0071e93b75ea26f06f79e4f9b43b6ec5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "92426e456a2cff17e0ffb68a0f22741ec46eda426821a3e69ac2ee4abf888be8"
    sha256 cellar: :any,                 arm64_sequoia: "70289e1f5a704255618d780aa3a6c6a326716ff6ffec20bb56a635158e50aae2"
    sha256 cellar: :any,                 arm64_sonoma:  "70289e1f5a704255618d780aa3a6c6a326716ff6ffec20bb56a635158e50aae2"
    sha256 cellar: :any,                 arm64_ventura: "70289e1f5a704255618d780aa3a6c6a326716ff6ffec20bb56a635158e50aae2"
    sha256 cellar: :any,                 sonoma:        "72f7e28802f9f9aa3c7d56df856a591665bf08390ad89ef5ee90ef94873d9e29"
    sha256 cellar: :any,                 ventura:       "72f7e28802f9f9aa3c7d56df856a591665bf08390ad89ef5ee90ef94873d9e29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ac0fcef6756195f75218fcb79dc13de68361640b2165c001bc2e7cf7d389b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f45fdffc646b2ba6e64154600ba3d0b43cf47f686823478d0d5aca0581d15bc1"
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
