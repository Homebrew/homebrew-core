require "language/node"

class IosSim < Formula
  desc "Command-line application launcher for the iOS Simulator"
  homepage "https://github.com/phonegap/ios-sim"
  url "https://github.com/ios-control/ios-sim/archive/9.0.0.tar.gz"
  sha256 "8c72c8c5f9b0682c218678549c08ca01b3ac2685417fc2ab5b4b803d65a21958"
  head "https://github.com/phonegap/ios-sim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d584211ecf3afe536ca2cf5f0fc14a46a7303b9ab664bdcc138f84731c392ae" => :catalina
    sha256 "57eba6f175bb19ea53f53142345d6a729ff2494bf5e986182e19cd3228c13683" => :mojave
    sha256 "fb1aef7e85f401660584629d09499e3c58b788b11313dbf68fe0840ee372e20e" => :high_sierra
    sha256 "03387aef5b0f1f52d398971fd6189324f52f73b21bd4d1c378d516a50a329dce" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ios-sim", "--help"
  end
end
