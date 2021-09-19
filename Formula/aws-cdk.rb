require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.123.0.tgz"
  sha256 "212f717ca577fc623335938f6e9c937a9c3a6cc953d8032b15c7df019b97ba8c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dc690a861b47c991e91cad5d3424758ef512f1f49a9c11f99abbc9f1715c096b"
    sha256 cellar: :any_skip_relocation, big_sur:       "d325ce1595d489353cd712dbd52649a8aacc83492f2661f2244b34d8bf82b8cd"
    sha256 cellar: :any_skip_relocation, catalina:      "d325ce1595d489353cd712dbd52649a8aacc83492f2661f2244b34d8bf82b8cd"
    sha256 cellar: :any_skip_relocation, mojave:        "d325ce1595d489353cd712dbd52649a8aacc83492f2661f2244b34d8bf82b8cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc690a861b47c991e91cad5d3424758ef512f1f49a9c11f99abbc9f1715c096b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end
