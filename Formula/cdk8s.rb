require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.26.tgz"
  sha256 "9199116300c57014479df4fc6a79eef264978e8dd65fa15cea8519eece59dc5c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eecff572f9e40044f492923e4bae4ea9d2b90ae496de816105daa20c0a7107e9"
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
