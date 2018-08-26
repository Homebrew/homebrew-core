require "language/node"

class IosSim < Formula
  desc "Command-line application launcher for the iOS Simulator"
  homepage "https://github.com/phonegap/ios-sim"
  url "https://registry.npmjs.org/ios-sim/-/ios-sim-7.0.0.tgz"
  sha256 "6893781e5caa9e036bfe2044b3044c3a937b2b96b5de18bed3e93b7508a87615"
  head "https://github.com/phonegap/ios-sim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "60e2635ae2bbf479b2fa0e474b015c66961b22896c77288309d60083a396dda2" => :mojave
    sha256 "e4a81b35877e946824eb95f0c22b89f58078feaa14f7a4a3fc7891da6fbb744e" => :high_sierra
    sha256 "e7d0afc30d8d276117fe47b8b4459af879e96a020b7eb4f6149aad99741fcbbb" => :sierra
    sha256 "3285f588ff7aa51200a44b4a69497653b0bbef1df3399315a015f690bdd5c2df" => :el_capitan
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
