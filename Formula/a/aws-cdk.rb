class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.172.0.tgz"
  sha256 "eb0fdbe62676d46b46ec857efaae3729bc40b49513ff5daf9afd8e371bfc4b30"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3249cb3e2750942b59319577e61af6bb18c64537ca13b45e6e3566438f981188"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
