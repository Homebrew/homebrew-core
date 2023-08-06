require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.23.0.tgz"
  sha256 "9001c6b4c9b89d4049548e172d97a6d160c469193b1394333bf4ede3f86dbc8e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5a42bdffc18f1adf4dc1cc37e92ec0d628a15942bb2b59920b18ba382ca9e29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5a42bdffc18f1adf4dc1cc37e92ec0d628a15942bb2b59920b18ba382ca9e29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5a42bdffc18f1adf4dc1cc37e92ec0d628a15942bb2b59920b18ba382ca9e29"
    sha256 cellar: :any_skip_relocation, ventura:        "ea0f18dd4c8cafef418955e371363484b456e1fa45ff3e1a28f32d83e233e746"
    sha256 cellar: :any_skip_relocation, monterey:       "ea0f18dd4c8cafef418955e371363484b456e1fa45ff3e1a28f32d83e233e746"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea0f18dd4c8cafef418955e371363484b456e1fa45ff3e1a28f32d83e233e746"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5a42bdffc18f1adf4dc1cc37e92ec0d628a15942bb2b59920b18ba382ca9e29"
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
