class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1003.0.tgz"
  sha256 "be1fa00ccbf9d848477203af87eb0eda02e830b02c46625e2c06326afd8a0051"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cecdb1217f7de5297bece44aceaed5d2686840e899b9e6adee665ce819c3c36b"
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
