require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.66.tgz"
  sha256 "f85a0b6c3a12d83cd62e4eb3f717d1d890d38d6a3f52d01fd0811ff77dd0eb62"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b66ab6f8558d5f45fd188cb7f33ff8124a95bfdba6c2bb4107b526677859f897"
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
