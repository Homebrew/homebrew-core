class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1112.0.tgz"
  sha256 "198f79dee821e8912ffe9b3ce87668671c9431b57f626e39b141506ed11439f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "787ffbf8775120976b4173bd6a59368379be899a6e50892dbbbd3343a37e6802"
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
