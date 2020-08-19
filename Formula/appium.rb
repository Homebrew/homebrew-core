require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-1.18.1.tgz"
  sha256 "938783100df8be224cb85b5dbdcebeb91d164f003d4cdd2aa9c801480bd027b4"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git"

  bottle do
    cellar :any
    sha256 "d6d0adf1f5b4380cf09ad9571e708f51e7d3f5c99307eafd5411dc7318ee03b9" => :catalina
    sha256 "6e1fc2e7528234ec093d77933030e796accdd927e58fed2869e9b91f9951590f" => :mojave
    sha256 "cc6f096c1464b401f52b6808eb8fe3d71975bb9c83594fcc7a0dc67551abb5e8" => :high_sierra
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
