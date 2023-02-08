require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.130.tgz"
  sha256 "9e0ce3e8d1bc7dc276d7d32fe82b9268a6a74a7a08d0799a538bf287568b7c8c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "309c2ad518d4d94a815640d4e84b3c42256bcf1c01ec2a5ce0797ba54f277d81"
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
