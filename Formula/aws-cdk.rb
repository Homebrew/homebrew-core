require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.113.0.tgz"
  sha256 "8eaa24ade568bd0b9ac4be7293c77bcafb1b73ee04bb8ea4cf3dd60207e429ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "08a575614aed21d2e2bda4f340be3fd069a634ccd2c9587deec61e44b5818e33"
    sha256 cellar: :any_skip_relocation, big_sur:       "c3f28bc7bf3b6aa7f9b0454526c090b20d24e4e7dc11e8b2dcb513169785d0c6"
    sha256 cellar: :any_skip_relocation, catalina:      "c3f28bc7bf3b6aa7f9b0454526c090b20d24e4e7dc11e8b2dcb513169785d0c6"
    sha256 cellar: :any_skip_relocation, mojave:        "c3f28bc7bf3b6aa7f9b0454526c090b20d24e4e7dc11e8b2dcb513169785d0c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c4ae4b719888702117d3bc508ca723b9aad0e13ca8108684da63545ac118f72"
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
