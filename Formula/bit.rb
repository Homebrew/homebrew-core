require "language/node"
class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://bitsrc.jfrog.io/bitsrc/bit-brew/stable/bit/0.5.0/bit-0.5.0-brew.tar.gz"
  sha256 "d276985d777657a4c9e5b3d5556cf5d5a05d3faf5ca88fcc993563a8b445aa5b"

  bottle do
    cellar :any_skip_relocation
    sha256 "5fbcaf33ed93b9c0cd11b9aa6f5142d8544cb6d2e028b45aea0631d30bb22a27" => :sierra
    sha256 "1b2a55c573e5f1889794abe397032e307247425af97705404d6d433db3451afe" => :el_capitan
    sha256 "1b2a55c573e5f1889794abe397032e307247425af97705404d6d433db3451afe" => :yosemite
  end

  def install
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/bit"]
    bin.install_symlink Dir["#{libexec}/bin/bit.js"]
    bin.install_symlink "#{libexec}/bin/node" => "bitNode"
  end

  test do
    assert_equal "successfully initialized an empty bit scope.\n",
                 shell_output("#{bin}/bit init --skip-update")
  end
end
