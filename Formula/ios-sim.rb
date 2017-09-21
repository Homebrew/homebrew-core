require "language/node"

class IosSim < Formula
  desc "Command-line application launcher for the iOS Simulator"
  homepage "https://github.com/phonegap/ios-sim"
  url "https://registry.npmjs.org/ios-sim/-/ios-sim-6.1.1.tgz"
  sha256 "0668e25271b4974ead4dd231ad70392ddfcecf97682c857962b64dd8ca25a9cb"
  head "https://github.com/phonegap/ios-sim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "968992ff5da365a557723db24db2012e773e71b4a34967e39a1c81a0ab25b0e4" => :high_sierra
    sha256 "79db1f6f5e996585560dc7a84c320855742d9fe3f431c5619eae22a90c7f52fa" => :sierra
    sha256 "b0b6b4bcc69ac7520ffe0d26b93aaca6493a61d58cddfbb343fd9b0564f34a2a" => :el_capitan
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
