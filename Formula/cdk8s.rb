require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.156.tgz"
  sha256 "5b59b645a16370b23ca95a7188f66b2ee58a6214e2265df6662a79e38cd5bcc7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "87e4b3688cb4dc9427557682c17a019d711d9d0beada982f5e204a76de6ce585"
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
