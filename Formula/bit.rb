require "language/node"
class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://bitsrc.jfrog.io/bitsrc/bit-brew/stable/bit/0.5.2/bit-0.5.2-brew.tar.gz"
  sha256 "c6e183684e6f69c729886f96bbb05d39cfad429c92452a48c6c4b421fc1e8be7"

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
