require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.53.tgz"
  sha256 "848e182256611f25a0b312627153d7f9832546be757b6836eda647cbe82670cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0350af527834f63554239b7caed7b80903255f676bb9a834304610d5e9aad85a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0350af527834f63554239b7caed7b80903255f676bb9a834304610d5e9aad85a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0350af527834f63554239b7caed7b80903255f676bb9a834304610d5e9aad85a"
    sha256 cellar: :any_skip_relocation, sonoma:         "af85f168b01146a8d75062a181c72232fd2c8ddc93800d511f2669276db75669"
    sha256 cellar: :any_skip_relocation, ventura:        "af85f168b01146a8d75062a181c72232fd2c8ddc93800d511f2669276db75669"
    sha256 cellar: :any_skip_relocation, monterey:       "af85f168b01146a8d75062a181c72232fd2c8ddc93800d511f2669276db75669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0350af527834f63554239b7caed7b80903255f676bb9a834304610d5e9aad85a"
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
