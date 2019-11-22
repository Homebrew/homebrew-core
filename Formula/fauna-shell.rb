require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.9.8.tgz"
  sha256 "8c9710a1a18317e5cc755eb806bf407e2cc080fdcf93c381054761c85c6c4faa"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2244fe9ec29e830a907beca5859ee8fb728e7f45d523c80c7ece7752353d7d0" => :catalina
    sha256 "d0a212a8e1c2b38ef8380b6d154dceda5dc44807224a02528ef4355b5781a30f" => :mojave
    sha256 "5139600604f66f3935caa40f1924f452c0d6320c4d5cf0622eb061e96ab066a0" => :high_sierra
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
