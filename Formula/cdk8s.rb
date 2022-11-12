require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.44.tgz"
  sha256 "af4b3a33e654d59b0cee4337a7f0630024d07cfd86048fb8158a08dedb51e819"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "216c87ca93608b47b914c8af40e57e1d092cbaf21b382e3bb2826aa68085ae79"
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
