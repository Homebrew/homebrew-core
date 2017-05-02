require "language/node"
class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://bitsrc.jfrog.io/bitsrc/bit-brew/stable/bit/0.5.3/bit-0.5.3-brew.tar.gz"
  sha256 "539c0bd75c19a02cc84ffa738bdf5425fb32af900ce88f501032a6222c9bcdff"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf66e35183ac949b85363c2082da9b59076cd19b347e610c4ec6108577c68e32" => :sierra
    sha256 "a73d115fe024446462b6d9ca7a04bf15a9e4ebd951966c61527aeb526e8a8cc8" => :el_capitan
    sha256 "a73d115fe024446462b6d9ca7a04bf15a9e4ebd951966c61527aeb526e8a8cc8" => :yosemite
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
