require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.128.tgz"
  sha256 "98c68dc52b55e348f59a5076234b5660694aa9266d103276a78fe6d0636d2e08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b70db98857fe792433c1b2df5f5d8125959a144c46aba289df9dbd51f63c8ecc"
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
