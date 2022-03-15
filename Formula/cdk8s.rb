require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.125.tgz"
  sha256 "8a7b651bd936013a0211b889f38091281d01d0f9cc62a38cc3793adad3b267e3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bbd9560226038c9fc7208f6c966ad66394c7d9786dadd37b84d1ae5fdf03fac8"
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
