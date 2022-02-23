require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.106.tgz"
  sha256 "3b756fd104d5a82e194b3ff41f5051aad8fac49e404d5e45637b18f3c57d9705"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "74dfbfc7eb560b3bdfbcfd28b39839adf12ec368ca6a18245e858ab8b5ac602e"
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
