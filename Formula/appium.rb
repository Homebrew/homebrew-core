require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-1.17.1.tgz"
  sha256 "967aac00940015e17807d227a37fbee62c569a7b770b408a558944a2bbe27c5f"
  head "https://github.com/appium/appium.git"

  bottle do
    cellar :any
    sha256 "4b0eeb09e38fb06cd3401f4a95c70b08e2d9748edfbc55ceec2f483771d540bc" => :catalina
    sha256 "86ae515d092cea8edcbfeee53a4544bbcf65a2ff17b1ed4e4cf40df031e0a0e7" => :mojave
    sha256 "ee63e2d9fc264b568cff21ad3e448af5f5741fae4859b8eb4d0fa2eebf8247c2" => :high_sierra
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
