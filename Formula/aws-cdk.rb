require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.110.1.tgz"
  sha256 "1311a3b285fa129bcf613a0127d7d31efda3d7fc421f9eeca955e174da812723"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "90e1cdbccbb61125e771a6012ebe41beed8b40c6536a8935adce79e73a51d119"
    sha256 cellar: :any_skip_relocation, big_sur:       "4f88fa1d1382abde3855b98a447ed97f645d8601c25484a37302fee02d7cf00c"
    sha256 cellar: :any_skip_relocation, catalina:      "4f88fa1d1382abde3855b98a447ed97f645d8601c25484a37302fee02d7cf00c"
    sha256 cellar: :any_skip_relocation, mojave:        "4f88fa1d1382abde3855b98a447ed97f645d8601c25484a37302fee02d7cf00c"
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
