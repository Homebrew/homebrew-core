require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-0.12.7.tgz"
  sha256 "b003e589e4f30b277e78104811c9fa8407b6c8688c12b315a1a8f47243b2c346"
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
    assert_equal "successfully initialized an empty bit scope.\n",
                 shell_output("#{bin}/bit init --skip-update")
  end
end
