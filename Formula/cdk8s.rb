require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.7.tgz"
  sha256 "42569bce2cc9ce34126c03cc87dccf51bc1ade187ed760fc206fb618ce1a9735"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0da0acc12a05c0010572510dfa05d533c7af83ad3e0d805de57e9948e41e66f3"
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
