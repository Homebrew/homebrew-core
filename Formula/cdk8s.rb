require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.40.tgz"
  sha256 "de37abd12e982ffbcf4c40557d6ed29230fc38c5cf997969cd55216e7fc3b601"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a1564cf6f6115354ae2f281cb6dcd124ef8dcffd317b4c908bb17d358915b60a"
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
