require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.19.tgz"
  sha256 "f71f45cc9bb990c3a97c7f50d5662b5a11871e7e267eebd5aeac3a306de8f29a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aa433a6563609970abb4c9c90790afca11e862d57020b3a70be58a1f5f542f03"
    sha256 cellar: :any_skip_relocation, big_sur:       "aa433a6563609970abb4c9c90790afca11e862d57020b3a70be58a1f5f542f03"
    sha256 cellar: :any_skip_relocation, catalina:      "2dd068060f0bcb690bea26a1dd4646f1617b37fc37fe5d5b1de289a50c374006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa433a6563609970abb4c9c90790afca11e862d57020b3a70be58a1f5f542f03"
    sha256 cellar: :any_skip_relocation, all:           "2dd068060f0bcb690bea26a1dd4646f1617b37fc37fe5d5b1de289a50c374006"
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
