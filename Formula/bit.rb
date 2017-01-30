require "language/node"
class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "http://104.154.76.155:8081/artifactory/bit-brew/stable/bit/0.1.7/bit-0.1.7-brew.tar.gz"
  sha256 "4957423b77965bade8a28c0215d33f51d9b8362121b22e1d1e1663c98546fe88"

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
