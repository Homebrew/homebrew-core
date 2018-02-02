require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-0.12.4.tgz"
  sha256 "2c5467c2ade676e451be0b996a7e02d3e6e7d0402a732159aa3371007429f610"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "934cc950ee0c248ace5ec5d70e5c6cb4bb29b6a23f78a3c99172e3dc49234bb2" => :high_sierra
    sha256 "445a6dde9d9453350e7d6ff7eb2fc072501dbd457586f904cb046b59db385199" => :sierra
    sha256 "45b261489cc322ede5dd07c23f9ffabc9214f5f07efe1f481f86119cb242c04a" => :el_capitan
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
