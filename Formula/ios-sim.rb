require "language/node"

class IosSim < Formula
  desc "Command-line application launcher for the iOS Simulator"
  homepage "https://github.com/phonegap/ios-sim"
  url "https://github.com/ios-control/ios-sim/archive/8.0.1.tar.gz"
  sha256 "aa60e5c8428b6f5a4a75a1e6a5836b92e2f524f3ee93428271c0f342c7fc01f4"
  head "https://github.com/phonegap/ios-sim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "60e2635ae2bbf479b2fa0e474b015c66961b22896c77288309d60083a396dda2" => :mojave
    sha256 "e4a81b35877e946824eb95f0c22b89f58078feaa14f7a4a3fc7891da6fbb744e" => :high_sierra
    sha256 "e7d0afc30d8d276117fe47b8b4459af879e96a020b7eb4f6149aad99741fcbbb" => :sierra
    sha256 "3285f588ff7aa51200a44b4a69497653b0bbef1df3399315a015f690bdd5c2df" => :el_capitan
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
