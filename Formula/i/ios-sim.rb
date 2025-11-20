class IosSim < Formula
  desc "Command-line application launcher for the iOS Simulator"
  homepage "https://github.com/ios-control/ios-sim"
  url "https://github.com/ios-control/ios-sim/archive/refs/tags/9.0.0.tar.gz"
  sha256 "8c72c8c5f9b0682c218678549c08ca01b3ac2685417fc2ab5b4b803d65a21958"
  license "Apache-2.0"
  head "https://github.com/ios-control/ios-sim.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "7659fa28568951c5036b1d0b02becfb30d4d2f8242545367930e964ab16f49d9"
  end

  depends_on :macos
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Build an `:all` bottle
    node_modules = libexec/"lib/node_modules/ios-sim/node_modules"
    rm node_modules/"@oclif/linewrap/yarn-error.log"
  end

  test do
    system bin/"ios-sim", "--help"
  end
end
