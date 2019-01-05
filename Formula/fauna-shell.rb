require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.9.1.tgz"
  sha256 "a0366fada1bda0df97dc959f4659ee67398671f6b5649f7d54918bbe0db87ddc"

  bottle do
    cellar :any_skip_relocation
    sha256 "54347a4bd6cdc4e98928e166505568b4c243a4cd9610c27edb6ffa9d3c62ec9e" => :mojave
    sha256 "8c194e6b0ac94ed7759c3bc31757637f47994c7a3238445561f9a4ec4d66bc1f" => :high_sierra
    sha256 "5dc68f2b050e51206004f88b73e2b59bc1b0509912e415306416042916b63de6" => :sierra
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
