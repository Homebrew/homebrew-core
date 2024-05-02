require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.109.tgz"
  sha256 "71ff5b3a29f3841a1fd518438a1d3ed5ac63aa99b626553a90bec15b8a560855"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ac7ddb8614b2b092a8ffc1415a94db0a2cc755964b0c2b67aa903f254404479"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ac7ddb8614b2b092a8ffc1415a94db0a2cc755964b0c2b67aa903f254404479"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ac7ddb8614b2b092a8ffc1415a94db0a2cc755964b0c2b67aa903f254404479"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4125ea5d9465bd86780c6c9a00761f93a71b08a724f9550cf8afa17923be60f"
    sha256 cellar: :any_skip_relocation, ventura:        "e4125ea5d9465bd86780c6c9a00761f93a71b08a724f9550cf8afa17923be60f"
    sha256 cellar: :any_skip_relocation, monterey:       "e4125ea5d9465bd86780c6c9a00761f93a71b08a724f9550cf8afa17923be60f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ac7ddb8614b2b092a8ffc1415a94db0a2cc755964b0c2b67aa903f254404479"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
