require "language/node"

class IosSim < Formula
  desc "Command-line application launcher for the iOS Simulator"
  homepage "https://github.com/phonegap/ios-sim"
  url "https://registry.npmjs.org/ios-sim/-/ios-sim-6.0.0.tgz"
  sha256 "346668d5ae7c1ae0cb8eeea107afb28ba46d06aa26cd1c0e7a58cd831cba6b63"
  head "https://github.com/phonegap/ios-sim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "180575866e1ea3f5f131851eecec63c7603559643df16ec2528d5148babaeee0" => :sierra
    sha256 "cb2917b4adf5b89ac122db72f77458f921b72a2a423d6e8fa055d19509ff4a4d" => :el_capitan
    sha256 "dd6c9e89a2c0bb3b4ca3f6e7e811c5371b1fd533ebb3b2f2d0d8608e63431801" => :yosemite
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
