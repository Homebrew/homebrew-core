class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1033.0.tgz"
  sha256 "95f1274d21d858d95582d0a3ceaeab98713be462eabe653de1c6617fc9d3c49e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9a642e782f7183be5b32b6a8950cb00bfaabb5a97a318d95bff9eb4c14918977"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove empty `node_modules` directory on macOS
    rmdir libexec/"lib/node_modules/aws-cdk/node_modules" if OS.mac?
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
