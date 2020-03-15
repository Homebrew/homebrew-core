require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-1.17.0.tgz"
  sha256 "62daf1dd25ef284db26d6c5b99a8f46dc6c5b8c01730a2bd4e8c87322324772d"
  head "https://github.com/appium/appium.git"

  bottle do
    cellar :any
    sha256 "f2b54dfcd6bba9655ce1563bb59efe80b1f1ffc71ee474f3b318016dbf58793e" => :catalina
    sha256 "c022f7eb569896f78cd03add87cd7137263a0869925a6b42ec334610719ed541" => :mojave
    sha256 "9e59c57b6c337bf947128ad23c28145d45c2375c8059ab8b2e66b528caa9010b" => :high_sierra
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
