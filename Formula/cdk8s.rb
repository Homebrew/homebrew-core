require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.159.tgz"
  sha256 "06c362b2dc386f8bd17ebcccd0769f54ef742e0b4b2bc6c69c6a7ebab2073c01"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6391df8399d7cf4d55c448f8b0995722b03ca6ad468aba144aefa6be5d845445"
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
