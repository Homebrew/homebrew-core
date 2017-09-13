require "language/node"
class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://bitsrc.jfrog.io/bitsrc/bit-brew/stable/bit/0.10.3/bit-0.10.3-brew.tar.gz"
  sha256 "e843e29b34ba8c93c68503f288be28c841c159b67a54bcc88063328167a32785"

  bottle do
    cellar :any_skip_relocation
    sha256 "67a6a52d87f99c90171b82f1f10c784a686969a30366e5c119d6b450a04271bf" => :sierra
    sha256 "67a6a52d87f99c90171b82f1f10c784a686969a30366e5c119d6b450a04271bf" => :el_capitan
    sha256 "67a6a52d87f99c90171b82f1f10c784a686969a30366e5c119d6b450a04271bf" => :yosemite
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
