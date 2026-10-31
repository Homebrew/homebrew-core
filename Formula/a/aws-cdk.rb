class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1147.0.tgz"
  sha256 "b23547d119bdd891667dfd77f87019d19e3de799b04a56cef80e868cd2432a9e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c0ed066a31a18330e36a66fa81ba38e128963f3a9e4574da4f13bca1505c9185"
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
