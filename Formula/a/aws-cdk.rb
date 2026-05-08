class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1121.0.tgz"
  sha256 "a0771c48a927219407271e15a0fe4c63f0c9ed1f4e103d466e5dd7be8834e6b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "808a93ea4117bef5f8ea0a78bac5ee52617a86d58e777162ee6ce960c029db8a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
