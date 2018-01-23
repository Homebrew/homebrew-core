require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-0.12.1.tgz"
  sha256 "2925d6bb6cebb01475b63c71fbb37b57e4f6a83e88a538cd7120fa60e85c62a9"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "652afa21bdbaa757c46caff46a92926364fcead1a41f4cf9cbb429f6f29e7948" => :high_sierra
    sha256 "e030581dbdb48278ef20342057f17ffdca6b1f5ae28cd962133e2b515b05c9a6" => :sierra
    sha256 "d3624aaad79f6052f3f8bca7339747a3bb16f66dcfa293bb0e178e8c3da65dc0" => :el_capitan
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
