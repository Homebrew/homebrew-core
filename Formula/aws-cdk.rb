require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.129.0.tgz"
  sha256 "8ecd5f707bc4d523b9e6e1e7620485b3949f33348e83380d3faad60738ae200d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83f7d05336bbfdf47fa7ccbed5c2d29881556b6a121bf02aa8cc90cea9c9f9bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "919458ba739ea375465260cdb35fabb1d5edd47d5b7052e04ed4fcdfd8a92bb2"
    sha256 cellar: :any_skip_relocation, monterey:       "1433d0cb501a7a94a550079cd8d2c17a02cc4a0b93cd8a931cd7adf2fa3e48b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3072a643ee022a5e935e4e1f9eeaea969d447b2e6671e70d37da02d46c3abc3d"
    sha256 cellar: :any_skip_relocation, catalina:       "3072a643ee022a5e935e4e1f9eeaea969d447b2e6671e70d37da02d46c3abc3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "919458ba739ea375465260cdb35fabb1d5edd47d5b7052e04ed4fcdfd8a92bb2"
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
