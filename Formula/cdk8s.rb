require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.155.tgz"
  sha256 "3cbd6a5c692ce7c7b6d971554c51063d9e169db4d8c9336664b7f49d346bc049"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "96611acc6d2b0cecadac31fce4a1f7eff31334eddbf5ebcf9d0a911aa06123c5"
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
