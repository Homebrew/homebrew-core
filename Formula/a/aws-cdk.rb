class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1020.2.tgz"
  sha256 "2f3590305095b4f90eeb76c5a6768875497d9582d44e50309d98ebd7b8749de9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4ee531f9347b8e5c49fc8cfa8d7c881cc7a173bf162f8f85e7a5d6ca0ed697dd"
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
