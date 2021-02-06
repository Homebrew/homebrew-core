require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.12.2.tgz"
  sha256 "25211083523ff83e89b71f2b9f571bc07fa607ee036a570e7db0b5d3c2543a0b"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e83784816f9eb9e73f027b25d9afd6dedc3b4f5eb7556c26a7bbe056c71c7b41"
    sha256 cellar: :any_skip_relocation, big_sur:       "18a734b293027c6659dadb8ceeced83da51122b3102d02cf2bb6e7e61b4b1681"
    sha256 cellar: :any_skip_relocation, catalina:      "d3f4ac9c423ba0eb2f7cb35fa3c577574982b6a6fcd1d4edb93b7156ff4c4e2d"
    sha256 cellar: :any_skip_relocation, mojave:        "af37d55323c798456afc7ad9ed936c057d143d23c266a2459e4717fae026965a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fauna list-endpoints 2>&1", 1)
    assert_match "No endpoints defined", output

    pipe_output("#{bin}/fauna add-endpoint https://db.fauna.com:443", "your_fauna_secret\nfauna_endpoint\n")

    output = shell_output("#{bin}/fauna list-endpoints")
    assert_equal "fauna_endpoint *\n", output
  end
end
