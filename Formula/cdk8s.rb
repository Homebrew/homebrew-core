require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.136.tgz"
  sha256 "6ab737b311ca40275f31eebbe46f1674f641b182dd862d4b072c6cb925d7bf01"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a465b49477cd485e0d0a46c4f0fdec626fc11a59d543d221bff6efa5c2206600"
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
