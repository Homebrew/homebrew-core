require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.42.tgz"
  sha256 "1fa0a7777d3ccad460dd3d2b11ad7a08ea87283f7c726fd0167fbf0aa153668c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6dcd77a098627fb6ca14a1353f5093e183e70565b1c1ee5521b92a342dda13e0"
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
