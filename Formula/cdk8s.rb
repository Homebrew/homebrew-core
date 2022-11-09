require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.41.tgz"
  sha256 "7f5e7fd01a1ea18c0a4a0827913ce7acdeae7d845c8ab922b505956c89a2077d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6759fdd01d9070bc18b592d1499fc301e12b667f01dc962f11d2ceefab53b6f5"
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
