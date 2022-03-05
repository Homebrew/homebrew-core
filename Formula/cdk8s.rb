require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.114.tgz"
  sha256 "733c8bf8c7653a5214c90ab9449e206d145cffce80c514cb8886c7e560946588"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "922190ece4a29997c57ea05229ec3cb3785cfa4f2210a0e6aeeba6a2a2da17a5"
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
