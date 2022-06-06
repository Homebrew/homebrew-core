require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.12.tgz"
  sha256 "a799ad09f94c46a7daf5392400e75bbc2abdb262e76c993b7bc16154dc26cff7"
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
