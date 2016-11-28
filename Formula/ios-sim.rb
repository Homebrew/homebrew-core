require "language/node"

class IosSim < Formula
  desc "Command-line application launcher for the iOS Simulator"
  homepage "https://github.com/phonegap/ios-sim"
  url "https://registry.npmjs.org/ios-sim/-/ios-sim-5.0.12.tgz"
  sha256 "f2cc6e1a0ab37ddbd82a6a659ef107ae032aff877f0f65a5f4e64dadcb03cd48"
  head "https://github.com/phonegap/ios-sim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "df622046ca434228db723b0fb1440e92932547128c6495458d72ad30d5ba3b06" => :sierra
    sha256 "767fa40662468c5468ec4cd07b64541667629ffa5a5fb3e5776ec9d95d20348a" => :el_capitan
    sha256 "ab7f45ee1b3a91872e14afc9c479f4bfd2e01fa1f6e535730f574e2686e70eb7" => :yosemite
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
