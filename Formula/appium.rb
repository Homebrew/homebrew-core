require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-1.15.1.tgz"
  sha256 "6151afc1ab07216c211311354f4f3ad4c1844feb474dc9c01da28cd5cf73bb11"
  head "https://github.com/appium/appium.git"

  bottle do
    sha256 "02afa52b0d79465329a4ea6f3e95d0c4f7cee3f927792fa993bfd82f34896b27" => :catalina
    sha256 "a4e0ebf761c3ba449c98649d2fee2daa8ebd645220b47cea334aef6896587236" => :mojave
    sha256 "d47d136ee2629eae71ad776075c41eecfbf6c25a128b13754aeacf8718ac6a28" => :high_sierra
  end

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
