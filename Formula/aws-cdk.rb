require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.112.0.tgz"
  sha256 "2a223808867246e8f9acb3d72ed56b7b533a27f4a4fdfb4d72121340902581ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9a47ddc95830ae9f2ed8b9adf3a61cf7db5c56550dd100a786becb89b334f835"
    sha256 cellar: :any_skip_relocation, big_sur:       "e8c29668d9001dbd2efad55bf371589cf5073cae8a16978bd416c2a9f95431bb"
    sha256 cellar: :any_skip_relocation, catalina:      "e8c29668d9001dbd2efad55bf371589cf5073cae8a16978bd416c2a9f95431bb"
    sha256 cellar: :any_skip_relocation, mojave:        "e8c29668d9001dbd2efad55bf371589cf5073cae8a16978bd416c2a9f95431bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4918aba339aae6fe2fb6642b92b8b92f82d46c2c37b8d726add9d2d0cf75ffd8"
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
