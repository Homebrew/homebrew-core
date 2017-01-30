require "language/node"
class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://bitsrc.jfrog.io/bitsrc/bit-brew/stable/bit/0.1.12/bit-0.1.12-brew.tar.gz"
  sha256 "122ec737cca207bba1fa9ae6e3ea22acf53cecd56b542a2a5bacd380a88bdef9"

  depends_on "node"

  def install
    system "npm", "install", "-g", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "successfully initialized an empty bit scope.\n", shell_output("#{bin}/bit init")
  end
end
