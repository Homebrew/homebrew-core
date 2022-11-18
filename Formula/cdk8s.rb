require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.50.tgz"
  sha256 "f80c204362254e28c9b15a31e60afd136be23c90fb3edefb29350f8586a286f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d65314c4c8d4a1613db2edfed52d29081d24cfa2eed3403b5d4f7d4e4a67cd44"
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
