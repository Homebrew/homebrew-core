require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.9.1.tgz"
  sha256 "a0366fada1bda0df97dc959f4659ee67398671f6b5649f7d54918bbe0db87ddc"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4a418c01e171056160c918cf9d4b6468210d0534dbe24fc8b92cc73aa532890" => :mojave
    sha256 "e656b64816991af27e040ede92a3721dc7d38138dff1938a146b8167830d2ac1" => :high_sierra
    sha256 "4f686b8c8203bec46be5a517b9da9d8f23c80af30c9f2e8e9387375533798f3c" => :sierra
  end

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
