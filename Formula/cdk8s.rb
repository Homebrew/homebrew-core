require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.77.tgz"
  sha256 "854fd86436611b5dfc66a5cb92ca9e7adaf2699fe86d778dc77d2a9c500282c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4ad379e0c219d1b1e7c13066fb377e33b83b8fa411621b57e5a9310a35929db4"
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
