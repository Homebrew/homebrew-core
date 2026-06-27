class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1128.1.tgz"
  sha256 "3821e2e4e9f213620b35b93091a407cdad1dac48b0d5dd58f485bfa880e2b290"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9aa11584e46e6dcebf808a621f3c8a89ebe28ee7ec5ced7c9c9b4f0ab6073e8c"
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
