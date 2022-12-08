require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.70.tgz"
  sha256 "c89c03c7b7248fb26e81373dfcd07a29ffd2037fca8ef8104c8edff0a401d474"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d572800b12f9bd708669a4babe80544c8f927d660218c0a7be27dd84ad9bbcb1"
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
