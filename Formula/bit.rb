require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-0.12.5.tgz"
  sha256 "24736260d77f506a98cfcb45a746456a68c94b1c5d67c60d33c100909651d1c6"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "13ed85ce32d55c0bc3751586a527866ef4f7cdba5670d8b321d417bee242670e" => :high_sierra
    sha256 "1fa48ec840fe941af92f38d868f5f28f3691fdfbb69a4c06ede6ec229cb3fdff" => :sierra
    sha256 "483e5f027db0ffaa913e8277f9fbc55c199787874fd08e0171a966b3f2bdc593" => :el_capitan
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
