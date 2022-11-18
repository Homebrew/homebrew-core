require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.51.0.tgz"
  sha256 "fb86fe3a39ce7cba9dd8b2a3dccba8941d204f900b04eb81623c3b9cf03b8ff2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43a826a1f6c29ad7f82a8226e375a7f9857e1993fdda2b812caf1c92f6998ffc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43a826a1f6c29ad7f82a8226e375a7f9857e1993fdda2b812caf1c92f6998ffc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43a826a1f6c29ad7f82a8226e375a7f9857e1993fdda2b812caf1c92f6998ffc"
    sha256 cellar: :any_skip_relocation, ventura:        "861d93c028aee5a2d4dbc691a0fb153cdfd4de57ed098a2461888980325a81d4"
    sha256 cellar: :any_skip_relocation, monterey:       "861d93c028aee5a2d4dbc691a0fb153cdfd4de57ed098a2461888980325a81d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "861d93c028aee5a2d4dbc691a0fb153cdfd4de57ed098a2461888980325a81d4"
    sha256 cellar: :any_skip_relocation, catalina:       "861d93c028aee5a2d4dbc691a0fb153cdfd4de57ed098a2461888980325a81d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d45557d1622a5af654272a853967487942fe5df394a3d78ac4f97b2a7d90e0c3"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
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
