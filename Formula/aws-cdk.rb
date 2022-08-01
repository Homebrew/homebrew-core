require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.34.2.tgz"
  sha256 "904eb71d03ca13db0f3ae32ab74c55674d2be6e8499205fc0d4de98f7f09e76b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19fa99ff6a419e025809e99ced638a3973e119b107f1dc0a3460d4a2f1776b53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19fa99ff6a419e025809e99ced638a3973e119b107f1dc0a3460d4a2f1776b53"
    sha256 cellar: :any_skip_relocation, monterey:       "73112d63f941263602cfd66b05fa53bb768224144902b7a0542c915450d00f3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "73112d63f941263602cfd66b05fa53bb768224144902b7a0542c915450d00f3d"
    sha256 cellar: :any_skip_relocation, catalina:       "73112d63f941263602cfd66b05fa53bb768224144902b7a0542c915450d00f3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87a53942c4def93e45177d5618b9743b0257fd5728c635c8a1343a97de66ad6c"
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
