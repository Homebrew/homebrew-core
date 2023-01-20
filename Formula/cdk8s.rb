require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.111.tgz"
  sha256 "c0fd50db17242df29830f4d08edb2c02a82a7e3647625633a71fd59b537fb178"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5363eac8be4be9ae6157b6b458b96b35045dfb793f10803420229b193cecf146"
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
