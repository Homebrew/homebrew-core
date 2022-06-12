require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.18.tgz"
  sha256 "f5c50dd6319369c4532f77d1f4830a20d9838501a4828381f95cdd7bf7fcaa9a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5fbbb972c15a1162966a341511a3d7ec847f447a1f1c9437225fb8745b58350d"
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
