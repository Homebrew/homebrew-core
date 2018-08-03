require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.3.0.tgz"
  sha256 "e587255300cfd8e8be5afa5d9497bdb612eeeca5e165d65bd05fbd2e041ec840"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fauna list-endpoints 2>&1", 1)
    assert_match "No endpoints defined", output

    pipe_output("#{bin}/fauna add-endpoint https://endpoint1:8443", "secret\nendpoint1\n")

    output = shell_output("#{bin}/fauna list-endpoints")
    assert_equal "endpoint1 *\n", output
  end
end
