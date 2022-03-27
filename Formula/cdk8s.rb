require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.134.tgz"
  sha256 "33d62e6616283a901ecb10cabd060093d30f48c7d1c3b9194c230aca1424b0e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "32dc6f61796e29bd76b56a4119996fd75aff5aeff5b40dba1dd6c14b9dbb32f8"
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
