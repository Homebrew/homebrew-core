require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.109.tgz"
  sha256 "0401744a310ab5c3e411763f7377e72a26c1931b8c4e625be375939d7c641be6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fe7d2ea4abbe938b0ff6124153700de033d66961ce42a860425331373268194a"
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
