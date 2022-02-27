require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.110.tgz"
  sha256 "9db801494878ab44088f9758fb2e8b8d86d5b09ab56a11c10af4a4b573031d3f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a1b683e35038cf17fcd19f56ed18d32f976a805b7cf4bc8974558a26823a1888"
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
