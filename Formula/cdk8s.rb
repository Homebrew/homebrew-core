require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-0.33.0.tgz"
  sha256 "e18eeb79e8764fb4da4c92fb0a14d4d44e06b0c571d3e719cb19ede1b36d6572"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a194db0f14501273228076576415c320578ab4cbc567742137646f73615c4b54"
    sha256 cellar: :any_skip_relocation, big_sur:       "5a974f74c2510849e093b0286aeb9d48bcadeb67caecb60108396b32314a0dfa"
    sha256 cellar: :any_skip_relocation, catalina:      "6a183f35fa611a82475eeb6ce8814bfcd3b06ef0fa26f19830a6e69ca9328426"
    sha256 cellar: :any_skip_relocation, mojave:        "094a4e184bf640dced7744a154140b6ec87d2c1c62d381ead9d695ad1dc05c39"
    sha256 cellar: :any_skip_relocation, high_sierra:   "8fd5ae70cb00cf12f8d9ad75eef53e99f9b3ced3fa0987bbcc88c9fda81313d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce0001a627dc7c29e3bbccb8fcd2222c6f1562537109d2dc1daae04d96246d9a"
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
