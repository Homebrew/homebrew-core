require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.108.tgz"
  sha256 "c760b0894424d089c0f246c7430bc703d5f14ae5c66301b8c6deb252093edcc0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eb5e7e72a5ec3be175722ddb201be238caca966b44604e7c97457b3e3f603803"
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
