require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-1.20.0.tgz"
  sha256 "d715204d5de23b4acd238567841f3bf900d383a1b7d7a0647a85fa566be7fa5e"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "e9cd43b0871486f6567eada38f1f535dc24a7605f3b7222f1f37939bbb8a9076" => :big_sur
    sha256 "0fb1f237254b60f10333b22c5a4854bd5cb2af830b1859618241656eb200f749" => :arm64_big_sur
    sha256 "a624ae16c43c88e4cfa29597efff5c824dbebd7434353dffa29fc55c4218e7bc" => :catalina
    sha256 "23999d5f9ae201854deb5f5ee5b70938bdb9f0204f16324375ac5e63f6c9f481" => :mojave
  end

  depends_on "node"

  def install
    # workaround packaging bug exposed in npm 7+ (bin smylinks are now created
    # before installing dependencies) => manually create symlink for authorize-ios
    inreplace "package.json", "\"appium\": \"./build/lib/main.js\",", "\"appium\": \"./build/lib/main.js\""
    inreplace "package.json", "\"authorize-ios\": \"./node_modules/.bin/authorize-ios\"", ""
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    ln_s libexec/"lib/node_modules/appium/node_modules/.bin/authorize-ios", libexec/"bin/authorize-ios"
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

      assert_match "unknown command", shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
