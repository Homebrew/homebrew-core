require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.120.tgz"
  sha256 "1179476da6bf974a37dc156621d57fc992373344e69a8e9844a3c7a67277880a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "756cba437c758c212b526a81d5d90e8fbeaf2c946458d95b0bf2203dec5f4ab6"
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
