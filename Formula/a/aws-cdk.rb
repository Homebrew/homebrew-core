class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1148.0.tgz"
  sha256 "0ba4ec9690eca3bf77be1eed0b9c84a2f194b494ae8e18f9541fd24a9cbdae30"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d024c924f728e2c933c25fec78f5ed37fff123d862c7ff47db0fd4e185c0c3d8"
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
