require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.50.tgz"
  sha256 "f80c204362254e28c9b15a31e60afd136be23c90fb3edefb29350f8586a286f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7ea392daeb3ee69aeadb70de55ebf5f6dd6403e363fe443b5fd514da16dec179"
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
