require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.31.tgz"
  sha256 "5c50e1e74341ce0aa8c80dbf5bd1fd749b2bf5cfe4fa7ec87eb87dc8359a6795"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3d3ec2cb933914e740de7c8684f7d867ea7bd5245be03e8a540de5db9b4482f8"
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
