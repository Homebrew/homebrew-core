require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.35.tgz"
  sha256 "007625a7e787cbd9b4a47fbd528a996d580bd6e4d76ae3cb346617093e41609e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e6e0e67b527f6e65e7366a9f18332ef82a330faa5a27ad255ba8da2235362258"
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
