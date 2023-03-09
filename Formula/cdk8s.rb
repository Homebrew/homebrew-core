require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.154.tgz"
  sha256 "54d3e59cc1012dbed4f61d4249e9f9f4a7df3f1a310f701b778e4cabf4308283"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5287b5758d96d5cd87e05a4a649fddb21e7a62ff7225c20e45b8a1c82f470395"
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
