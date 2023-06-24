require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.73.tgz"
  sha256 "4b7a3bba31ec2470e7727490574bf8b8743049adc443b32ad7651d0c66edafc6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b6139447f5d0241d3511c8d893fbed4003b3eb0ba6c6f56ae01dcf6b4b0872d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b6139447f5d0241d3511c8d893fbed4003b3eb0ba6c6f56ae01dcf6b4b0872d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b6139447f5d0241d3511c8d893fbed4003b3eb0ba6c6f56ae01dcf6b4b0872d"
    sha256 cellar: :any_skip_relocation, ventura:        "29bebcf9da9a2ecdce0d8fe8eee7abda0d229b0710bca28c4ef4210a4bbf82b8"
    sha256 cellar: :any_skip_relocation, monterey:       "29bebcf9da9a2ecdce0d8fe8eee7abda0d229b0710bca28c4ef4210a4bbf82b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "29bebcf9da9a2ecdce0d8fe8eee7abda0d229b0710bca28c4ef4210a4bbf82b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b6139447f5d0241d3511c8d893fbed4003b3eb0ba6c6f56ae01dcf6b4b0872d"
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
