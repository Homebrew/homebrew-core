require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.113.tgz"
  sha256 "f89294f150327ee6592370aeee92fd9bb109379fb384acff93ffb856c7774121"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8946d9df5b0f91f6959634a90ef575b746db43543542782bf3ffc5275e50c85a"
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
