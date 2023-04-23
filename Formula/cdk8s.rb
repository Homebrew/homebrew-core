require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.17.tgz"
  sha256 "509e877820eb91dc8f63185e84c4ecb0889499b918aa32595898195024405767"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a66e650240728dd6a27582e3092a68176077f0df67bb7581fea4e471ae93f2e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a66e650240728dd6a27582e3092a68176077f0df67bb7581fea4e471ae93f2e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a66e650240728dd6a27582e3092a68176077f0df67bb7581fea4e471ae93f2e3"
    sha256 cellar: :any_skip_relocation, ventura:        "702e75853177c78a5e3d233dad598c34eed0f5bbf7cbfd09019ec45d55db2a8b"
    sha256 cellar: :any_skip_relocation, monterey:       "702e75853177c78a5e3d233dad598c34eed0f5bbf7cbfd09019ec45d55db2a8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "702e75853177c78a5e3d233dad598c34eed0f5bbf7cbfd09019ec45d55db2a8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a66e650240728dd6a27582e3092a68176077f0df67bb7581fea4e471ae93f2e3"
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
