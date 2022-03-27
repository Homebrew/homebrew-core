require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.134.tgz"
  sha256 "33d62e6616283a901ecb10cabd060093d30f48c7d1c3b9194c230aca1424b0e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f0263576e73092916c16d07c813b1dbaff7d8b521f2fd32dace03fae981479b5"
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
