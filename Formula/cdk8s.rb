require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.70.tgz"
  sha256 "cb610d72b3ab2e9c186760ff4d7719cb4b29f4de5dfa6a19493f824fe1ad2022"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fb010173802a2f445bc50245d80ff27d33b4c6c44c78b41f063b31136a6aaa78"
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
