require "language/node"
class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "http://assets.bitsrc.io/release/0.1.0/bit_0.1.0_brew.tar.gz"
  sha256 "c33c00a8334da4659b263472d013eaafbc5f0c16249e755f7624ac396d673270"

  depends_on "node"

  def install
    system "npm", "install", "-g", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "successfully initialized an empty bit scope.\n",
      shell_output("#{bin}/bit init")
  end
end
