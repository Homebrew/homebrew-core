require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.5.tgz"
  sha256 "e7888030705eed1986ae9b270e591b371112e972b3fc0b379034a7b4d7245a18"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "588383eb3532e3893c88fee349dd8c32448e5c1a25c05ca0ce8d768e5ca976e9"
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
