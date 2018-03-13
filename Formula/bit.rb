require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-0.12.8.tgz"
  sha256 "ec1c018a40d7be78eb6d816cc1d36ee8b99f1f908f282b286e81dd88f7c53290"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "702111be6a1dcb808fb930f3f09276fa1d352d80c46346d1d309728a4feec711" => :high_sierra
    sha256 "49ba113fd3ad1b86d8b6b06f5a4475927c46caa7eb39df511d6225bdfff290d6" => :sierra
    sha256 "8241c691a4e155f03270b468db87539986e8f2a2c1bb35f10aab1015e0b330f7" => :el_capitan
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
