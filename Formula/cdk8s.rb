require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.141.tgz"
  sha256 "26a9400cd4c5fbcb92e07d4b760ef8e1196767eaebecb5414769c5c11cb55e59"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f426a09d670ee4d5c9bb9aae7aa50e901a4c027d7f2b45c1f87004c8b51c5564"
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
