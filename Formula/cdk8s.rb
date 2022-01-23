require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.82.tgz"
  sha256 "c0f5ad5a7bd73ac6b1312da5f36deebd1e5b6a47ec5512da5bf950550a6ff99c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "87def89b19fe6fdb0998e37b2221f5cf5e01aa32ba37cb04197df186b972b02d"
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
