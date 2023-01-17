require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.108.tgz"
  sha256 "5c90bc0a3730962a26b876b920cc84a870bdc46f4b77fe3113868eb2bd48de08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2cbafcfac282e50b79017eb7cc833359f87396dfc3ad79e0b7c6c93d60b6886a"
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
