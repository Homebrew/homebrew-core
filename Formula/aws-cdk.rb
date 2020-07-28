require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.54.0.tgz"
  sha256 "df90cf2eb87f519b4eff85e707feb49696ac8b3156d4c634196b175a71c066c6"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7ff29e8a300c9f4533767db5ebc00bf268fea7f276cb496fbc6e766bbe9fa48" => :catalina
    sha256 "37b541a5f3a8c1d22401f2e2dd58c9bf391ed1c916c4e478079c2cca5e6fc974" => :mojave
    sha256 "0aa12267d6b30f5f420c5a9a5d2ba3cd7f84b7ec609de289e98bcf1a749b4da0" => :high_sierra
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
