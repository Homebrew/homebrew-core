require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.121.tgz"
  sha256 "7b35377b3d4e9ace2cd009f3c0c99c51168305549a27ab558657b87f8fa46a75"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "51f76379d9a39a48d6a1f968d87272fc65211fb85e004d39b4b5d60f5b322597"
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
