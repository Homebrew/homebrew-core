require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.81.tgz"
  sha256 "b1d05d7097fbfc3c995b08db97c6cfaa5e6ee9aab442e4a3c82310e5975ba825"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4208b4cdc65acc5822a8f251f87c1a58de390e7db78a8d0d384e88933f53e4d0"
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
