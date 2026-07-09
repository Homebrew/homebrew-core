class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1129.0.tgz"
  sha256 "997ef66623ac2b23086e217d4c23cbcf957532058466cd004ae66691d91d5ef7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "855a03e4ad3fd140d69f28d5d5b90fdc67617e742dacbee318ec096fd6468b81"
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
