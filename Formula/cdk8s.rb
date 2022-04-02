require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.140.tgz"
  sha256 "0d3d20285187892f381fc17af80b6f3e6aa593da0da78ba05930fadcc0bd45dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4f0dafa2e0dfe09dbfc6dd716a913bee58a6af4ff0674ceb3aedb6184732df61"
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
