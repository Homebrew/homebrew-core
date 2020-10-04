require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://github.com/awslabs/cdk8s"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-0.30.0.tgz"
  sha256 "9e53bcf5b0aa3b1ae49cdb3929c0d665eb4b8d2b456262c09107496bc48fb566"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1f51d3bf8fc9522bc19e7ae8b2b17cc3caf9ea0a2eb1c498ba5f52ab24096e2a" => :catalina
    sha256 "e6bb0b698277c6ff53b7d12aaacb2e355e8f9755f0c88f11fa64ad00b8dca964" => :mojave
    sha256 "4330280fe6cd0212020f3a877b54f81fa48da9b79c1d4586e0471f5182d2aadb" => :high_sierra
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
