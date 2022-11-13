require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.45.tgz"
  sha256 "65c012b187579321b95920b2b6b5cc5580529f1de8287ebb79ba59e336fc5a92"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8e1dd3b876af035e406fe1b6ef62a2337cc8d6ac364276967bf06e7321ad4fcf"
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
