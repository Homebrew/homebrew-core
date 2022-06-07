require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.13.tgz"
  sha256 "a050d7cba1c788a797b228b8ba1a5657531c7b39c0119b3c562277b12991259b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b0b9efea0734904192511e2b1f50004346107ec534ab7b2fb0aaee54ca37eb96"
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
