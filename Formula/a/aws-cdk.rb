class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1104.0.tgz"
  sha256 "ccbd29477c478f113e31890fab2baca978e9cac31752797819f73abf8c425fd3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c13a32aa68be3d0815fe8b07cb1629634c95cb8fd06a5d818f26aaa7e631281a"
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
