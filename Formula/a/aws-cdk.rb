class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1138.0.tgz"
  sha256 "38d8d842afd9beb5d64713babfa4791d8da7dd4b88f543a309eac53e48725e1c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bcf2eb215bacb10c3f0caa0296246a6802bf8b77f0d39d1f48a6243107a69cdd"
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
