require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.138.tgz"
  sha256 "2de3a55bcb5274f8d74a52c467d01ff7c8cf6ad8ce1d63ab6349115510013e82"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4ee09356116292d97d98f9a2bd1ea6995dfda12136ff8b642607caec7ccf4749"
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
