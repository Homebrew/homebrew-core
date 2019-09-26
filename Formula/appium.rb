require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-1.15.0.tgz"
  sha256 "49c0971bf9638c400ec70c53eb70071b1193f5b7dc0266928aa665e7ecf18ea2"
  head "https://github.com/appium/appium.git"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/appium --show-config 2>&1")
    assert_match version.to_str, output
    begin
      pid = fork do
        exec bin/"appium &>appium-start.out"
      end
      sleep 3

      assert_match "The URL '/' did not map to a valid resource", shell_output("curl -s 127.0.0.1:4723")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
