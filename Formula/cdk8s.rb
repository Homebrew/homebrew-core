require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.15.tgz"
  sha256 "4a3951f70f89e83fd1581e9a0ecbb1d053501afc3d36a037f7454e165c733cc7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a17d6d9099e87bf554654d8efae9b49e442fad52db34bf08d2a553758fd3f56d"
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
