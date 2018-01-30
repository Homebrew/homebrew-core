require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-0.12.4.tgz"
  sha256 "2c5467c2ade676e451be0b996a7e02d3e6e7d0402a732159aa3371007429f610"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "daf8db77f7180e7b62ab417cfbb5d2175c70191697e9f8fffa8efb8af6361c69" => :high_sierra
    sha256 "c20164e2f332235ead6bdb1f29abc3086a0dfc8f46ae4ad64e1c539c7a0bea21" => :sierra
    sha256 "71f9ee040854d528b3cffcf20b7cda21e8040eef5960b177385cae42d85f6931" => :el_capitan
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
