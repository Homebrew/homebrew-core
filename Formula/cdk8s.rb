require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.157.tgz"
  sha256 "8eed081c04302eb93ab0f85d4fb4f5605352bbcfec1dc38532b6aacecca1e614"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f503dafcd99cae555ae3814b3dac23308c1e8cc49571e7c933eb6da960fa38df"
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
