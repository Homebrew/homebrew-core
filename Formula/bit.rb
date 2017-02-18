require "language/node"
class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://bitsrc.jfrog.io/bitsrc/bit-brew/stable/bit/0.1.31/bit-0.1.31-brew.tar.gz"
  sha256 "e4df0bdabd21c9f9af81850a044ad9ea61c4392fe1515538e3462c4a00772071"

  bottle do
    sha256 "36233f829327aba3ac496c228ffa476d7c43d4621954474e58dc5204dddb1199" => :sierra
    sha256 "a1cea9b6906023ba2e21723856008d9a3f1a04993ef08309d8f891158dd48bf0" => :el_capitan
    sha256 "c92bd435ec019ed5cf8a287951acedc7c9d0c7931f0c22aa9512fee89e074291" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", "-g", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "successfully initialized an empty bit scope.\n", shell_output("#{bin}/bit init")
  end
end
