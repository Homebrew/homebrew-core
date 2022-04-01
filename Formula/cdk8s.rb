require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.139.tgz"
  sha256 "e63a6bfd4e6ba9bbc1bc7fc28562c95c4acb6bc719b894f9db3453b9f8704fb5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4f0dafa2e0dfe09dbfc6dd716a913bee58a6af4ff0674ceb3aedb6184732df61"
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
