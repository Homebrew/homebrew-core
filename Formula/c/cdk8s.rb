require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.74.0.tgz"
  sha256 "efb98f641431a632604643cfbdf6735897252b0dbaa8313f6e74f43514288e8b"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00c8f33c885a595c7c80c560cdd5738a2eeeac9e4a738c97ae2a02ea2162dcdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00c8f33c885a595c7c80c560cdd5738a2eeeac9e4a738c97ae2a02ea2162dcdc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00c8f33c885a595c7c80c560cdd5738a2eeeac9e4a738c97ae2a02ea2162dcdc"
    sha256 cellar: :any_skip_relocation, ventura:        "05aeefdb460ac4373a25a66d61ad471e3ec97d4ceb469c559c429c67974a2c10"
    sha256 cellar: :any_skip_relocation, monterey:       "05aeefdb460ac4373a25a66d61ad471e3ec97d4ceb469c559c429c67974a2c10"
    sha256 cellar: :any_skip_relocation, big_sur:        "05aeefdb460ac4373a25a66d61ad471e3ec97d4ceb469c559c429c67974a2c10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00c8f33c885a595c7c80c560cdd5738a2eeeac9e4a738c97ae2a02ea2162dcdc"
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
