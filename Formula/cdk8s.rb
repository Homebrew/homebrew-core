require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.32.tgz"
  sha256 "76856223c5f30c0304e641e76f847e6cfb5083ac68f9be29b8ad1bf68951ecb9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fe7c607e82c89992d004cf185a59bc297ad372c5a0556f14e4bf7eabb3224212"
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
