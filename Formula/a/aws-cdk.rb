class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1031.0.tgz"
  sha256 "5b929a8e98cdaa63410ae93e8c9f1441cb0b6dcc02094d285d9223f2132ae790"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bd31141dc3f1437c2c2c9146793af7dc830f1d07be877eb58023c784de9d8afd"
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
