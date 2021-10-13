require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.0.tgz"
  sha256 "d0ed159085f32d5d02d822d633bc62c9438117d1ee4c279bd5c9b26975f667fe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "19dd25e4eda25ef384d06e08467248741f4a0e0b416140f8cc9bc0d669de26cf"
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
