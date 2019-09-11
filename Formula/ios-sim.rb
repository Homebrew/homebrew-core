require "language/node"

class IosSim < Formula
  desc "Command-line application launcher for the iOS Simulator"
  homepage "https://github.com/phonegap/ios-sim"
  url "https://github.com/ios-control/ios-sim/archive/8.0.1.tar.gz"
  sha256 "aa60e5c8428b6f5a4a75a1e6a5836b92e2f524f3ee93428271c0f342c7fc01f4"
  head "https://github.com/phonegap/ios-sim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e865d125940753214469443d90c58ec7a83834d3fc11db93a489229a601a56be" => :mojave
    sha256 "0dd8c8d55ad679d6645738719e7a6b90c254d1d9b028a8f8e5e0dd8643e68a52" => :high_sierra
    sha256 "08877d6f7003e839e3be5db36a40127de060adc1d3069788e3374202812b2d99" => :sierra
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
