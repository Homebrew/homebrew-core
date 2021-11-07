require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.131.0.tgz"
  sha256 "62c3f42fc33cdbdfd52ec865881a3f845c6470cf23962fdc45c7336c49d112a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "346e91052f0f93cbfa5d4ed03f900d818e781ac2335446e18f41325bf9754201"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "346e91052f0f93cbfa5d4ed03f900d818e781ac2335446e18f41325bf9754201"
    sha256 cellar: :any_skip_relocation, monterey:       "bd272042e0c40ec6b1d3c78df91c2be7b7fd3eb3996ecc55e867c82f6550c41b"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd272042e0c40ec6b1d3c78df91c2be7b7fd3eb3996ecc55e867c82f6550c41b"
    sha256 cellar: :any_skip_relocation, catalina:       "bd272042e0c40ec6b1d3c78df91c2be7b7fd3eb3996ecc55e867c82f6550c41b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "346e91052f0f93cbfa5d4ed03f900d818e781ac2335446e18f41325bf9754201"
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
