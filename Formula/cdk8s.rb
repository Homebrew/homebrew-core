require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.149.tgz"
  sha256 "91663a40be26e81c0960854f9c158b81d1884ca66c2d464e81185796e1919dee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f36baad545b0f5c56c1a9bc870f5997318af8a5a83836f6d4536dc8255ba56d1"
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
