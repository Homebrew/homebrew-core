class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.88.tgz"
  sha256 "ea0e9b4baf05b8497ab1a72f2bd820eb56c1b7a9463135b75e6e852833ddb705"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d78a5ee147af754ed9a7a8c7af3286bdfa58321e0e254efe6205dac421fbdfe6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d78a5ee147af754ed9a7a8c7af3286bdfa58321e0e254efe6205dac421fbdfe6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d78a5ee147af754ed9a7a8c7af3286bdfa58321e0e254efe6205dac421fbdfe6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f713f974541cf62d3c00cc5e457cd211e1121e0e7122a4e50b997c36651b018"
    sha256 cellar: :any_skip_relocation, ventura:       "7f713f974541cf62d3c00cc5e457cd211e1121e0e7122a4e50b997c36651b018"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d78a5ee147af754ed9a7a8c7af3286bdfa58321e0e254efe6205dac421fbdfe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d78a5ee147af754ed9a7a8c7af3286bdfa58321e0e254efe6205dac421fbdfe6"
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
