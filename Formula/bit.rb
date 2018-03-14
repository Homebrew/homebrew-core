require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-0.12.9.tgz"
  sha256 "99408103b7790fea7af616034a60fc719361321460adbbf2be51e6a6b0c1ce96"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "136420eb62741c687692003b235d205d996a641b8e07e674c2a1fb7af70f3297" => :high_sierra
    sha256 "0fcecd8224728e5a1a024e5c038c2b88c9bb7d58d465f5fa2d9b1305908dbda5" => :sierra
    sha256 "fb6ef3c666ed39e08e10128233e84c9343fbeb7fbf01dbbd4f4a46e72d78a73a" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/bit init --skip-update")
    assert_match "successfully initialized", output
  end
end
