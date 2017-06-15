require "language/node"

class IosSim < Formula
  desc "Command-line application launcher for the iOS Simulator"
  homepage "https://github.com/phonegap/ios-sim"
  url "https://registry.npmjs.org/ios-sim/-/ios-sim-6.0.0.tgz"
  sha256 "346668d5ae7c1ae0cb8eeea107afb28ba46d06aa26cd1c0e7a58cd831cba6b63"
  head "https://github.com/phonegap/ios-sim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c334b2759c11e6e656391d82e30e894bb9fbc5fab09d405da71711815c9d8013" => :sierra
    sha256 "a3384d8abb99de093e4fe00a540202530b0af36ca5d020abe2125ce0360de354" => :el_capitan
    sha256 "15aef85c6fa0175464244a195b006adbb022d04ae481597d282e744d8c83e000" => :yosemite
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
