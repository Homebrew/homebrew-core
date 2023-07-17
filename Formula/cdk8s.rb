require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.113.tgz"
  sha256 "b534dac79e84a48f89d7cf4f3940df246b388296b32fd9d5593ce62972396f15"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d05fc32dbc052260af8de3188236cd36438d9b9a22e9016226034232b9ae05b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d05fc32dbc052260af8de3188236cd36438d9b9a22e9016226034232b9ae05b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d05fc32dbc052260af8de3188236cd36438d9b9a22e9016226034232b9ae05b"
    sha256 cellar: :any_skip_relocation, ventura:        "ce6b3a53d9aacf222520e4ec42426a9e2c468de7d17dcf95753f460fcea46354"
    sha256 cellar: :any_skip_relocation, monterey:       "ce6b3a53d9aacf222520e4ec42426a9e2c468de7d17dcf95753f460fcea46354"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce6b3a53d9aacf222520e4ec42426a9e2c468de7d17dcf95753f460fcea46354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d05fc32dbc052260af8de3188236cd36438d9b9a22e9016226034232b9ae05b"
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
