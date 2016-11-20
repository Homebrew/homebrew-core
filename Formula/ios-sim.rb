require "language/node"

class IosSim < Formula
  desc "Command-line application launcher for the iOS Simulator"
  homepage "https://github.com/phonegap/ios-sim"
  url "https://registry.npmjs.org/ios-sim/-/ios-sim-5.0.11.tgz"
  sha256 "5613a0c6bcd7aca45e4a25db12d348fcaca25cc7c955e9269c71c60525a68284"
  head "https://github.com/phonegap/ios-sim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f630a59db7cfc1e5552439fd194ce0cee6374b30c1c01254dba6c4b5035e6c71" => :sierra
    sha256 "0a6a8ad33e7a4c2cca0d32a7ebb86ebe336396688a1135453fb46329a1362d64" => :el_capitan
    sha256 "c36f101d9db321bad40255fe5b329bf267816f30d587a2d6d7baf1fe8c0bd57e" => :yosemite
  end

  depends_on :macos => :mountain_lion
  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ios-sim", "--help"
  end
end
