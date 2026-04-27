class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1119.0.tgz"
  sha256 "7159472f31b88a7f42bf60883dc440d9158c90d15c0a12b8570b4fcaac18ac46"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c3a931f9e87b81da87345a43c76f11d67559e759c645bacb83e5b3c540c15faa"
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
