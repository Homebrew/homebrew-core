require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-1.17.1.tgz"
  sha256 "967aac00940015e17807d227a37fbee62c569a7b770b408a558944a2bbe27c5f"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git"

  bottle do
    cellar :any
    sha256 "f0e2cae44d7c89c105ff256f34786ecc53d133fbbc74f21a93dca51ae28dc811" => :catalina
    sha256 "d45524677747716facf1fc8ff483b34051300fe9ee3ec37797cee98ca91bf810" => :mojave
    sha256 "086ddbbdae4a0b17e4dec8197f1efd53d5f80b011ffde0d3389260f599238223" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/appium --show-config 2>&1")
    assert_match version.to_str, output

    port = free_port
    begin
      pid = fork do
        exec bin/"appium --port #{port} &>appium-start.out"
      end
      sleep 3

      assert_match "The URL '/' did not map to a valid resource", shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
