require "language/node"

class IosSim < Formula
  desc "Command-line application launcher for the iOS Simulator"
  homepage "https://github.com/phonegap/ios-sim"
  url "https://registry.npmjs.org/ios-sim/-/ios-sim-5.0.11.tgz"
  sha256 "5613a0c6bcd7aca45e4a25db12d348fcaca25cc7c955e9269c71c60525a68284"
  head "https://github.com/phonegap/ios-sim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "35822feb2684b8861ba7181ed96bdf44e799182292828c4959ccfe049fdb7eb8" => :sierra
    sha256 "c0bf22dbfe7f9078ea8afca0a71d5a3e5edfca5c69cbcf31f45c6d25660f760a" => :el_capitan
    sha256 "7c48ffdc5c34bf918f982e95219f6dac8af3d6e194806acaa08545ec89c13cde" => :yosemite
    sha256 "e9bbc65c7817322cb927e998a401bdeea7c8669f2ad10fb963f5eed91f3b30b9" => :mavericks
    sha256 "2182681c195d4a616f9a3975ea986de04d7d5b4c434844e503b83e4b18cd035c" => :mountain_lion
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
