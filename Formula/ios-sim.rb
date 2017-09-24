require "language/node"

class IosSim < Formula
  desc "Command-line application launcher for the iOS Simulator"
  homepage "https://github.com/phonegap/ios-sim"
  url "https://registry.npmjs.org/ios-sim/-/ios-sim-6.1.2.tgz"
  sha256 "b0d9e6101ac8f3c2ee9cbb123d9d2bd68a8dc24f83b822f7e64b546033f4098a"
  head "https://github.com/phonegap/ios-sim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "379955a35ac341fa19eae987a941047ffcd6fb2c56a040294235551b90e71355" => :high_sierra
    sha256 "fadd81993914e35a09afaf60ce846befbb5f99a0ca23b96044aff2a3a7d88425" => :sierra
    sha256 "4f2f61d51031e95de2087d180deae32766a5e6251c43237460ae0b9a69e78627" => :el_capitan
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
