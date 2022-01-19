require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.79.tgz"
  sha256 "dc6fc0d4cd996646180abda50ae654ddc43d4bcf5c31b91ba7d6a5ee06461113"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2702fe1c68e5c58cfcc4d72dbd757efdc590cac38aa63a3485059a7972084515"
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
