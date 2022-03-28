require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.135.tgz"
  sha256 "436fc90610d67ea1e1c069eccf2d9ae7e88666dc7482bf8d6654fa2208549a3b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f0263576e73092916c16d07c813b1dbaff7d8b521f2fd32dace03fae981479b5"
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
