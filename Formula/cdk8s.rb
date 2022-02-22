require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.105.tgz"
  sha256 "d0a915fac757f7fe52426272eb9be996c0a8cc642ed2685e9cdf6d9b833f5ecd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "74dfbfc7eb560b3bdfbcfd28b39839adf12ec368ca6a18245e858ab8b5ac602e"
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
