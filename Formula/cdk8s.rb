require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.5.tgz"
  sha256 "30d4d99cdc3ebef23297f39ab1efb0561f2c2c3a7faba6ddfe49623cbce0d2fb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f610fdc571910d40cae3ef25c643a9d2e12a6d0edcdcf520a37a5a899154429b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
