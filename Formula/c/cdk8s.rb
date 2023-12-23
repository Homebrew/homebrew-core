require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.17.tgz"
  sha256 "30df5c2bda9619f00800c7d9d66667c8606513036c877ee01d74925a91e39ccb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbeceed3dc2f9f9c4a1e62a9290e4612dbc05d89900fb4bac4bd1288d12c2404"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbeceed3dc2f9f9c4a1e62a9290e4612dbc05d89900fb4bac4bd1288d12c2404"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbeceed3dc2f9f9c4a1e62a9290e4612dbc05d89900fb4bac4bd1288d12c2404"
    sha256 cellar: :any_skip_relocation, sonoma:         "caeb5af982f34e1f526c66b79bfa7a29c3e480bdaffde889fecaf0ce767b5209"
    sha256 cellar: :any_skip_relocation, ventura:        "caeb5af982f34e1f526c66b79bfa7a29c3e480bdaffde889fecaf0ce767b5209"
    sha256 cellar: :any_skip_relocation, monterey:       "caeb5af982f34e1f526c66b79bfa7a29c3e480bdaffde889fecaf0ce767b5209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbeceed3dc2f9f9c4a1e62a9290e4612dbc05d89900fb4bac4bd1288d12c2404"
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
