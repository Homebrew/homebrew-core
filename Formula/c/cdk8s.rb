class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.206.2.tgz"
  sha256 "5932b225f2f41f0f77ca2f143fcd38ac59ba78794137f124f52e4cb13be4a6e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a7fe289f50efa4e15cf009a0470b2d71fc3a1b3a9416d299e4dcf8dd60d03fbc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
