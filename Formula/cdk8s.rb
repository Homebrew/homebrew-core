require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.42.tgz"
  sha256 "66489e0b087c5095953a48077b62b4890a1c73f762f35f6bd4fbb39c3a1a4ecb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f9b05a204b21c7fddefa45069c47c913badc67878ddc61da983706a80dc1d2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f9b05a204b21c7fddefa45069c47c913badc67878ddc61da983706a80dc1d2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f9b05a204b21c7fddefa45069c47c913badc67878ddc61da983706a80dc1d2a"
    sha256 cellar: :any_skip_relocation, ventura:        "f3d2144bb6a0570ba1bf1a9e1f9373b2dc1023f169df16b89c01d52c03102432"
    sha256 cellar: :any_skip_relocation, monterey:       "f3d2144bb6a0570ba1bf1a9e1f9373b2dc1023f169df16b89c01d52c03102432"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3d2144bb6a0570ba1bf1a9e1f9373b2dc1023f169df16b89c01d52c03102432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f9b05a204b21c7fddefa45069c47c913badc67878ddc61da983706a80dc1d2a"
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
