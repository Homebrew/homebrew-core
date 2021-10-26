require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.14.tgz"
  sha256 "349b1643f5312758e252fc87bad7b4733d33c3303e6cbf21b6029d451135f5dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "87eabdfd4fe822ab95caa1dd4f01dbd9a2276233a6e19a021aba4f98c7fc63a0"
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
