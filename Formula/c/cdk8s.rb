require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.97.0.tgz"
  sha256 "51a02cec213d86ab294eae3890f8291f3b7783d11a11f1ba2d84d15eefc25f6c"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3b2308ef83061087aa96c0f60748f125a4beabc724e6a29be51431af1bdda97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3b2308ef83061087aa96c0f60748f125a4beabc724e6a29be51431af1bdda97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3b2308ef83061087aa96c0f60748f125a4beabc724e6a29be51431af1bdda97"
    sha256 cellar: :any_skip_relocation, ventura:        "95f68664c12bdc2a0df67a863bb783e902c932734d00df41b60bcf794aae86d0"
    sha256 cellar: :any_skip_relocation, monterey:       "1bf6be0c9a053d513fa1efb705e1116e81d18fdfc14d9f8b29fa7d913fa734cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "1bf6be0c9a053d513fa1efb705e1116e81d18fdfc14d9f8b29fa7d913fa734cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3b2308ef83061087aa96c0f60748f125a4beabc724e6a29be51431af1bdda97"
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
