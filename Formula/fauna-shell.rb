require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.9.7.tgz"
  sha256 "59ab0114d3b79ce111a4db4979881df6470f80e438d09955d496e8bdb81172e2"

  bottle do
    cellar :any_skip_relocation
    sha256 "905fe9671372aaec8d490759c46f8597d013f66daff374e9a15a85d7ae008570" => :catalina
    sha256 "59b6a49acda7a80f6f98f5a31936c032bda1930ce7219597a5a6b588921e43bf" => :mojave
    sha256 "ffa70182046a3999e557ccf3fcc40065b6c1b3d43ba8ff71fdef18c9fbeb986a" => :high_sierra
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
