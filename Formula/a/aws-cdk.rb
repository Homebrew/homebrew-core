class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1030.0.tgz"
  sha256 "c3e577a3e23be957b7c953eaf8f7816b719a6274a78f913eaf2ea0f6c0082278"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9f7f684ef5a0aa927518f7fa79ff45dd5eeef9fb59f9540a808e56e472c48b4c"
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
