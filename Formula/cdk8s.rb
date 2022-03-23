require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.129.tgz"
  sha256 "b9f8fafb2b864a74598bed8ea76d378ae432da5659d1823f45af0eaeb976e4e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "42446913196fa2d8d791d3140fc68fb2dc47948bc0b773935b8df3ae51853556"
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
