require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.99.tgz"
  sha256 "500ee832c1a13a8b114ec495d72b745897ca5337a5033d4c0a74467e5cdb8eba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "09dc1e74551468d68fa74964fd8df40cee5498942a8fbcefb2124eefb7f0f1fb"
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
