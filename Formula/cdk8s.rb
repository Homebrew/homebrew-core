require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.123.tgz"
  sha256 "7861fad1e4d3ecb2c922dc223c384dae547afde83316c9727a4c868fcd7a6cbc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b51ca8c6bf311419033e15cf45420a643d4e028707c937b3c75e736dcfa00439"
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
