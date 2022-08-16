require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.85.tgz"
  sha256 "09fc2561be8fdee09bc1b76b357f79b34f9978c2b757b09b68ca6a5c0cb40e6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b92c105e95a3e24fb03581c43f3aea9c86c6b1771340c7142b92880d222d90db"
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
