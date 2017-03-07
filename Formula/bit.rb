require "language/node"
class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://bitsrc.jfrog.io/bitsrc/bit-brew/stable/bit/0.2.6/bit-0.2.6-brew.tar.gz"
  sha256 "59b3ef677c99ddd2c07b28c15b90fc82d56019e30879c48b2fe099ebae8a7f4a"

  bottle do
    sha256 "03f5414552b1cadc5328ff540c5344bd40fb0ff89a5db2095080c760f9420045" => :sierra
    sha256 "92cf43f793cb91fdbda85b9e95f565aaaea612f4d6ecf41874587fd5585da8a0" => :el_capitan
    sha256 "89235cb38c0eaa9e6d7f1d2f3fe022647480744ff881f4a7842d51add4238acb" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", "-g", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "successfully initialized an empty bit scope.\n",
                 shell_output("#{bin}/bit init --skip-update")
  end
end
