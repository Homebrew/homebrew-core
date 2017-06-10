require "language/node"

class IosSim < Formula
  desc "Command-line application launcher for the iOS Simulator"
  homepage "https://github.com/phonegap/ios-sim"
  url "https://registry.npmjs.org/ios-sim/-/ios-sim-5.1.0.tgz"
  sha256 "3238a64fe51ff4c301e2fd2bc486f6aa2c7641068c8e58f23c0d30b8430ff78f"
  head "https://github.com/phonegap/ios-sim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "06b0fc6e49f1dce6a2c85e6e59627f4400b30c4645020137cb0bcc9d646be636" => :sierra
    sha256 "450b22522fca80417b40ea99451485f13146a717363033dfc7260bdf2f573c05" => :el_capitan
    sha256 "7998c7b99ab13e674449230968392ab1c201b9cf400186fd939d4e7cb5308171" => :yosemite
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
