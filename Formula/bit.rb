require "language/node"
class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://bitsrc.jfrog.io/bitsrc/bit-brew/stable/bit/0.10.7/bit-0.10.7-brew.tar.gz"
  sha256 "acc73ed5b61f459ac12aee18dd15ce786fce905c6b65b0e0c29fdd945f7f361b"

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
