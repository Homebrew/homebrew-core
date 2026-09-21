class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1142.0.tgz"
  sha256 "2dbb73cd4cc37e82494c364b754ce4dd1d33b84167657ea2ad7c55afb3426a10"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e2e2b5515bfc501bfb7e77fb2a91f095430b4f58f8c7bd1c1429b5eca8de69cb"
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
