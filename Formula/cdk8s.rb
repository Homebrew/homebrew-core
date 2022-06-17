require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.22.tgz"
  sha256 "2781e99a2bc06beb75993982a0d52f9ad499a50a133030464938d30f65ef81a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9bb47794fb41e47648b4ec14a63af09ebd08800a831e61cada4cf6cce5b6e1b4"
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
