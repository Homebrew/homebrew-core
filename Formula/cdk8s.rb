require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.161.tgz"
  sha256 "392d71817b9b5bc9fcc50a4e8b65a4d8eb685c465ad4617c6c77447438136c5e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a48476746ca855a77c6b32cf6a8392aeebac4f940c5cd7149dfd9657f46256f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9d7258269639f9065dc1ffaf709958053ce445b205a64f1a1519faf1968bd7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9d7258269639f9065dc1ffaf709958053ce445b205a64f1a1519faf1968bd7e"
    sha256 cellar: :any_skip_relocation, ventura:        "a48476746ca855a77c6b32cf6a8392aeebac4f940c5cd7149dfd9657f46256f9"
    sha256 cellar: :any_skip_relocation, monterey:       "a48476746ca855a77c6b32cf6a8392aeebac4f940c5cd7149dfd9657f46256f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a48476746ca855a77c6b32cf6a8392aeebac4f940c5cd7149dfd9657f46256f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a48476746ca855a77c6b32cf6a8392aeebac4f940c5cd7149dfd9657f46256f9"
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
