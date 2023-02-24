require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.141.tgz"
  sha256 "7eb9d22a156299be69111cc35d14724cd31e5b24c84d8de7f2e7058ce033c9f4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dd97dcad3a89a3c84f6862584eac78c506b11c045ed95b75d842207fc202f661"
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
