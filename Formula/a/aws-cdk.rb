require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.96.2.tgz"
  sha256 "b38c5d2c72eb5f978949c74f5eaf6f1d0fa53eb1dce6abea54dd7f3f1db673f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2947c519f64bb868ed179cfa67bd781aecbf6932de212bc5c194ae3e7161af06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2947c519f64bb868ed179cfa67bd781aecbf6932de212bc5c194ae3e7161af06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2947c519f64bb868ed179cfa67bd781aecbf6932de212bc5c194ae3e7161af06"
    sha256 cellar: :any_skip_relocation, ventura:        "6e22402e3574bcdc88d63b12ce04115057fb6e629712c3fac87cc1fde98275cf"
    sha256 cellar: :any_skip_relocation, monterey:       "6e22402e3574bcdc88d63b12ce04115057fb6e629712c3fac87cc1fde98275cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e22402e3574bcdc88d63b12ce04115057fb6e629712c3fac87cc1fde98275cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc8daf70845b217c369bb8e168ff41fccc7e35f52284c578bb9b1defd0603a75"
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
