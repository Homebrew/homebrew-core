require "language/node"
class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://bitsrc.jfrog.io/bitsrc/bit-brew/stable/bit/0.5.0/bit-0.5.0-brew.tar.gz"
  sha256 "d276985d777657a4c9e5b3d5556cf5d5a05d3faf5ca88fcc993563a8b445aa5b"

  bottle do
    sha256 "003e4ce34fd481171e0dc932248d61ae115e562387afeffd2b409c8e110e14f1" => :sierra
    sha256 "464ca185774365c3c51a53a38bf95da4d99214568f721a97b834c9e656232e53" => :el_capitan
    sha256 "54a0cfc3a89d9b6eeeedf2d8f8e9c091242ca73b6f7a91edfc9ee48e6f7ad185" => :yosemite
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
