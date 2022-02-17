require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.99.tgz"
  sha256 "e94d69c23f132d4192fee8120f66ab97c93216ef88c6ffb3dbfd2861dd6b61ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a7b046a6d7ed0ffbd927e56ad03ad141d8ebb42473061a4c7341dd3fb54b7ad9"
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
