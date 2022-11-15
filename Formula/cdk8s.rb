require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.47.tgz"
  sha256 "55e72637e461c48246efb43d398b7e1f31314e1cd2787261c9e7783aa675dfbc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0ae51e3448a61fd1df7318f1070f0ee65db3a890601b9e5cd147095ed80fe50a"
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
