require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.83.tgz"
  sha256 "d717a7ab9df1f5bb190b720f4716a2345bd9b559ff99d07d94cb97172f3e2094"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ad81d63b776354c4db8b3988954fa93b20a0d69608a08000ee1bb00852971abb"
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
