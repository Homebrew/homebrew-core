require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.1.tgz"
  sha256 "48e54d2f9fe0c27bd3c60b6617dd4dd91efcd71c7f57bc6982263ac5272c0ba3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "53e90d8000d5bd9ce2a7dcef509076768dc506fbbb327d1fae472cd759172f4e"
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
