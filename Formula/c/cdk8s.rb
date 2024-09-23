class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.226.tgz"
  sha256 "84b761fc6eb2a7e14ba4ab9f3c0d81cb82637590c2a79696e118fb6e3fca00a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "554b572f40920fe21f21f8a0686cd9b56616643a0ecc57df10de00bcae8f3531"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "554b572f40920fe21f21f8a0686cd9b56616643a0ecc57df10de00bcae8f3531"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "554b572f40920fe21f21f8a0686cd9b56616643a0ecc57df10de00bcae8f3531"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ed460c002f8160e3c3b9074b7bd1467afc5146c6f321e6ae33a6a470cd99e20"
    sha256 cellar: :any_skip_relocation, ventura:       "7ed460c002f8160e3c3b9074b7bd1467afc5146c6f321e6ae33a6a470cd99e20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "554b572f40920fe21f21f8a0686cd9b56616643a0ecc57df10de00bcae8f3531"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
